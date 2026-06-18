// lib/pages/meditation_page.dart
//
// REWRITE: the calm breathing-circle experience now doubles as a gentle
// rhythm game. The circle still expands/contracts exactly as before for
// inhale/hold/exhale — nothing about the calming visual changes. What's
// new: during inhale/exhale, the user taps a "Follow" button in rhythm
// with the circle's growth. Tapping at the right moments builds an
// accuracy score, which becomes XP/coins at the end. Users who just want
// to breathe without playing can ignore the tap prompt entirely — scoring
// only counts taps that happen, it never penalizes inaction harshly.

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';
import 'stress_service.dart';
import 'mood_checkin.dart';
import 'stress_management.dart' show showActivityReward;

class MeditationPage extends StatefulWidget {
  const MeditationPage({super.key});

  @override
  State<MeditationPage> createState() => _MeditationPageState();
}

class _MeditationPageState extends State<MeditationPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sizeAnim;

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _musicPlaying = false;
  bool _sessionRunning = false;
  bool _isPaused = false;

  int inhaleDuration = 4;
  int holdDuration = 4;
  int exhaleDuration = 6;
  int totalSessionSeconds = 120;

  Timer? _timer;
  int _remainingSeconds = 120;
  int _currentStep = 0; // 0 = inhale, 1 = hold, 2 = exhale
  String _timerText = "02:00";

  int? _moodBefore;

  // ── Rhythm scoring ──────────────────────────────────────────────────
  // Each breathing phase has a "sweet spot" window near its midpoint.
  // A tap landing inside that window scores high; outside scores lower.
  // We never punish *not* tapping — score is purely additive.
  int _rhythmHits = 0;
  int _rhythmAttempts = 0;
  int _scoreTotal = 0; // sum of per-tap accuracy (0-100 each)
  bool _canTapNow = false;
  DateTime? _phaseStartTime;
  int _currentPhaseDuration = 4;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..addListener(() {
        setState(() {});
      });

    _sizeAnim = Tween<double>(begin: 150, end: 250).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _promptBeforeMood();
  }

  Future<void> _promptBeforeMood() async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    final mood = await showMoodPicker(context, prompt: 'How are you feeling right now?');
    if (mounted) setState(() => _moodBefore = mood);
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _startSession() {
    setState(() {
      _sessionRunning = true;
      _isPaused = false;
      _remainingSeconds = totalSessionSeconds;
      _timerText = _formatTime(_remainingSeconds);
      _rhythmHits = 0;
      _rhythmAttempts = 0;
      _scoreTotal = 0;
    });
    _runBreathingCycle();
    _startTimer();
  }

  Future<void> _stopSession({bool completed = false}) async {
    _controller.reset();
    _timer?.cancel();
    setState(() {
      _sessionRunning = false;
      _isPaused = false;
      _currentStep = 0;
      _canTapNow = false;
      _timerText = _formatTime(totalSessionSeconds);
    });

    if (completed) {
      await _finishSession();
    }
  }

  Future<void> _finishSession() async {
    final accuracy = _scoreTotal == 0 || _rhythmAttempts == 0
        ? 50 // baseline score for pure-breathing sessions with no taps
        : (_scoreTotal / _rhythmAttempts).round();

    final moodAfter = await showMoodPicker(context, prompt: 'How do you feel now?');
    if (moodAfter != null && _moodBefore != null) {
      await StressService.instance.logMood(
        moodBefore: _moodBefore!,
        moodAfter: moodAfter,
        activity: 'Breathing Journey',
      );
    }

    final result = await StressService.instance.completeBreathingSession(
      accuracyScore: accuracy,
    );
    if (!mounted) return;
    await showActivityReward(context, result);
  }

  void _togglePauseResume() {
    if (_isPaused) {
      _startTimer();
    } else {
      _timer?.cancel();
    }
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  void _runBreathingCycle() async {
    while (_sessionRunning && !_isPaused) {
      setState(() {
        _currentStep = 0;
        _currentPhaseDuration = inhaleDuration;
      });
      _armRhythmWindow(inhaleDuration);
      await _controller.animateTo(1,
          duration: Duration(seconds: inhaleDuration),
          curve: Curves.easeInOut);
      _canTapNow = false;

      if (!_sessionRunning || _isPaused) return;
      setState(() => _currentStep = 1);
      await Future.delayed(Duration(seconds: holdDuration));

      if (!_sessionRunning || _isPaused) return;
      setState(() {
        _currentStep = 2;
        _currentPhaseDuration = exhaleDuration;
      });
      _armRhythmWindow(exhaleDuration);
      await _controller.animateBack(0,
          duration: Duration(seconds: exhaleDuration),
          curve: Curves.easeInOut);
      _canTapNow = false;
    }
  }

  /// Opens the tappable window for the current phase. The "ideal" tap
  /// moment is the midpoint of the phase — tapping exactly there scores
  /// 100, tapering off toward the edges.
  void _armRhythmWindow(int durationSeconds) {
    _phaseStartTime = DateTime.now();
    setState(() => _canTapNow = true);
  }

  void _onRhythmTap() {
    if (!_canTapNow || _phaseStartTime == null) return;
    final elapsed = DateTime.now().difference(_phaseStartTime!).inMilliseconds;
    final phaseMs = _currentPhaseDuration * 1000;
    final midpoint = phaseMs / 2;
    final distance = (elapsed - midpoint).abs();
    // Score 100 at the midpoint, tapering to ~20 at the edges.
    final accuracy = (100 - (distance / midpoint) * 80).clamp(20, 100).round();

    setState(() {
      _rhythmAttempts++;
      _scoreTotal += accuracy;
      if (accuracy >= 70) _rhythmHits++;
      _canTapNow = false; // one scored tap per phase
    });

    _showTapFeedback(accuracy);
  }

  void _showTapFeedback(int accuracy) {
    final label = accuracy >= 90
        ? 'Perfect!'
        : accuracy >= 70
            ? 'Great'
            : accuracy >= 50
                ? 'Good'
                : 'Okay';
    final overlay = Overlay.of(context);
    final entry = OverlayEntry(
      builder: (context) => Positioned(
        top: 140,
        left: 0,
        right: 0,
        child: Center(
          child: AnimatedOpacity(
            opacity: 1,
            duration: const Duration(milliseconds: 200),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.deepPurple.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$label +$accuracy',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),
      ),
    );
    overlay.insert(entry);
    Future.delayed(const Duration(milliseconds: 700), () => entry.remove());
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0 && !_isPaused) {
        setState(() {
          _remainingSeconds--;
          _timerText = _formatTime(_remainingSeconds);
        });
      } else {
        timer.cancel();
        _stopSession(completed: true);
      }
    });
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final sec = seconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}";
  }

  Future<void> _toggleMusic() async {
    if (_musicPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(AssetSource('music/meditation.mp3'));
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    }
    setState(() => _musicPlaying = !_musicPlaying);
  }

  Widget _buildDropdownColumn(
      String label, int value, ValueChanged<int?> onChanged) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.deepPurple,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.deepPurple[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButton<int>(
            value: value,
            dropdownColor: Colors.deepPurple[50],
            underline: const SizedBox(),
            items: [2, 3, 4, 5, 6, 7, 8]
                .map((e) => DropdownMenuItem<int>(
                      value: e,
                      child: Text("$e s"),
                    ))
                .toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Breathing Journey'),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: Icon(
              _musicPlaying ? Icons.music_note : Icons.music_off,
              color: Colors.white,
            ),
            tooltip: _musicPlaying ? "Music Playing" : "Music Off",
            onPressed: _toggleMusic,
          ),
        ],
      ),
      backgroundColor: Colors.deepPurple[50],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 20),
          child: Column(
            children: [
              if (!_sessionRunning) ...[
                const Text(
                  '✨ Breathing Settings',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Tap "Follow" in rhythm with the circle for bonus points — or just breathe, no pressure 🌿',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.deepPurple.shade400),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildDropdownColumn('Inhale', inhaleDuration, (v) {
                      if (v == null) return;
                      setState(() => inhaleDuration = v);
                    }),
                    _buildDropdownColumn('Hold', holdDuration, (v) {
                      if (v == null) return;
                      setState(() => holdDuration = v);
                    }),
                    _buildDropdownColumn('Exhale', exhaleDuration, (v) {
                      if (v == null) return;
                      setState(() => exhaleDuration = v);
                    }),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  '🕒 Session length: ${totalSessionSeconds ~/ 60} minute',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.deepPurple[700],
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _startSession,
                      icon: const Icon(Icons.play_arrow, color: Colors.white),
                      label: const Text(
                        'Start',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 28),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    OutlinedButton.icon(
                      onPressed: () {
                        setState(() {
                          inhaleDuration = 4;
                          holdDuration = 4;
                          exhaleDuration = 6;
                        });
                      },
                      icon: Icon(Icons.refresh, color: Colors.deepPurple[600]),
                      label: const Text(
                        'Reset',
                        style: TextStyle(color: Colors.deepPurple),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.deepPurple.shade300),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 18),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 24),
                const Divider(),
              ],
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_sessionRunning)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.bolt_rounded, color: Colors.amber.shade700, size: 18),
                            const SizedBox(width: 4),
                            Text(
                              'Score: $_scoreTotal',
                              style: TextStyle(
                                  color: Colors.deepPurple.shade700,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    GestureDetector(
                      onTap: _canTapNow ? _onRhythmTap : null,
                      child: AnimatedBuilder(
                        animation: _sizeAnim,
                        builder: (context, child) {
                          double circleSize = _sizeAnim.value;
                          if (_currentStep == 1) circleSize = 240;

                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            height: circleSize,
                            width: circleSize,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: _canTapNow
                                    ? [Colors.amber.shade200, Colors.deepPurple.shade400]
                                    : [
                                        Colors.deepPurpleAccent.shade100,
                                        Colors.deepPurple.shade400
                                      ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.deepPurple.withOpacity(0.4),
                                  blurRadius: 25,
                                  spreadRadius: 6,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                _sessionRunning
                                    ? (_currentStep == 0
                                        ? (_canTapNow ? 'Follow 👆' : 'Inhale 🌬️')
                                        : (_currentStep == 1
                                            ? 'Hold ✨'
                                            : (_canTapNow ? 'Follow 👆' : 'Exhale 🌿')))
                                    : 'Ready 🧘‍♀️',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 35),
                    Text(
                      _timerText,
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple[900],
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 25),
                    if (_sessionRunning) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: _togglePauseResume,
                            icon: Icon(
                              _isPaused ? Icons.play_arrow : Icons.pause,
                              color: Colors.white,
                            ),
                            label: Text(
                              _isPaused ? 'Resume' : 'Pause',
                              style: const TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 22),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          OutlinedButton.icon(
                            onPressed: () => _stopSession(completed: true),
                            icon: const Icon(
                                Icons.stop, color: Colors.deepPurpleAccent),
                            label: const Text(
                              'Finish',
                              style: TextStyle(color: Colors.deepPurpleAccent),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                  color: Colors.deepPurpleAccent.shade100),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 22),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                          )
                        ],
                      )
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}