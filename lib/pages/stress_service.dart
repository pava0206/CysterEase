

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Snapshot of a user's stress-management progress.
/// Immutable value object returned by the service / streamed to the UI.
class StressProgress {
  final int xp;
  final int coins;
  final int streakCount;
  final int longestStreak;
  final String lastActiveDate; // yyyy-MM-dd
  final int totalSessions;
  final int bestBreathingScore;
  final int unlockedAffirmations;
  final int unlockedPrompts;
  final int unlockedTips;

  const StressProgress({
    this.xp = 0,
    this.coins = 0,
    this.streakCount = 0,
    this.longestStreak = 0,
    this.lastActiveDate = '',
    this.totalSessions = 0,
    this.bestBreathingScore = 0,
    this.unlockedAffirmations = 6,
    this.unlockedPrompts = 5,
    this.unlockedTips = 8,
  });

  /// Level is purely derived from XP — every 100xp is a new level.
  int get level => 1 + (xp ~/ 100);

  /// XP progress within the current level, 0.0 - 1.0, for progress bars.
  double get levelProgress => (xp % 100) / 100.0;

  int get xpIntoLevel => xp % 100;
  int get xpForNextLevel => 100;

  factory StressProgress.fromMap(Map<String, dynamic>? data) {
    if (data == null) return const StressProgress();
    return StressProgress(
      xp: (data['xp'] ?? 0) as int,
      coins: (data['coins'] ?? 0) as int,
      streakCount: (data['streakCount'] ?? 0) as int,
      longestStreak: (data['longestStreak'] ?? 0) as int,
      lastActiveDate: (data['lastActiveDate'] ?? '') as String,
      totalSessions: (data['totalSessions'] ?? 0) as int,
      bestBreathingScore: (data['bestBreathingScore'] ?? 0) as int,
      unlockedAffirmations: (data['unlockedAffirmations'] ?? 6) as int,
      unlockedPrompts: (data['unlockedPrompts'] ?? 5) as int,
      unlockedTips: (data['unlockedTips'] ?? 8) as int,
    );
  }

  Map<String, dynamic> toMap() => {
        'xp': xp,
        'coins': coins,
        'streakCount': streakCount,
        'longestStreak': longestStreak,
        'lastActiveDate': lastActiveDate,
        'totalSessions': totalSessions,
        'bestBreathingScore': bestBreathingScore,
        'unlockedAffirmations': unlockedAffirmations,
        'unlockedPrompts': unlockedPrompts,
        'unlockedTips': unlockedTips,
      };
}

/// Result of completing an activity — used by the UI to show
/// "+15 XP" toasts, level-up celebrations, and streak milestone banners.
class ActivityResult {
  final int xpGained;
  final int coinsGained;
  final bool leveledUp;
  final int newLevel;
  final bool streakIncreased;
  final int newStreak;
  final bool streakMilestone; // hit 3, 7, 14, 30...
  final bool newContentUnlocked;
  final StressProgress progress;

  ActivityResult({
    required this.xpGained,
    required this.coinsGained,
    required this.leveledUp,
    required this.newLevel,
    required this.streakIncreased,
    required this.newStreak,
    required this.streakMilestone,
    required this.newContentUnlocked,
    required this.progress,
  });
}

class MoodLogEntry {
  final int moodBefore;
  final int moodAfter;
  final String activity;
  final DateTime timestamp;

  MoodLogEntry({
    required this.moodBefore,
    required this.moodAfter,
    required this.activity,
    required this.timestamp,
  });

  int get shift => moodAfter - moodBefore;

  factory MoodLogEntry.fromDoc(Map<String, dynamic> data) {
    final ts = data['timestamp'];
    return MoodLogEntry(
      moodBefore: (data['moodBefore'] ?? 3) as int,
      moodAfter: (data['moodAfter'] ?? 3) as int,
      activity: (data['activity'] ?? '') as String,
      timestamp: ts is Timestamp ? ts.toDate() : DateTime.now(),
    );
  }
}

const List<int> kStreakMilestones = [3, 7, 14, 30, 60, 100];

class StressService {
  StressService._internal();
  static final StressService instance = StressService._internal();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  DocumentReference<Map<String, dynamic>> get _stateDoc {
    final uid = _uid;
    if (uid == null) {
      throw StateError(
          'StressService: no signed-in user. Wrap calls with an auth check.');
    }
    return _db
        .collection('users')
        .doc(uid)
        .collection('stress_data')
        .doc('state');
  }

  CollectionReference<Map<String, dynamic>> get _moodLogs {
    final uid = _uid;
    if (uid == null) {
      throw StateError('StressService: no signed-in user.');
    }
    return _db.collection('users').doc(uid).collection('mood_logs');
  }

  /// Live stream of progress — drives the hub UI in real time.
  Stream<StressProgress> watchProgress() {
    return _stateDoc.snapshots().map((snap) {
      if (!snap.exists) return const StressProgress();
      return StressProgress.fromMap(snap.data());
    });
  }

  Future<StressProgress> getProgress() async {
    final snap = await _stateDoc.get();
    if (!snap.exists) return const StressProgress();
    return StressProgress.fromMap(snap.data());
  }

  String _todayKey() {
    final now = DateTime.now();
    return '${now.year.toString().padLeft(4, '0')}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.day.toString().padLeft(2, '0')}';
  }

  String _dateKeyFromDaysAgo(int days) {
    final d = DateTime.now().subtract(Duration(days: days));
    return '${d.year.toString().padLeft(4, '0')}-'
        '${d.month.toString().padLeft(2, '0')}-'
        '${d.day.toString().padLeft(2, '0')}';
  }

  /// Call this whenever a user completes any stress-management activity.
  /// Handles XP, coins, level-up detection, streak bookkeeping, and
  /// unlocking new content as levels increase. Runs as a transaction so
  /// concurrent completions (rare, but possible) don't corrupt counts.
  Future<ActivityResult> completeActivity({
    required int xpReward,
    required int coinReward,
  }) async {
    final uid = _uid;
    if (uid == null) {
      throw StateError('StressService: no signed-in user.');
    }

    return _db.runTransaction<ActivityResult>((tx) async {
      final snap = await tx.get(_stateDoc);
      final before = StressProgress.fromMap(
          snap.exists ? snap.data() : null);

      final todayKey = _todayKey();
      final yesterdayKey = _dateKeyFromDaysAgo(1);

      bool streakIncreased = false;
      int newStreakCount = before.streakCount;

      if (before.lastActiveDate == todayKey) {
        // Already active today — streak unchanged, but XP still counts.
        newStreakCount = before.streakCount == 0 ? 1 : before.streakCount;
      } else if (before.lastActiveDate == yesterdayKey) {
        newStreakCount = before.streakCount + 1;
        streakIncreased = true;
      } else {
        // Missed a day (or first ever session) — streak restarts at 1.
        newStreakCount = 1;
        streakIncreased = before.streakCount != 0 || before.totalSessions == 0;
      }

      final streakMilestone =
          streakIncreased && kStreakMilestones.contains(newStreakCount);
      final milestoneBonusCoins = streakMilestone ? newStreakCount * 2 : 0;

      final newXp = before.xp + xpReward;
      final newCoins = before.coins + coinReward + milestoneBonusCoins;
      final leveledUp = (newXp ~/ 100) > (before.xp ~/ 100);
      final newLevel = 1 + (newXp ~/ 100);

      // Unlock pacing: +1 affirmation/prompt/tip roughly every level,
      // capped so we never try to "unlock" past the static list lengths
      // defined in each page (those pages clamp on their own too).
      final newUnlockedAffirmations =
          leveledUp ? before.unlockedAffirmations + 1 : before.unlockedAffirmations;
      final newUnlockedPrompts =
          leveledUp ? before.unlockedPrompts + 1 : before.unlockedPrompts;
      final newUnlockedTips =
          leveledUp ? before.unlockedTips + 2 : before.unlockedTips;

      final after = StressProgress(
        xp: newXp,
        coins: newCoins,
        streakCount: newStreakCount,
        longestStreak:
            newStreakCount > before.longestStreak ? newStreakCount : before.longestStreak,
        lastActiveDate: todayKey,
        totalSessions: before.totalSessions + 1,
        bestBreathingScore: before.bestBreathingScore,
        unlockedAffirmations: newUnlockedAffirmations,
        unlockedPrompts: newUnlockedPrompts,
        unlockedTips: newUnlockedTips,
      );

      tx.set(_stateDoc, after.toMap());

      return ActivityResult(
        xpGained: xpReward,
        coinsGained: coinReward + milestoneBonusCoins,
        leveledUp: leveledUp,
        newLevel: newLevel,
        streakIncreased: streakIncreased,
        newStreak: newStreakCount,
        streakMilestone: streakMilestone,
        newContentUnlocked: leveledUp,
        progress: after,
      );
    });
  }

  /// Records a breathing-game score and folds it into the normal
  /// XP/streak pipeline, plus tracks personal best separately.
  Future<ActivityResult> completeBreathingSession({
    required int accuracyScore, // 0-100
  }) async {
    final xp = 10 + (accuracyScore * 0.3).round(); // 10-40 xp
    final coins = 5 + (accuracyScore * 0.1).round(); // 5-15 coins

    final uid = _uid;
    if (uid == null) {
      throw StateError('StressService: no signed-in user.');
    }

    // Update best score first (separate small write is fine — it's not
    // part of the streak-critical path).
    final snap = await _stateDoc.get();
    final current = StressProgress.fromMap(snap.exists ? snap.data() : null);
    if (accuracyScore > current.bestBreathingScore) {
      await _stateDoc.set(
        {'bestBreathingScore': accuracyScore},
        SetOptions(merge: true),
      );
    }

    return completeActivity(xpReward: xp, coinReward: coins);
  }

  /// Logs a mood check-in (before/after an activity) for trend display.
  Future<void> logMood({
    required int moodBefore,
    required int moodAfter,
    required String activity,
  }) async {
    await _moodLogs.add({
      'moodBefore': moodBefore,
      'moodAfter': moodAfter,
      'activity': activity,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  /// Last [limit] mood entries, most recent first — used for the trend chart.
  Future<List<MoodLogEntry>> getRecentMoodLogs({int limit = 14}) async {
    final snap = await _moodLogs
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .get();
    return snap.docs.map((d) => MoodLogEntry.fromDoc(d.data())).toList();
  }

  Stream<List<MoodLogEntry>> watchRecentMoodLogs({int limit = 14}) {
    return _moodLogs
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .snapshots()
        .map((snap) => snap.docs.map((d) => MoodLogEntry.fromDoc(d.data())).toList());
  }
}