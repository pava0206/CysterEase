import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/period_service.dart';
import '../models/period_log_model.dart';
import '../widgets/mood_selector.dart';
import '../widgets/wellness_tip_card.dart';
import '../widgets/history_log_card.dart';

class PeriodTrackerPage extends StatefulWidget {
  const PeriodTrackerPage({super.key});

  @override
  State<PeriodTrackerPage> createState() => _PeriodTrackerPageState();
}

class _PeriodTrackerPageState extends State<PeriodTrackerPage>
    with TickerProviderStateMixin {
  final PeriodService service = PeriodService();

  int currentIndex = 0;

  DateTime? startDate;
  DateTime? endDate;

  int cycleLength = 28;
  int periodDuration = 5;

  double painLevel = 3;
  double energyLevel = 7;

  String selectedFlow = 'Medium';
  String selectedMood = 'Happy';

  final notesController = TextEditingController();

  bool isSaving = false;
  bool isLoading = true;

  final List<String> selectedSymptoms = [];
  List<Map<String, dynamic>> logs = [];

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  // ── Constants ────────────────────────────────────────────────

  static const Color kPrimary = Color(0xFF7C3AED);
  static const Color kPrimaryLight = Color(0xFF8B5CF6);
  static const Color kPrimaryPale = Color(0xFFF5F0FF);
  static const Color kAccent = Color(0xFFEC4899);
  static const Color kBg = Color(0xFFF8F5FF);
  static const Color kCard = Colors.white;
  static const Color kTextDark = Color(0xFF1E1B2E);
  static const Color kTextMid = Color(0xFF6B7280);

  final List<String> symptoms = [
    '🩸 Cramps',
    '🤕 Headache',
    '😴 Fatigue',
    '😢 Mood Swings',
    '💨 Bloating',
    '😣 Acne',
    '🔙 Back Pain',
    '🍫 Cravings',
    '🥵 Hot Flashes',
    '😰 Night Sweats',
    '💧 Discharge',
    '🤢 Nausea',
  ];

  final List<String> flowOptions = ['Spotting', 'Light', 'Medium', 'Heavy'];

  final List<Map<String, String>> wellnessTips = [
    {'tip': 'Stay hydrated — aim for 8 glasses today 💧', 'category': 'Hydration'},
    {'tip': 'Light yoga or walking can ease cramps 🧘‍♀️', 'category': 'Movement'},
    {'tip': 'Prioritise 7–9 hrs of sleep for hormonal balance 😴', 'category': 'Rest'},
    {'tip': 'Iron-rich foods like spinach & lentils help 🥗', 'category': 'Nutrition'},
    {'tip': 'Track symptoms to spot patterns over time 💜', 'category': 'Tracking'},
    {'tip': 'Magnesium may help reduce PMS symptoms ✨', 'category': 'Supplements'},
    {'tip': 'Avoid caffeine — it can worsen cramps ☕', 'category': 'Diet'},
  ];

  // ── Lifecycle ───────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    fetchLogs();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    notesController.dispose();
    super.dispose();
  }

  // ── Data ────────────────────────────────────────────────────

  Future<void> fetchLogs() async {
    try {
      final snapshot = await service.fetchLogs();
      logs = snapshot.docs
          .map((e) => {'id': e.id, ...e.data() as Map<String, dynamic>})
          .toList();
    } catch (e) {
      debugPrint(e.toString());
    }
    if (mounted) setState(() => isLoading = false);
  }

  Future<void> saveLog() async {
    if (startDate == null) {
      _showSnack('Please select your period start date', isError: true);
      return;
    }
    setState(() => isSaving = true);
    try {
      await service.savePeriodLog(
        startDate: startDate!,
        endDate: endDate,
        cycleLength: cycleLength,
        periodDuration: periodDuration,
        painLevel: painLevel.round(),
        energyLevel: energyLevel.round(),
        flowIntensity: selectedFlow,
        mood: selectedMood,
        notes: notesController.text.trim(),
        symptoms: selectedSymptoms,
      );
      _showSnack('Period log saved 🌸');
      setState(() {
        selectedSymptoms.clear();
        notesController.clear();
        startDate = null;
        endDate = null;
        painLevel = 3;
        energyLevel = 7;
        selectedFlow = 'Medium';
        selectedMood = 'Happy';
      });
      fetchLogs();
    } catch (e) {
      _showSnack('Failed to save log. Try again.', isError: true);
    }
    if (mounted) setState(() => isSaving = false);
  }

  Future<void> deleteLog(String id) async {
    try {
      await service.deleteLog(id);
      _showSnack('Log deleted');
      fetchLogs();
    } catch (_) {
      _showSnack('Failed to delete', isError: true);
    }
  }

  // ── Helpers ─────────────────────────────────────────────────

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Colors.red.shade600 : kPrimary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // ── Computed properties ──────────────────────────────────────

  int? get daysUntilNextPeriod {
    if (startDate == null) return null;
    final nextPeriod = startDate!.add(Duration(days: cycleLength));
    final diff = nextPeriod.difference(DateTime.now()).inDays;
    return diff < 0 ? null : diff;
  }

  int get currentCycleDay {
    if (startDate == null) return 0;
    return DateTime.now().difference(startDate!).inDays % cycleLength + 1;
  }

  Map<String, dynamic> get phaseInfo {
    // Only called when startDate != null
    final day = DateTime.now().difference(startDate!).inDays % cycleLength;
    if (day < periodDuration) {
      return {
        'name': 'Menstrual',
        'emoji': '🩸',
        'desc': 'Your period is active. Rest & stay warm.',
        'color': const Color(0xFFEF4444),
        'gradient': [const Color(0xFFEF4444), const Color(0xFFF97316)],
        'day': day + 1,
      };
    } else if (day < 13) {
      return {
        'name': 'Follicular',
        'emoji': '🌱',
        'desc': 'Energy rising. Great time to start new things!',
        'color': const Color(0xFF10B981),
        'gradient': [const Color(0xFF10B981), const Color(0xFF34D399)],
        'day': day + 1,
      };
    } else if (day < 16) {
      return {
        'name': 'Ovulation',
        'emoji': '🌸',
        'desc': 'Peak fertility window. You may feel your best!',
        'color': kAccent,
        'gradient': [kAccent, const Color(0xFFF472B6)],
        'day': day + 1,
      };
    }
    return {
      'name': 'Luteal',
      'emoji': '🌙',
      'desc': 'Wind down & practise self-care.',
      'color': kPrimary,
      'gradient': [kPrimary, kPrimaryLight],
      'day': day + 1,
    };
  }

  Map<String, dynamic> get cycleStats {
    if (logs.isEmpty) return {};
    int totalPain = 0, totalEnergy = 0;
    for (final log in logs) {
      totalPain += (log['pain_level'] as int? ?? 0);
      totalEnergy += (log['energy_level'] as int? ?? 0);
    }
    return {
      'avgPain': (totalPain / logs.length).toStringAsFixed(1),
      'avgEnergy': (totalEnergy / logs.length).toStringAsFixed(1),
      'totalLogs': logs.length,
    };
  }

  // ── Root Build ───────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: kBg,
      appBar: _buildAppBar(),
      body: IndexedStack(
        index: currentIndex,
        children: [
          _buildHomePage(),
          _buildLogPage(),
          _buildInsightsPage(),
          _buildHistoryPage(),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ── App Bar ──────────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar() {
    final titles = ['Home', 'Log Period', 'Insights', 'History'];
    return AppBar(
      backgroundColor: kPrimary,
      elevation: 0,
      centerTitle: false,
      title: Text(
        titles[currentIndex],
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
      ),
      actions: [
        if (currentIndex == 0 && startDate != null)
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Day $currentCycleDay',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
      ],
    );
  }

  // ── Bottom Nav ───────────────────────────────────────────────

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: kPrimary.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(0, Icons.home_rounded, 'Home'),
              _navItem(1, Icons.add_circle_outline_rounded, 'Log'),
              _navItem(2, Icons.insights_rounded, 'Insights'),
              _navItem(3, Icons.history_rounded, 'History'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(int index, IconData icon, String label) {
    final selected = currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => currentIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? kPrimary.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: selected ? kPrimary : kTextMid, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: selected ? kPrimary : kTextMid,
                fontSize: 11,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── HOME PAGE ────────────────────────────────────────────────

  Widget _buildHomePage() {
    final stats = cycleStats;
    final tip = wellnessTips[DateTime.now().day % wellnessTips.length];
    final daysLeft = daysUntilNextPeriod;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
      children: [
        // ── Phase card OR onboarding card ──────────────────────
        startDate == null
            ? _buildOnboardingCard()
            : ScaleTransition(
                scale: _pulseAnimation,
                child: _buildActivePhaseCard(daysLeft),
              ),

        const SizedBox(height: 20),

        // Cycle progress (only when a period is logged)
        if (startDate != null) ...[
          _buildCycleProgress(),
          const SizedBox(height: 20),
        ],

        // Wellness tip
        _buildWellnessTipCard(tip),

        const SizedBox(height: 20),

        // Quick stats
        const Text(
          'Quick Stats',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: kTextDark,
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(child: _statCard('Cycle', '$cycleLength days', Icons.loop_rounded, kPrimary)),
            const SizedBox(width: 12),
            Expanded(child: _statCard('Period', '$periodDuration days', Icons.water_drop_rounded, kAccent)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _statCard(
                'Avg Pain',
                stats['avgPain'] != null ? '${stats['avgPain']}/10' : '--',
                Icons.favorite_rounded,
                const Color(0xFFEF4444),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _statCard(
                'Total Logs',
                stats['totalLogs']?.toString() ?? '0',
                Icons.history_rounded,
                const Color(0xFF10B981),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Quick log CTA
        GestureDetector(
          onTap: () => setState(() => currentIndex = 1),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: kAccent.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: kAccent.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: kAccent.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.add_rounded, color: kAccent, size: 22),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Log today\'s symptoms',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: kTextDark,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Track your flow, mood & how you feel',
                        style: TextStyle(color: kTextMid, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: kAccent),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Onboarding card (replaces Unknown phase card) ────────────

  Widget _buildOnboardingCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7C3AED), Color(0xFFEC4899)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: kPrimary.withOpacity(0.35),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.22),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Welcome to CysterEase 💜',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.95),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Start tracking\nyour cycle',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),
              const Text('🌸', style: TextStyle(fontSize: 42)),
            ],
          ),

          const SizedBox(height: 14),

          Text(
            'Log your first period to unlock your phase insights, cycle predictions, and personalised wellness tips.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.85),
              fontSize: 13.5,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 20),

          // Feature pills
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _featurePill('📅 Cycle prediction'),
              _featurePill('🌙 Phase insights'),
              _featurePill('📊 Symptom trends'),
            ],
          ),

          const SizedBox(height: 22),

          // CTA button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => setState(() => currentIndex = 1),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: kPrimary,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_circle_outline_rounded, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'Log my first period',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _featurePill(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.25)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // ── Active phase card (shown when startDate != null) ─────────

  Widget _buildActivePhaseCard(int? daysLeft) {
    final phase = phaseInfo;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: (phase['gradient'] as List).cast<Color>(),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: (phase['gradient'] as List<Color>).first.withOpacity(0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Current Phase',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                phase['emoji'] as String,
                style: const TextStyle(fontSize: 28),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            phase['name'] as String,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            phase['desc'] as String,
            style: TextStyle(
              color: Colors.white.withOpacity(0.85),
              fontSize: 14,
              height: 1.4,
            ),
          ),
          if (daysLeft != null) ...[
            const SizedBox(height: 20),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.calendar_today_rounded,
                      color: Colors.white, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    daysLeft == 0
                        ? 'Period due today'
                        : 'Next period in $daysLeft day${daysLeft == 1 ? '' : 's'}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ── Cycle progress ───────────────────────────────────────────

  Widget _buildCycleProgress() {
    final day = currentCycleDay;
    final progress = day / cycleLength;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
              color: kPrimary.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Cycle Progress',
            style: TextStyle(
                fontWeight: FontWeight.w700, fontSize: 15, color: kTextDark),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: kPrimary.withOpacity(0.1),
              valueColor: const AlwaysStoppedAnimation(kPrimary),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Day $day',
                  style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: kPrimary,
                      fontSize: 13)),
              Text('of $cycleLength days',
                  style: const TextStyle(color: kTextMid, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _phaseIndicator('🩸', 'Period', day <= periodDuration),
              _phaseIndicator(
                  '🌱', 'Follicular', day > periodDuration && day <= 13),
              _phaseIndicator('🌸', 'Ovulation', day > 13 && day <= 16),
              _phaseIndicator('🌙', 'Luteal', day > 16),
            ],
          ),
        ],
      ),
    );
  }

  Widget _phaseIndicator(String emoji, String label, bool active) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: active ? kPrimary.withOpacity(0.12) : Colors.transparent,
            shape: BoxShape.circle,
            border: active ? Border.all(color: kPrimary, width: 2) : null,
          ),
          child: Text(emoji, style: const TextStyle(fontSize: 18)),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: active ? kPrimary : kTextMid,
            fontWeight: active ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildWellnessTipCard(Map<String, String> tip) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [kAccent.withOpacity(0.08), kPrimary.withOpacity(0.06)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kAccent.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: kAccent.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.lightbulb_outline_rounded,
                color: kAccent, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tip['category']!,
                  style: const TextStyle(
                    color: kAccent,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  tip['tip']!,
                  style: const TextStyle(
                    color: kTextDark,
                    fontSize: 14,
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: color.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: kTextDark,
                ),
              ),
              Text(
                title,
                style: const TextStyle(color: kTextMid, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── LOG PAGE ─────────────────────────────────────────────────

  Widget _buildLogPage() {
    return SafeArea(
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionHeader('Cycle Settings', Icons.settings_rounded),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: _cardDecoration(),
              child: Column(
                children: [
                  _cycleLengthStepper(
                    'Cycle Length',
                    cycleLength,
                    (v) => setState(() => cycleLength = v),
                    min: 20,
                    max: 45,
                  ),
                  const Divider(height: 24),
                  _cycleLengthStepper(
                    'Period Duration',
                    periodDuration,
                    (v) => setState(() => periodDuration = v),
                    min: 2,
                    max: 10,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 26),

            _sectionHeader('Period Dates', Icons.calendar_month_rounded),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                    child: _dateCard('Start Date', startDate,
                        (d) => setState(() => startDate = d),
                        isRequired: true)),
                const SizedBox(width: 12),
                Expanded(
                    child: _dateCard(
                        'End Date', endDate, (d) => setState(() => endDate = d))),
              ],
            ),

            const SizedBox(height: 26),

            _sectionHeader('Flow Intensity', Icons.water_drop_rounded),
            const SizedBox(height: 12),
            Row(
              children: flowOptions.map((flow) {
                final selected = selectedFlow == flow;
                final colors = {
                  'Spotting': const Color(0xFFFCA5A5),
                  'Light': kAccent,
                  'Medium': const Color(0xFFEF4444),
                  'Heavy': const Color(0xFF991B1B),
                };
                final color = colors[flow] ?? kPrimary;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => selectedFlow = flow),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: selected ? color : color.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: selected ? color : Colors.transparent),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.water_drop_rounded,
                              color: selected ? Colors.white : color,
                              size: 20),
                          const SizedBox(height: 6),
                          Text(
                            flow,
                            style: TextStyle(
                              color: selected ? Colors.white : color,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 26),

            _sectionHeader(
                'How do you feel?', Icons.sentiment_satisfied_alt_rounded),
            const SizedBox(height: 14),
            _buildEnhancedSlider(
              'Pain Level',
              painLevel,
              (v) => setState(() => painLevel = v),
              lowLabel: 'No pain',
              highLabel: 'Severe',
              activeColor: const Color(0xFFEF4444),
              icon: Icons.favorite_rounded,
            ),
            const SizedBox(height: 14),
            _buildEnhancedSlider(
              'Energy Level',
              energyLevel,
              (v) => setState(() => energyLevel = v),
              lowLabel: 'Exhausted',
              highLabel: 'Energised',
              activeColor: const Color(0xFF10B981),
              icon: Icons.bolt_rounded,
            ),

            const SizedBox(height: 26),

            _sectionHeader('Mood', Icons.emoji_emotions_rounded),
            const SizedBox(height: 14),
            MoodSelector(
              selectedMood: selectedMood,
              onMoodSelected: (mood) => setState(() => selectedMood = mood),
            ),

            const SizedBox(height: 26),

            _sectionHeader('Symptoms', Icons.medical_information_rounded),
            const SizedBox(height: 6),
            Text(
              'Select all that apply',
              style: TextStyle(color: kTextMid, fontSize: 13),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: symptoms.map((symptom) {
                final selected = selectedSymptoms.contains(symptom);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (selected) {
                        selectedSymptoms.remove(symptom);
                      } else {
                        selectedSymptoms.add(symptom);
                      }
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: selected ? kPrimary : kCard,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color:
                            selected ? kPrimary : Colors.grey.shade200,
                      ),
                      boxShadow: selected
                          ? [
                              BoxShadow(
                                  color: kPrimary.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3))
                            ]
                          : null,
                    ),
                    child: Text(
                      symptom,
                      style: TextStyle(
                        color: selected ? Colors.white : kTextDark,
                        fontSize: 13,
                        fontWeight: selected
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 26),

            _sectionHeader('Notes', Icons.notes_rounded),
            const SizedBox(height: 14),
            Container(
              decoration: BoxDecoration(
                color: kCard,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade100),
                boxShadow: [
                  BoxShadow(
                      color: kPrimary.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 3)),
                ],
              ),
              child: TextField(
                controller: notesController,
                maxLines: 5,
                cursorColor: kPrimary,
                style: const TextStyle(
                    fontSize: 15, color: kTextDark, height: 1.5),
                decoration: InputDecoration(
                  hintText:
                      'How are you feeling today? Any observations...',
                  hintStyle: TextStyle(
                      color: Colors.grey.shade400, fontSize: 14),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(18),
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 58,
              child: ElevatedButton(
                onPressed: isSaving ? null : saveLog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimary,
                  disabledBackgroundColor: kPrimary.withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 4,
                  shadowColor: kPrimary.withOpacity(0.4),
                ),
                child: isSaving
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2.5),
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.save_rounded,
                              color: Colors.white, size: 20),
                          SizedBox(width: 10),
                          Text(
                            'Save Log',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cycleLengthStepper(
    String label,
    int value,
    Function(int) onChanged, {
    required int min,
    required int max,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: kTextDark)),
        Row(
          children: [
            _stepperBtn(Icons.remove_rounded, () {
              if (value > min) onChanged(value - 1);
            }),
            SizedBox(
              width: 50,
              child: Text(
                '$value days',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: kPrimary,
                    fontSize: 14),
              ),
            ),
            _stepperBtn(Icons.add_rounded, () {
              if (value < max) onChanged(value + 1);
            }),
          ],
        ),
      ],
    );
  }

  Widget _stepperBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: kPrimary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: kPrimary, size: 18),
      ),
    );
  }

  Widget _buildEnhancedSlider(
    String title,
    double value,
    Function(double) onChanged, {
    required String lowLabel,
    required String highLabel,
    required Color activeColor,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: activeColor, size: 18),
              const SizedBox(width: 8),
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: kTextDark)),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: activeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${value.round()}/10',
                  style: TextStyle(
                    color: activeColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: activeColor,
              inactiveTrackColor: activeColor.withOpacity(0.15),
              thumbColor: activeColor,
              overlayColor: activeColor.withOpacity(0.15),
              trackHeight: 6,
              thumbShape:
                  const RoundSliderThumbShape(enabledThumbRadius: 10),
            ),
            child: Slider(
              value: value,
              min: 0,
              max: 10,
              onChanged: onChanged,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(lowLabel,
                  style:
                      const TextStyle(color: kTextMid, fontSize: 12)),
              Text(highLabel,
                  style:
                      const TextStyle(color: kTextMid, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _dateCard(
    String label,
    DateTime? date,
    Function(DateTime) onSelected, {
    bool isRequired = false,
  }) {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: kPrimary,
                  onPrimary: Colors.white,
                  surface: Colors.white,
                ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null) onSelected(picked);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: date != null ? kPrimary.withOpacity(0.07) : kCard,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: date != null
                ? kPrimary.withOpacity(0.3)
                : (isRequired
                    ? kAccent.withOpacity(0.4)
                    : Colors.grey.shade200),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  size: 14,
                  color: date != null ? kPrimary : kTextMid,
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    color: date != null ? kPrimary : kTextMid,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (isRequired) ...[
                  const SizedBox(width: 2),
                  Text('*', style: TextStyle(color: kAccent, fontSize: 12)),
                ],
              ],
            ),
            const SizedBox(height: 10),
            Text(
              date == null
                  ? 'Tap to select'
                  : '${date.day}/${date.month}/${date.year}',
              style: TextStyle(
                fontWeight:
                    date != null ? FontWeight.w700 : FontWeight.w400,
                color: date != null ? kTextDark : Colors.grey.shade400,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── INSIGHTS PAGE ────────────────────────────────────────────

  Widget _buildInsightsPage() {
    if (isLoading) {
      return const Center(
          child: CircularProgressIndicator(color: kPrimary));
    }
    if (logs.isEmpty) {
      return _emptyState(
          'No insights yet',
          'Start logging your period to see patterns and insights.',
          Icons.insights_rounded);
    }

    final Map<String, int> symptomCount = {};
    int totalPain = 0;
    int totalEnergy = 0;
    final Map<String, int> moodCount = {};
    final Map<String, int> flowCount = {};

    for (final log in logs) {
      totalPain += (log['pain_level'] as int? ?? 0);
      totalEnergy += (log['energy_level'] as int? ?? 0);
      final mood = log['mood'] as String? ?? '';
      moodCount[mood] = (moodCount[mood] ?? 0) + 1;
      final flow = log['flow_intensity'] as String? ?? '';
      flowCount[flow] = (flowCount[flow] ?? 0) + 1;
      final symps = (log['symptoms'] as List?) ?? [];
      for (final s in symps) {
        symptomCount[s.toString()] =
            (symptomCount[s.toString()] ?? 0) + 1;
      }
    }

    final avgPain =
        logs.isNotEmpty ? totalPain / logs.length : 0.0;
    final avgEnergy =
        logs.isNotEmpty ? totalEnergy / logs.length : 0.0;
    final topMood = moodCount.isNotEmpty
        ? moodCount.entries
            .reduce((a, b) => a.value > b.value ? a : b)
            .key
        : '—';
    final topFlow = flowCount.isNotEmpty
        ? flowCount.entries
            .reduce((a, b) => a.value > b.value ? a : b)
            .key
        : '—';

    final sortedSymptoms = symptomCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      children: [
        Row(
          children: [
            Expanded(
              child: _insightCard(
                'Avg Pain',
                '${avgPain.toStringAsFixed(1)}/10',
                Icons.favorite_rounded,
                const Color(0xFFEF4444),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _insightCard(
                'Avg Energy',
                '${avgEnergy.toStringAsFixed(1)}/10',
                Icons.bolt_rounded,
                const Color(0xFF10B981),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
                child: _insightCard('Top Mood', topMood,
                    Icons.emoji_emotions_rounded, kAccent)),
            const SizedBox(width: 12),
            Expanded(
                child: _insightCard('Usual Flow', topFlow,
                    Icons.water_drop_rounded, kPrimary)),
          ],
        ),

        const SizedBox(height: 24),

        _sectionHeader('Common Symptoms', Icons.medical_information_rounded),
        const SizedBox(height: 14),

        if (sortedSymptoms.isEmpty)
          _emptyCard('No symptoms logged yet')
        else
          Container(
            padding: const EdgeInsets.all(18),
            decoration: _cardDecoration(),
            child: Column(
              children: sortedSymptoms.take(6).map((entry) {
                final pct = entry.value / logs.length;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Text(entry.key,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  color: kTextDark)),
                          Text(
                            '${entry.value} time${entry.value > 1 ? 's' : ''}',
                            style: const TextStyle(
                                color: kTextMid, fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: pct.clamp(0.0, 1.0),
                          minHeight: 8,
                          backgroundColor: kPrimary.withOpacity(0.1),
                          valueColor:
                              const AlwaysStoppedAnimation(kPrimary),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

        const SizedBox(height: 24),

        _sectionHeader('Mood Distribution', Icons.pie_chart_rounded),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: _cardDecoration(),
          child: Column(
            children: moodCount.entries.map((entry) {
              final pct =
                  (entry.value / logs.length * 100).round();
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Text(entry.key,
                        style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: entry.value / logs.length,
                          minHeight: 8,
                          backgroundColor: kAccent.withOpacity(0.1),
                          valueColor:
                              const AlwaysStoppedAnimation(kAccent),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text('$pct%',
                        style: const TextStyle(
                            color: kTextMid,
                            fontSize: 12,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _insightCard(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: color.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 10),
          Text(value,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: kTextDark)),
          Text(label,
              style: const TextStyle(color: kTextMid, fontSize: 12)),
        ],
      ),
    );
  }

  // ── HISTORY PAGE ─────────────────────────────────────────────

  Widget _buildHistoryPage() {
    if (isLoading) {
      return const Center(
          child: CircularProgressIndicator(color: kPrimary));
    }
    if (logs.isEmpty) {
      return _emptyState(
          'No logs yet',
          'Your period logs will appear here once you start tracking.',
          Icons.history_rounded);
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      itemCount: logs.length,
      itemBuilder: (context, index) {
        final log = logs[index];
        final date = (log['start_date'] as Timestamp).toDate();

        return Dismissible(
          key: Key(log['id'] as String),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.delete_outline_rounded,
                color: Colors.red, size: 26),
          ),
          confirmDismiss: (_) async {
            return await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                title: const Text('Delete Log'),
                content: const Text(
                    'Are you sure you want to delete this period log?'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('Cancel')),
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: const Text('Delete',
                        style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            );
          },
          onDismissed: (_) => deleteLog(log['id'] as String),
          child: GestureDetector(
            onTap: () => _showLogDetail(log),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: kCard,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: kPrimary.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 3)),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [kPrimary, kPrimaryLight],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${date.day}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          _monthAbbr(date.month),
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              log['flow_intensity'] ?? '',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                  color: kTextDark),
                            ),
                            const SizedBox(width: 8),
                            const Text('flow',
                                style: TextStyle(
                                    color: kTextMid, fontSize: 13)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(log['mood'] ?? '',
                                style: const TextStyle(fontSize: 16)),
                            const SizedBox(width: 6),
                            Text(
                              'Pain: ${log['pain_level'] ?? 0}/10',
                              style: const TextStyle(
                                  color: kTextMid, fontSize: 12),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Energy: ${log['energy_level'] ?? 0}/10',
                              style: const TextStyle(
                                  color: kTextMid, fontSize: 12),
                            ),
                          ],
                        ),
                        if ((log['symptoms'] as List?)?.isNotEmpty ==
                            true) ...[
                          const SizedBox(height: 6),
                          Text(
                            (log['symptoms'] as List).take(3).join(', ') +
                                ((log['symptoms'] as List).length > 3
                                    ? '...'
                                    : ''),
                            style: const TextStyle(
                                color: kTextMid, fontSize: 12),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded,
                      color: kTextMid, size: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showLogDetail(Map<String, dynamic> log) {
    final date = (log['start_date'] as Timestamp).toDate();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.75,
          maxChildSize: 0.95,
          builder: (_, controller) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: ListView(
                controller: controller,
                children: [
                  const SizedBox(height: 12),
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              colors: [kPrimary, kPrimaryLight]),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          '${date.day} ${_monthAbbr(date.month)}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 16),
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Text(
                        'Period Log',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: kTextDark),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _detailRow('Flow', log['flow_intensity'] ?? '—',
                      Icons.water_drop_rounded, kAccent),
                  _detailRow('Mood', log['mood'] ?? '—',
                      Icons.emoji_emotions_rounded, kPrimary),
                  _detailRow('Pain Level', '${log['pain_level'] ?? 0}/10',
                      Icons.favorite_rounded, const Color(0xFFEF4444)),
                  _detailRow(
                      'Energy Level',
                      '${log['energy_level'] ?? 0}/10',
                      Icons.bolt_rounded,
                      const Color(0xFF10B981)),
                  const SizedBox(height: 20),
                  const Text('Symptoms',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
                          color: kTextDark)),
                  const SizedBox(height: 10),
                  if ((log['symptoms'] as List?)?.isEmpty ?? true)
                    Text('None logged',
                        style: TextStyle(color: kTextMid))
                  else
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          ((log['symptoms'] ?? []) as List).map((s) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: kPrimary.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: kPrimary.withOpacity(0.2)),
                          ),
                          child: Text(s.toString(),
                              style: const TextStyle(
                                  fontSize: 13,
                                  color: kPrimary,
                                  fontWeight: FontWeight.w500)),
                        );
                      }).toList(),
                    ),
                  const SizedBox(height: 20),
                  const Text('Notes',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
                          color: kTextDark)),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: kPrimaryPale,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      (log['notes']?.toString().isEmpty ?? true)
                          ? 'No notes added'
                          : log['notes'],
                      style: const TextStyle(
                          fontSize: 14,
                          color: kTextDark,
                          height: 1.5),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _detailRow(
      String title, String value, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 10),
          Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: kTextDark)),
          const Spacer(),
          Text(value,
              style: TextStyle(
                  fontSize: 14,
                  color: color,
                  fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  // ── Shared helpers ───────────────────────────────────────────

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: kCard,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
            color: kPrimary.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4)),
      ],
    );
  }

  Widget _sectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: kPrimary, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: kTextDark),
        ),
      ],
    );
  }

  Widget _emptyState(
      String title, String subtitle, IconData icon) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: kPrimary.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: kPrimary, size: 44),
            ),
            const SizedBox(height: 20),
            Text(title,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: kTextDark)),
            const SizedBox(height: 8),
            Text(subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: kTextMid, fontSize: 14, height: 1.5)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => setState(() => currentIndex = 1),
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 14),
              ),
              child: const Text('Log your first period',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyCard(String text) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Center(
        child: Text(text,
            style: const TextStyle(color: kTextMid, fontSize: 14)),
      ),
    );
  }

  String _monthAbbr(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}