import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'dashboard_page.dart';

class SleepTrackerPage extends StatefulWidget {
  const SleepTrackerPage({super.key});

  @override
  State<SleepTrackerPage> createState() => _SleepTrackerPageState();
}

class _SleepTrackerPageState extends State<SleepTrackerPage> {
  TimeOfDay? sleepTime;
  TimeOfDay? wakeTime;
  String? duration;
  double? sleepHours;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  void calculateDuration() {
    if (sleepTime != null && wakeTime != null) {
      final now = DateTime.now();
      var sleep = DateTime(
        now.year,
        now.month,
        now.day,
        sleepTime!.hour,
        sleepTime!.minute,
      );
      var wake = DateTime(
        now.year,
        now.month,
        now.day,
        wakeTime!.hour,
        wakeTime!.minute,
      );

      if (wake.isBefore(sleep)) {
        wake = wake.add(const Duration(days: 1));
      }

      final diff = wake.difference(sleep);
      setState(() {
        sleepHours = diff.inMinutes / 60.0;
        duration = "${diff.inHours}h ${diff.inMinutes.remainder(60)}m";
      });
    }
  }

  // ⬇️ Save into sleep_tracker collection
  Future<void> saveSleepData() async {
    if (sleepHours != null && currentUser != null) {
      final now = DateTime.now();
      await _firestore.collection('sleep_tracker').add({
        'userId': currentUser!.uid,
        'createdAt': now,
        'date': DateFormat('yyyy-MM-dd').format(now),
        // match your old names if you like, but we’ll also follow the doc style
        'sleepStart': sleepTime!.format(context),
        'sleepEnd': wakeTime!.format(context),
        'sleepDuration': sleepHours, // used for the graph
        // optional extra field if you still want it
        'durationText': duration,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sleep data saved successfully! 😴'),
          backgroundColor: Colors.deepPurple,
        ),
      );
    }
  }

  // ⬇️ Clear all data from sleep_tracker collection
  Future<void> clearAllSleepData() async {
    if (currentUser == null) return;

    final query = await _firestore
        .collection('sleep_tracker')
        .where('userId', isEqualTo: currentUser!.uid)
        .get();

    for (var doc in query.docs) {
      await doc.reference.delete();
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All sleep data cleared successfully 🧹'),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }

  // ⬇️ Stream from sleep_tracker collection
  Stream<List<Map<String, dynamic>>> getUserSleepData() {
    if (currentUser == null) {
      return const Stream.empty();
    }

    return _firestore
        .collection('sleep_tracker')
        .where('userId', isEqualTo: currentUser!.uid)
        .orderBy('createdAt') // using createdAt field
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  @override
  Widget build(BuildContext context) {
      debugPrint("Current user UID: ${currentUser?.uid}");
        
      return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Sleep Tracker 💤',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.deepPurple),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const DashboardPage()),
            );
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEDE7F6), Color(0xFFF3E5F5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepPurple.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      "Track your sleep to restore balance 🌙",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 15),
                    _buildTimeButton(
                      icon: Icons.nightlight_round,
                      label:
                          "Bedtime: ${sleepTime?.format(context) ?? 'Select'}",
                      onPressed: () async {
                        final time = await showTimePicker(
                            context: context, initialTime: TimeOfDay.now());
                        if (time != null) setState(() => sleepTime = time);
                      },
                    ),
                    const SizedBox(height: 10),
                    _buildTimeButton(
                      icon: Icons.wb_sunny_rounded,
                      label:
                          "Wake-up: ${wakeTime?.format(context) ?? 'Select'}",
                      onPressed: () async {
                        final time = await showTimePicker(
                            context: context, initialTime: TimeOfDay.now());
                        if (time != null) setState(() => wakeTime = time);
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildGradientButton(
                      text: "Calculate Duration",
                      onTap: calculateDuration,
                    ),
                    if (duration != null) ...[
                      const SizedBox(height: 15),
                      Text(
                        "Total Sleep: $duration",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildGradientButton(
                        text: "Save Log",
                        onTap: saveSleepData,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 35),
              const Text(
                "🕒 Sleep Trend (All Recorded Days)",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepPurple.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: StreamBuilder<List<Map<String, dynamic>>>(
                  stream: getUserSleepData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.deepPurple,
                        ),
                      );
                    }
                    if (snapshot.hasError) {
                      return Text(
                        'Error loading sleep data: ${snapshot.error}',
                        style: const TextStyle(color: Colors.red),
                      );
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text(
                        "No sleep data yet. Start tracking tonight 🌙",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.deepPurple),
                      );
                    }
                    final data = snapshot.data!;
                    final spots = data.asMap().entries.map((entry) {
                      return FlSpot(
                        entry.key.toDouble(),
                        (entry.value['sleepDuration'] as num).toDouble(),
                      );
                    }).toList();

                    return SizedBox(
                      height: 200,
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(show: false),
                          borderData: FlBorderData(show: false),
                          titlesData: FlTitlesData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              spots: spots,
                              isCurved: true,
                              color: Colors.deepPurple,
                              dotData: FlDotData(show: true),
                              belowBarData: BarAreaData(
                                show: true,
                                color: Colors.deepPurple.withOpacity(0.2),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 25),
              const Text(
                "💤 Good sleep keeps your hormones happy and mind calm. Let’s make rest your nightly ritual 💫",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontStyle: FontStyle.italic,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 25),
              _buildGradientButton(
                text: "← Back to Dashboard",
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DashboardPage()),
                  );
                },
              ),
              const SizedBox(height: 20),
              _buildGradientButton(
                text: "🧹 Clear All Data",
                onTap: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Clear All Data?"),
                      content: const Text(
                          "This will permanently delete all your sleep logs."),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text(
                            "Clear",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    await clearAllSleepData();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple[100],
        foregroundColor: Colors.deepPurple[900],
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      icon: Icon(icon),
      label: Text(label),
      onPressed: onPressed,
    );
  }

  Widget _buildGradientButton({
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF7E57C2), Color(0xFFBA68C8)],
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurple.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child:  Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}
