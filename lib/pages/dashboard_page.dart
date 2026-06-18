import 'package:flutter/material.dart';
import 'package:cysterease/pages/welcome_page.dart';
import 'package:cysterease/pages/sleep_tracker.dart';
import 'package:cysterease/pages/stress_management.dart';
import 'package:cysterease/pages/diet_rules.dart';
import 'package:cysterease/pages/workout_detail.dart';
import 'package:cysterease/pages/periods_tracker.dart';
import 'package:cysterease/pages/chatbot_page.dart';
import 'package:url_launcher/url_launcher.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  bool _showMoveButton = true;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

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

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 50) {
        setState(() => _showMoveButton = false);
      } else {
        setState(() => _showMoveButton = true);
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollNext() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.offset + 200,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3EEF8),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.favorite_rounded,
                  color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            const Text(
              'CysterEase',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 20,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const WelcomePage()),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.4)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.logout_rounded, color: Colors.white, size: 16),
                  SizedBox(width: 5),
                  Text('Logout',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: ScaleTransition(
        scale: _pulseAnimation,
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChatbotPage()),
            );
          },
          backgroundColor: const Color(0xFF6A1B9A),
          elevation: 6,
          icon: const Icon(Icons.auto_awesome_rounded,
              color: Colors.white, size: 22),
          label: const Text(
            'AI Assistant',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Hero Banner ──────────────────────────────
            _HeroBanner(),

            const SizedBox(height: 24),

            // ── Daily Tools ──────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _SectionHeader(
                label: 'YOUR DAILY TOOLS',
                icon: Icons.grid_view_rounded,
              ),
            ),
            const SizedBox(height: 14),

            SizedBox(
              height: 230,
              child: ListView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 20, right: 8),
                children: [
                  _DashboardCard(
                    imageAsset: 'assets/images/diet.png',
                    title: 'Diet\nPlanner',
                    subtitle: 'Personalized PCOD meals',
                    gradientColors: [Color(0xFF9C27B0), Color(0xFF6A1B9A)],
                    pill: 'Nutrition',
                    pillIcon: Icons.restaurant_rounded,
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const DietRulesPage())),
                  ),
                  _DashboardCard(
                    imageAsset: 'assets/images/stress.png',
                    title: 'Stress\nRelief',
                    subtitle: 'Calm your mind & body',
                    gradientColors: [Color(0xFF7B1FA2), Color(0xFF4A148C)],
                    pill: 'Wellness',
                    pillIcon: Icons.spa_rounded,
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const StressManagementPage())),
                  ),
                  _DashboardCard(
                    imageAsset: 'assets/images/workout.png',
                    title: 'Workout\nPlanner',
                    subtitle: 'PCOD-safe moves',
                    gradientColors: [Color(0xFF8E24AA), Color(0xFF5E1688)],
                    pill: 'Fitness',
                    pillIcon: Icons.fitness_center_rounded,
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const WorkoutDetailPage())),
                  ),
                  _DashboardCard(
                    imageAsset: 'assets/images/sleep.png',
                    title: 'Sleep\nTracker',
                    subtitle: 'Build better habits',
                    gradientColors: [Color(0xFF6A1B9A), Color(0xFF38006B)],
                    pill: 'Sleep',
                    pillIcon: Icons.bedtime_rounded,
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const SleepTrackerPage())),
                  ),
                  _DashboardCard(
                    imageAsset: 'assets/images/periods.png',
                    title: 'Period\nTracker',
                    subtitle: 'Track cycle & symptoms',
                    gradientColors: [Color(0xFFAD1457), Color(0xFF880E4F)],
                    pill: 'Cycle',
                    pillIcon: Icons.water_drop_rounded,
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const PeriodTrackerPage())),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Scroll forward button
            if (_showMoveButton)
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: _scrollNext,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF9C27B0), Color(0xFF6A1B9A)],
                        ),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.deepPurple.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Scroll',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13)),
                          SizedBox(width: 5),
                          Icon(Icons.arrow_forward_ios_rounded,
                              color: Colors.white, size: 14),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 28),

            // ── Daily Tip ────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _DailyTipCard(),
            ),

            const SizedBox(height: 28),

            // ── Articles ─────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _SectionHeader(
                label: 'FEATURED READS',
                icon: Icons.auto_stories_rounded,
              ),
            ),
            const SizedBox(height: 14),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _ArticleCard(
                    title: 'PCOS & Sleep',
                    description:
                        'Understand the link between sleep quality and PCOS management.',
                    url: 'https://www.askpcos.org/articles/pcos-and-sleep/',
                    tag: 'Sleep',
                    tagColor: Color(0xFF6A1B9A),
                    icon: Icons.bedtime_outlined,
                  ),
                  _ArticleCard(
                    title: 'Best PCOS Diet Tips',
                    description:
                        'Explore healthy eating strategies for better PCOS outcomes.',
                    url:
                        'https://www.hopkinsmedicine.org/health/wellness-and-prevention/pcos-diet',
                    tag: 'Diet',
                    tagColor: Color(0xFF2E7D32),
                    icon: Icons.restaurant_outlined,
                  ),
                  _ArticleCard(
                    title: 'PCOS & Insomnia Research',
                    description:
                        'A scientific review on sleep disorders in PCOS patients.',
                    url: 'https://pmc.ncbi.nlm.nih.gov/articles/PMC10032018/',
                    tag: 'Research',
                    tagColor: Color(0xFF1565C0),
                    icon: Icons.science_outlined,
                  ),
                  _ArticleCard(
                    title: 'Exercise for PCOS',
                    description:
                        'Workouts proven to help with PCOS symptoms and fertility.',
                    url:
                        'https://www.healthline.com/health/womens-health/exercise-for-pcos#fertility',
                    tag: 'Fitness',
                    tagColor: Color(0xFFC62828),
                    icon: Icons.directions_run_outlined,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}

// ── Hero Banner ──────────────────────────────────────────────────────────────

class _HeroBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6A1B9A), Color(0xFF9C27B0), Color(0xFFCE93D8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(36),
          bottomRight: Radius.circular(36),
        ),
      ),
      child: Stack(
        children: [
          // Decorative blobs
          Positioned(
            top: -30,
            right: -20,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.07),
              ),
            ),
          ),
          Positioned(
            bottom: -10,
            left: 30,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 100, 24, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.wb_sunny_rounded,
                          color: Colors.amber, size: 14),
                      SizedBox(width: 5),
                      Text('Good morning!',
                          style:
                              TextStyle(color: Colors.white, fontSize: 12.5)),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'How are you\nfeeling today?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Your wellness journey, one day at a time 💜',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 20),
                // Quick stats row
                Row(
                  children: [
                    _StatChip(icon: Icons.local_fire_department_rounded,
                        label: '5-day streak'),
                    const SizedBox(width: 10),
                    _StatChip(icon: Icons.check_circle_rounded,
                        label: '3 tasks done'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _StatChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 15),
          const SizedBox(width: 6),
          Text(label,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// ── Section Header ───────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String label;
  final IconData icon;
  const _SectionHeader({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF9C27B0), Color(0xFF6A1B9A)],
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.white, size: 17),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w800,
            color: Color(0xFF6A1B9A),
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}

// ── Daily Tip Card ───────────────────────────────────────────────────────────

class _DailyTipCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4A148C), Color(0xFF7B1FA2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.25),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.lightbulb_rounded,
                color: Colors.amber, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'DAILY TIP',
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Eating low-glycemic foods can reduce insulin spikes and ease PCOS symptoms.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.92),
                    fontSize: 13.5,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Dashboard Card ───────────────────────────────────────────────────────────

class _DashboardCard extends StatefulWidget {
  final String imageAsset;
  final String title;
  final String subtitle;
  final List<Color> gradientColors;
  final String pill;
  final IconData pillIcon;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.imageAsset,
    required this.title,
    required this.subtitle,
    required this.gradientColors,
    required this.pill,
    required this.pillIcon,
    required this.onTap,
  });

  @override
  State<_DashboardCard> createState() => _DashboardCardState();
}

class _DashboardCardState extends State<_DashboardCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Container(
          width: 160,
          margin: const EdgeInsets.only(right: 14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: widget.gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: widget.gradientColors[1].withOpacity(0.35),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Background circle decoration
              Positioned(
                right: -18,
                top: -18,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.08),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category pill
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(widget.pillIcon,
                              color: Colors.white, size: 11),
                          const SizedBox(width: 4),
                          Text(widget.pill,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                    const Spacer(),
                    // Centered image
                    Center(
                      child: Image.asset(
                        widget.imageAsset,
                        height: 90,
                        width: 90,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const Spacer(),
                    // Title
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.subtitle,
                      style: TextStyle(
                        fontSize: 11.5,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
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

// ── Article Card ─────────────────────────────────────────────────────────────

class _ArticleCard extends StatelessWidget {
  final String title;
  final String description;
  final String url;
  final String tag;
  final Color tagColor;
  final IconData icon;

  const _ArticleCard({
    required this.title,
    required this.description,
    required this.url,
    required this.tag,
    required this.tagColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border(
          left: BorderSide(color: tagColor, width: 4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.07),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () async {
            final Uri uri = Uri.parse(url);
            if (!await launchUrl(uri,
                mode: LaunchMode.externalApplication)) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Could not open article link')),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: tagColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: tagColor, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: tagColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              tag,
                              style: TextStyle(
                                color: tagColor,
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14.5,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 12.5,
                          color: Colors.grey[600],
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFF6A1B9A).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.arrow_outward_rounded,
                      color: Color(0xFF6A1B9A), size: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}