import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/period_service.dart';

import '../widgets/mood_selector.dart';
import '../widgets/wellness_tip_card.dart';
import '../widgets/history_log_card.dart';

class PeriodTrackerPage extends StatefulWidget {
  const PeriodTrackerPage({super.key});

  @override
  State<PeriodTrackerPage> createState() =>
      _PeriodTrackerPageState();
}

class _PeriodTrackerPageState
    extends State<PeriodTrackerPage> {

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

  final notesController =
      TextEditingController();

  bool isSaving = false;
  bool isLoading = true;

  final List<String> selectedSymptoms =
      [];

  List<Map<String, dynamic>> logs = [];

  final List<String> symptoms = [
    'Cramps',
    'Headache',
    'Fatigue',
    'Mood Swings',
    'Bloating',
    'Acne',
    'Back Pain',
    'Cravings',
  ];

  final List<String> flowOptions = [
    'Light',
    'Medium',
    'Heavy',
  ];

  final List<String> wellnessTips = [
    "Stay hydrated during your cycle 💧",
    "Light exercise can reduce cramps 🌸",
    "Prioritize sleep for hormone balance 😴",
    "Iron-rich foods help during periods 🥗",
    "Track symptoms to understand patterns 💜",
  ];

  @override
  void initState() {
    super.initState();
    fetchLogs();
  }

  @override
  void dispose() {
    notesController.dispose();
    super.dispose();
  }

  ////////////////////////////////////////////////////////
  /// FETCH LOGS
  ////////////////////////////////////////////////////////

  Future<void> fetchLogs() async {

    try {

      final snapshot =
          await service.fetchLogs();

      logs = snapshot.docs
          .map((e) => {
                'id': e.id,
                ...e.data()
                    as Map<String, dynamic>,
              })
          .toList();

    } catch (e) {

      debugPrint(e.toString());

    }

    if (mounted) {

      setState(() {
        isLoading = false;
      });

    }
  }

  ////////////////////////////////////////////////////////
  /// SAVE LOG
  ////////////////////////////////////////////////////////

  Future<void> saveLog() async {

    if (startDate == null) {

      showSnack(
          "Please select start date");

      return;
    }

    setState(() {
      isSaving = true;
    });

    try {

      await service.savePeriodLog(
        startDate: startDate!,
        endDate: endDate,
        cycleLength: cycleLength,
        periodDuration: periodDuration,
        painLevel: painLevel.round(),
        energyLevel:
            energyLevel.round(),
        flowIntensity: selectedFlow,
        mood: selectedMood,
        notes:
            notesController.text.trim(),
        symptoms: selectedSymptoms,
      );

      showSnack(
          "Period log saved 🌸");

      setState(() {

        selectedSymptoms.clear();

        notesController.clear();

      });

      fetchLogs();

    } catch (e) {

      showSnack(
          "Failed to save log");

    }

    if (mounted) {

      setState(() {
        isSaving = false;
      });

    }
  }

  ////////////////////////////////////////////////////////
  /// SNACKBAR
  ////////////////////////////////////////////////////////

  void showSnack(String msg) {

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  ////////////////////////////////////////////////////////
  /// CURRENT PHASE
  ////////////////////////////////////////////////////////

  String get currentPhase {

    if (startDate == null) {
      return "Unknown";
    }

    final day = DateTime.now()
            .difference(startDate!)
            .inDays %
        cycleLength;

    if (day < periodDuration) {
      return "Menstrual 🩸";
    } else if (day < 13) {
      return "Follicular 🌱";
    } else if (day < 16) {
      return "Ovulation 🌸";
    }

    return "Luteal 🌙";
  }

  ////////////////////////////////////////////////////////
  /// UI
  ////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      resizeToAvoidBottomInset: true,

      backgroundColor:
          const Color(0xFFF8F5FF),

      appBar: AppBar(
        backgroundColor:
            Colors.deepPurple,

        title: const Text(
          "Period Tracker 🌸",
        ),
      ),

      body: IndexedStack(
        index: currentIndex,
        children: [

          buildHomePage(),

          buildLogPage(),

          buildHistoryPage(),
        ],
      ),

      bottomNavigationBar:
          BottomNavigationBar(

        currentIndex: currentIndex,

        selectedItemColor:
            Colors.deepPurple,

        onTap: (value) {

          setState(() {
            currentIndex = value;
          });

        },

        items: const [

          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            label: 'Log',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
      ),
    );
  }

  ////////////////////////////////////////////////////////
  /// HOME PAGE
  ////////////////////////////////////////////////////////

  Widget buildHomePage() {

    return ListView(
      padding: const EdgeInsets.all(20),

      children: [

        Container(
          padding:
              const EdgeInsets.all(24),

          decoration: BoxDecoration(
            gradient:
                const LinearGradient(
              colors: [
                Colors.deepPurple,
                Color(0xFF8B5CF6),
              ],
            ),

            borderRadius:
                BorderRadius.circular(
                    28),
          ),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment
                    .start,

            children: [

              const Text(
                "Current Phase",
                style: TextStyle(
                  color: Colors.white70,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                currentPhase,

                style:
                    const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        WellnessTipCard(
          tip: wellnessTips[
              DateTime.now()
                      .day %
                  wellnessTips.length],
        ),

        const SizedBox(height: 24),

        Row(
          children: [

            Expanded(
              child: summaryCard(
                "Cycle",
                "$cycleLength Days",
                Icons.loop,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: summaryCard(
                "Pain",
                "${painLevel.round()}/10",
                Icons.favorite,
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        Row(
          children: [

            Expanded(
              child: summaryCard(
                "Energy",
                "${energyLevel.round()}/10",
                Icons.bolt,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: summaryCard(
                "Logs",
                logs.length.toString(),
                Icons.history,
              ),
            ),
          ],
        ),
      ],
    );
  }

  ////////////////////////////////////////////////////////
  /// LOG PAGE
  ////////////////////////////////////////////////////////

  Widget buildLogPage() {

    return SafeArea(
      child: SingleChildScrollView(

        keyboardDismissBehavior:
            ScrollViewKeyboardDismissBehavior
                .onDrag,

        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            buildSectionTitle(
                "Period Dates"),

            const SizedBox(height: 14),

            Row(
              children: [

                Expanded(
                  child: dateCard(
                    "Start Date",
                    startDate,
                    (date) {

                      setState(() {
                        startDate = date;
                      });

                    },
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: dateCard(
                    "End Date",
                    endDate,
                    (date) {

                      setState(() {
                        endDate = date;
                      });

                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 26),

            buildSectionTitle(
                "Flow Intensity"),

            const SizedBox(height: 12),

            Wrap(
              spacing: 10,

              children:
                  flowOptions.map((flow) {

                final selected =
                    selectedFlow ==
                        flow;

                return ChoiceChip(
                  label: Text(flow),

                  selected: selected,

                  selectedColor:
                      Colors.deepPurple,

                  labelStyle:
                      TextStyle(
                    color: selected
                        ? Colors.white
                        : Colors.black,
                  ),

                  onSelected: (_) {

                    setState(() {
                      selectedFlow =
                          flow;
                    });

                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 26),

            buildSlider(
              "Pain Level",
              painLevel,

              (value) {

                setState(() {
                  painLevel = value;
                });

              },
            ),

            const SizedBox(height: 18),

            buildSlider(
              "Energy Level",
              energyLevel,

              (value) {

                setState(() {
                  energyLevel = value;
                });

              },
            ),

            const SizedBox(height: 26),

            buildSectionTitle("Mood"),

            const SizedBox(height: 14),

            MoodSelector(
              selectedMood:
                  selectedMood,

              onMoodSelected:
                  (mood) {

                setState(() {
                  selectedMood =
                      mood;
                });

              },
            ),

            const SizedBox(height: 26),

            buildSectionTitle(
                "Symptoms"),

            const SizedBox(height: 14),

            Wrap(
              spacing: 10,
              runSpacing: 10,

              children:
                  symptoms.map((symptom) {

                final selected =
                    selectedSymptoms
                        .contains(
                            symptom);

                return FilterChip(
                  label:
                      Text(symptom),

                  selected:
                      selected,

                  selectedColor:
                      Colors.deepPurple,

                  labelStyle:
                      TextStyle(
                    color: selected
                        ? Colors.white
                        : Colors.black,
                  ),

                  onSelected: (_) {

                    setState(() {

                      if (selected) {

                        selectedSymptoms
                            .remove(
                                symptom);

                      } else {

                        selectedSymptoms
                            .add(
                                symptom);
                      }
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            buildSectionTitle(
                "Notes"),

            const SizedBox(height: 14),

            Container(
              padding:
                  const EdgeInsets.all(4),

              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius:
                    BorderRadius.circular(
                        20),

                boxShadow: [

                  BoxShadow(
                    color: Colors.deepPurple
                        .withOpacity(0.05),

                    blurRadius: 6,

                    offset:
                        const Offset(
                            0,
                            3),
                  ),
                ],
              ),

              child: TextField(
                controller:
                    notesController,

                maxLines: 5,

                cursorColor:
                    Colors.deepPurple,

                style:
                    const TextStyle(
                  fontSize: 15,
                  color: Colors.black87,
                ),

                decoration:
                    InputDecoration(

                  hintText:
                      "Write your notes here...",

                  hintStyle: TextStyle(
                    color:
                        Colors.grey
                            .shade500,
                  ),

                  border:
                      InputBorder.none,

                  contentPadding:
                      const EdgeInsets
                          .all(16),
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              height: 56,

              child: ElevatedButton(

                onPressed:
                    isSaving
                        ? null
                        : saveLog,

                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors
                          .deepPurple,

                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius
                            .circular(
                                20),
                  ),
                ),

                child: isSaving
                    ? const CircularProgressIndicator(
                        color:
                            Colors
                                .white,
                      )

                    : const Text(
                        "Save Log 🌸",

                        style:
                            TextStyle(
                          color: Colors
                              .white,

                          fontSize: 16,

                          fontWeight:
                              FontWeight
                                  .bold,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  ////////////////////////////////////////////////////////
  /// HISTORY PAGE
  ////////////////////////////////////////////////////////

  Widget buildHistoryPage() {

    if (isLoading) {

      return const Center(
        child:
            CircularProgressIndicator(),
      );
    }

    if (logs.isEmpty) {

      return const Center(
        child:
            Text("No logs yet 🌸"),
      );
    }

    return ListView.builder(

      padding:
          const EdgeInsets.all(20),

      itemCount: logs.length,

      itemBuilder:
          (context, index) {

        final log = logs[index];

        return GestureDetector(

          onTap: () {

            showModalBottomSheet(

              context: context,

              backgroundColor:
                  Colors.white,

              isScrollControlled:
                  true,

              shape:
                  const RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(
                  top:
                      Radius.circular(
                          30),
                ),
              ),

              builder: (context) {

                return Padding(

                  padding:
                      const EdgeInsets
                          .all(24),

                  child:
                      SingleChildScrollView(

                    child: Column(

                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,

                      children: [

                        Center(
                          child: Container(
                            width: 60,
                            height: 6,

                            decoration:
                                BoxDecoration(
                              color: Colors
                                  .grey
                                  .shade300,

                              borderRadius:
                                  BorderRadius
                                      .circular(
                                          10),
                            ),
                          ),
                        ),

                        const SizedBox(
                            height: 24),

                        const Text(
                          "Period Details 🌸",

                          style:
                              TextStyle(
                            fontSize: 24,

                            fontWeight:
                                FontWeight
                                    .bold,

                            color: Colors
                                .deepPurple,
                          ),
                        ),

                        const SizedBox(
                            height: 24),

                        detailRow(
                          "Flow",
                          log['flow_intensity'] ??
                              '',
                        ),

                        detailRow(
                          "Mood",
                          log['mood'] ?? '',
                        ),

                        detailRow(
                          "Pain Level",
                          "${log['pain_level'] ?? 0}/10",
                        ),

                        detailRow(
                          "Energy Level",
                          "${log['energy_level'] ?? 0}/10",
                        ),

                        const SizedBox(
                            height: 20),

                        const Text(
                          "Symptoms",

                          style:
                              TextStyle(
                            fontWeight:
                                FontWeight
                                    .bold,

                            fontSize: 18,
                          ),
                        ),

                        const SizedBox(
                            height: 10),

                        Wrap(
                          spacing: 10,
                          runSpacing: 10,

                          children:
                              ((log['symptoms'] ??
                                          [])
                                      as List)

                                  .map(
                                    (symptom) =>
                                        Chip(
                                      label: Text(
                                          symptom),

                                      backgroundColor:
                                          Colors
                                              .deepPurple
                                              .shade50,
                                    ),
                                  )
                                  .toList(),
                        ),

                        const SizedBox(
                            height: 24),

                        const Text(
                          "Notes",

                          style:
                              TextStyle(
                            fontWeight:
                                FontWeight
                                    .bold,

                            fontSize: 18,
                          ),
                        ),

                        const SizedBox(
                            height: 10),

                        Container(
                          width:
                              double.infinity,

                          padding:
                              const EdgeInsets
                                  .all(18),

                          decoration:
                              BoxDecoration(
                            color: Colors
                                .deepPurple
                                .shade50,

                            borderRadius:
                                BorderRadius
                                    .circular(
                                        18),
                          ),

                          child: Text(
                            log['notes']
                                            ?.toString()
                                            .isEmpty ??
                                        true
                                ? "No notes added"
                                : log['notes'],
                          ),
                        ),

                        const SizedBox(
                            height: 30),
                      ],
                    ),
                  ),
                );
              },
            );
          },

          child: HistoryLogCard(
            startDate:
                (log['start_date']
                        as Timestamp)
                    .toDate(),

            flow:
                log['flow_intensity'] ??
                    '',

            mood:
                log['mood'] ?? '',
          ),
        );
      },
    );
  }

  ////////////////////////////////////////////////////////
  /// HELPERS
  ////////////////////////////////////////////////////////

  Widget detailRow(
      String title,
      String value) {

    return Padding(

      padding:
          const EdgeInsets.only(
              bottom: 14),

      child: Row(
        children: [

          Text(
            "$title: ",

            style:
                const TextStyle(
              fontWeight:
                  FontWeight.bold,

              fontSize: 16,
            ),
          ),

          Expanded(
            child: Text(
              value,

              style:
                  const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget summaryCard(
    String title,
    String value,
    IconData icon,
  ) {

    return Container(

      padding:
          const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
                22),
      ),

      child: Column(

        crossAxisAlignment:
            CrossAxisAlignment
                .start,

        children: [

          Icon(icon,
              color:
                  Colors.deepPurple),

          const SizedBox(height: 12),

          Text(
            value,

            style:
                const TextStyle(
              fontSize: 22,

              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            title,

            style:
                const TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSectionTitle(
      String title) {

    return Text(

      title,

      style: const TextStyle(
        fontSize: 18,

        fontWeight:
            FontWeight.bold,
      ),
    );
  }

  Widget buildSlider(
    String title,
    double value,
    Function(double) onChanged,
  ) {

    return Container(

      padding:
          const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
                20),
      ),

      child: Column(
        children: [

          Row(
            mainAxisAlignment:
                MainAxisAlignment
                    .spaceBetween,

            children: [

              Text(title),

              Text(
                value
                    .round()
                    .toString(),

                style:
                    const TextStyle(
                  color: Colors
                      .deepPurple,

                  fontWeight:
                      FontWeight
                          .bold,
                ),
              ),
            ],
          ),

          Slider(
            value: value,

            min: 0,
            max: 10,

            activeColor:
                Colors.deepPurple,

            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget dateCard(
    String label,
    DateTime? date,
    Function(DateTime) onSelected,
  ) {

    return GestureDetector(

      onTap: () async {

        final picked =
            await showDatePicker(

          context: context,

          initialDate:
              DateTime.now(),

          firstDate:
              DateTime(2020),

          lastDate:
              DateTime.now(),
        );

        if (picked != null) {
          onSelected(picked);
        }
      },

      child: Container(

        padding:
            const EdgeInsets.all(18),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius:
              BorderRadius.circular(
                  18),
        ),

        child: Column(

          crossAxisAlignment:
              CrossAxisAlignment
                  .start,

          children: [

            Text(
              label,

              style:
                  const TextStyle(
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              date == null
                  ? "Select"
                  : "${date.day}/${date.month}/${date.year}",

              style:
                  const TextStyle(
                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}