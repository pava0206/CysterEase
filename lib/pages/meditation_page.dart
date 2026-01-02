import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';
import 'dart:math';

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
    });
    _runBreathingCycle();
    _startTimer();
  }

  void _stopSession() {
    _controller.reset();
    _timer?.cancel();
    setState(() {
      _sessionRunning = false;
      _isPaused = false;
      _currentStep = 0;
      _timerText = _formatTime(totalSessionSeconds);
    });
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
      setState(() => _currentStep = 0);
      await _controller.animateTo(1,
          duration: Duration(seconds: inhaleDuration),
          curve: Curves.easeInOut);

      if (!_sessionRunning || _isPaused) return;
      setState(() => _currentStep = 1);
      await Future.delayed(Duration(seconds: holdDuration));

      if (!_sessionRunning || _isPaused) return;
      setState(() => _currentStep = 2);
      await _controller.animateBack(0,
          duration: Duration(seconds: exhaleDuration),
          curve: Curves.easeInOut);
    }
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
        _stopSession();
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
        title: const Text('2-Min Meditation'),
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
                    AnimatedBuilder(
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
                              colors: [
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
                                      ? 'Inhale 🌬️'
                                      : (_currentStep == 1
                                          ? 'Hold ✨'
                                          : 'Exhale 🌿'))
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
                            onPressed: _stopSession,
                            icon: const Icon(
                                Icons.stop, color: Colors.deepPurpleAccent),
                            label: const Text(
                              'Stop',
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
