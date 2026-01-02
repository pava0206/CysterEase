import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class CardioPage extends StatefulWidget {
  const CardioPage({super.key});

  @override
  State<CardioPage> createState() => _CardioPageState();
}

class _CardioPageState extends State<CardioPage> {
  final List<Map<String, String>> cardioLevels = [
    {
      'title': 'Beginner Cardio',
      'desc': 'Gentle, low-impact routine to boost your metabolism safely.',
      'url': 'https://youtu.be/v2VAr4WZqKQ',
    },
    {
      'title': 'Intermediate Cardio',
      'desc': 'Moderate intensity to improve stamina and burn fat steadily.',
      'url': 'https://youtu.be/JtfLIjNwgNM',
    },
    {
      'title': 'High Intensity Cardio',
      'desc': 'Advanced workout to challenge endurance and build strength.',
      'url': 'https://youtu.be/t3jyZ7yJVv8',
    },
  ];

  final List<YoutubePlayerController> _controllers = [];

  @override
  void initState() {
    super.initState();
    for (var level in cardioLevels) {
      final videoId = YoutubePlayer.convertUrlToId(level['url'] ?? '');
      if (videoId != null && videoId.isNotEmpty) {
        _controllers.add(
          YoutubePlayerController(
            initialVideoId: videoId,
            flags: const YoutubePlayerFlags(
              autoPlay: false,
              mute: false,
              loop: false,
            ),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _launchYouTube(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open YouTube')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(
        title: const Text(
          "Steady-State Cardio",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _controllers.length,
        itemBuilder: (context, index) {
          final level = cardioLevels[index];
          final controller = _controllers[index];

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
                  Text(
                    level['title']!,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    level['desc']!,
                    style: const TextStyle(fontSize: 15, color: Colors.black87),
                  ),
                  const SizedBox(height: 18),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: YoutubePlayer(
                      controller: controller,
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
                      onPressed: () => _launchYouTube(level['url']!),
                      icon: const Icon(Icons.open_in_new, size: 20),
                      label: const Text(
                        "Watch on YouTube",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
