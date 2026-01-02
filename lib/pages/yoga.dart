import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class YogaPage extends StatefulWidget {
  const YogaPage({super.key});

  @override
  State<YogaPage> createState() => _YogaPageState();
}

class _YogaPageState extends State<YogaPage> {
  final List<Map<String, String>> yogaLevels = [
    {
      'title': 'Beginner Yoga',
      'desc': 'Simple stretches to relax your body and improve flexibility.',
      'url': 'https://youtu.be/nTx4treEwHw',
    },
    {
      'title': 'Intermediate Yoga',
      'desc': 'Balance poses to build strength and calm your mind.',
      'url': 'https://youtu.be/GTVvhMPSoE8',
    },
    {
      'title': 'Advanced Yoga',
      'desc': 'Deep flow to enhance focus, energy, and core stability.',
      'url': 'https://youtu.be/zRWUrWPWD2Y',
    },
  ];

  final List<YoutubePlayerController> _controllers = [];

  @override
  void initState() {
    super.initState();
    for (var level in yogaLevels) {
      final id = YoutubePlayer.convertUrlToId(level['url']!);
      if (id != null && id.isNotEmpty) {
        _controllers.add(
          YoutubePlayerController(
            initialVideoId: id,
            flags: const YoutubePlayerFlags(autoPlay: false),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _openYouTube(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(
        title: const Text("Mind-Body Exercises", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: yogaLevels.length,
        itemBuilder: (context, i) {
          final level = yogaLevels[i];
          final c = _controllers[i];
          return Container(
            margin: const EdgeInsets.only(bottom: 28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.deepPurple.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(level['title']!,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple)),
                  const SizedBox(height: 8),
                  Text(level['desc']!,
                      style: const TextStyle(fontSize: 15, color: Colors.black87)),
                  const SizedBox(height: 18),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: YoutubePlayer(
                      controller: c,
                      showVideoProgressIndicator: true,
                      progressIndicatorColor: Colors.deepPurple,
                      bottomActions: [
                        CurrentPosition(),
                        ProgressBar(isExpanded: true),
                        const PlaybackSpeedButton(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _openYouTube(level['url']!),
                      icon: const Icon(Icons.open_in_new, size: 20),
                      label: const Text("Watch on YouTube"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
