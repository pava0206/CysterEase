import 'package:cysterease/models/chat_message.dart';

/// Abstract interface for chat response generation.
/// Implement this to swap in OpenAI, Gemini, or any LLM without touching the UI.
abstract class BaseChatService {
  Future<ChatMessage> getResponse(String userMessage, {String? lastTopic});
}

/// Keyword-based wellness chat service for CysterEase.
/// Covers PCOS/PCOD topics with warm, coach-like responses.
/// Replace or extend with [OpenAIChatService] in the future.
class ChatService implements BaseChatService {
  /// The last detected topic — used for context-aware follow-up responses.
  String? _lastTopic;

  @override
  Future<ChatMessage> getResponse(
    String userMessage, {
    String? lastTopic,
  }) async {
    // Simulate a natural response delay
    await Future.delayed(const Duration(milliseconds: 600));

    final input = userMessage.toLowerCase().trim();
    final context = lastTopic ?? _lastTopic;

    final result = _match(input, context);
    _lastTopic = result.topic;

    return result;
  }

  /// Matches user input to a topic and returns an appropriate [ChatMessage].
  ChatMessage _match(String input, String? context) {
    // ── PCOS / PCOD ────────────────────────────────────────────────
    if (_has(input, ['pcos', 'pcod', 'polycystic', 'what is pcos', 'ovary'])) {
      return _respond(
        topic: 'pcos',
        text:
            "PCOS (Polycystic Ovary Syndrome) is a hormonal condition that affects many women of reproductive age. 💜\n\n"
            "It can cause irregular periods, excess androgens (male hormones), and small cysts on the ovaries.\n\n"
            "The good news? With the right lifestyle — balanced nutrition, regular movement, quality sleep, and stress management — "
            "most symptoms can be managed really well. You're not alone in this journey! 🌸",
        related: ['Diet', 'Exercise', 'Irregular Periods'],
      );
    }

    // ── DIET ───────────────────────────────────────────────────────
    if (_has(input, [
      'diet',
      'eat',
      'food',
      'meal',
      'nutrition',
      'what to eat',
      'avoid',
    ])) {
      return _respond(
        topic: 'diet',
        text:
            "Food is genuinely one of your most powerful tools for managing PCOS! 🥗\n\n"
            "Focus on a low-GI, anti-inflammatory approach:\n"
            "• Whole grains (oats, quinoa, brown rice) over refined carbs\n"
            "• Plenty of colourful vegetables and leafy greens\n"
            "• Lean proteins: eggs, legumes, fish, chicken\n"
            "• Healthy fats: avocado, nuts, olive oil\n\n"
            "Try to limit processed foods, sugary drinks, and trans fats — they can spike insulin and worsen hormonal imbalance. "
            "Small, balanced meals every 3–4 hours keeps your blood sugar steady. 💪",
        related: ['Insulin Resistance', 'Weight Loss', 'Cravings'],
      );
    }

    // ── WEIGHT LOSS ────────────────────────────────────────────────
    if (_has(input, [
      'weight loss',
      'lose weight',
      'losing weight',
      'slim',
      'fat',
    ])) {
      return _respond(
        topic: 'weight_loss',
        text:
            "Losing weight with PCOS can feel frustrating because insulin resistance makes it harder — but it's absolutely possible! 💜\n\n"
            "Even a 5–10% reduction in body weight can significantly improve hormone levels, period regularity, and fertility.\n\n"
            "What works best:\n"
            "• Low-GI diet with controlled portions\n"
            "• Strength training + cardio combo (3–5x/week)\n"
            "• Consistent sleep (7–9 hrs) — poor sleep raises cortisol and hunger hormones\n"
            "• Managing stress to lower cortisol\n\n"
            "Be patient and kind to yourself — sustainable, slow progress beats crash diets every time. 🌱",
        related: ['Diet', 'Exercise', 'Insulin Resistance'],
      );
    }

    // ── WEIGHT GAIN ────────────────────────────────────────────────
    if (_has(input, ['weight gain', 'gaining weight', 'underweight'])) {
      return _respond(
        topic: 'weight_gain',
        text:
            "Struggling to gain weight with PCOS can happen too, especially if metabolism or gut health is affected. 🌸\n\n"
            "Some helpful approaches:\n"
            "• Eat calorie-dense, nutrient-rich foods: nuts, seeds, avocado, whole milk yoghurt\n"
            "• Add protein to every meal to support muscle building\n"
            "• Strength training helps build lean muscle mass\n"
            "• Avoid skipping meals — eat at regular intervals\n\n"
            "It's always a good idea to consult a registered dietitian who specialises in PCOS — they can create a plan tailored just for you! 💜",
        related: ['Diet', 'Exercise', 'Energy Levels'],
      );
    }

    // ── FERTILITY ──────────────────────────────────────────────────
    if (_has(input, [
      'fertility',
      'pregnant',
      'conceive',
      'pregnancy',
      'ovulation',
      'ttc',
    ])) {
      return _respond(
        topic: 'fertility',
        text:
            "PCOS is one of the most common causes of irregular ovulation, but many women with PCOS do conceive naturally or with support. 🤰💜\n\n"
            "Ways to support your fertility naturally:\n"
            "• Maintain a healthy weight (even small changes help)\n"
            "• Eat a balanced, low-GI diet to regulate insulin\n"
            "• Track your cycle with apps or ovulation kits\n"
            "• Reduce stress — high cortisol can suppress ovulation\n"
            "• Myo-inositol supplements have shown promising results\n\n"
            "If you've been trying for 6–12 months without success, a gynaecologist or fertility specialist can open up more options. You've got this! 🌸",
        related: ['Irregular Periods', 'Stress', 'Diet'],
      );
    }

    // ── SLEEP ──────────────────────────────────────────────────────
    if (_has(input, [
      'sleep',
      'insomnia',
      'tired',
      'rest',
      'night',
      'sleeping',
    ])) {
      return _respond(
        topic: 'sleep',
        text:
            "Sleep and PCOS have a two-way relationship — poor sleep worsens hormone imbalance, and hormone imbalance disrupts sleep! 😴\n\n"
            "Here's how to build better sleep:\n"
            "• Aim for 7–9 hours every night — consistency is key\n"
            "• Wind down 1 hour before bed: dim lights, no screens\n"
            "• Keep a fixed wake time, even on weekends\n"
            "• Avoid caffeine after 2pm\n"
            "• A cool, dark room helps melatonin production\n\n"
            "Women with PCOS are more prone to sleep apnea too — if you snore or wake up exhausted, mention it to your doctor. 💜",
        related: ['Stress', 'Energy Levels', 'Mood Swings'],
      );
    }

    // ── STRESS ────────────────────────────────────────────────────
    if (_has(input, [
      'stress',
      'overwhelm',
      'burnout',
      'pressure',
      'tense',
      'relax',
    ])) {
      return _respond(
        topic: 'stress',
        text:
            "Feeling stressed lately? 💜 Chronic stress raises cortisol, which can directly worsen PCOS symptoms like irregular periods and weight gain.\n\n"
            "Even 10–15 minutes a day of intentional stress relief makes a real difference:\n"
            "• Deep breathing (try box breathing: inhale 4s, hold 4s, exhale 4s)\n"
            "• A short walk in nature — proven to lower cortisol\n"
            "• Journaling your thoughts before bed\n"
            "• Gentle yoga or stretching\n"
            "• Connecting with someone you trust\n\n"
            "You don't have to do it all. Start with one small thing today. 🌿",
        related: ['Anxiety', 'Sleep', 'Mood Swings'],
      );
    }

    // ── ANXIETY ───────────────────────────────────────────────────
    if (_has(input, ['anxiety', 'anxious', 'panic', 'worry', 'nervous'])) {
      return _respond(
        topic: 'anxiety',
        text:
            "Anxiety is more common with PCOS than many realise — hormonal fluctuations, especially in oestrogen and progesterone, directly affect mood and the nervous system. 💜\n\n"
            "Some evidence-backed strategies:\n"
            "• Magnesium-rich foods (dark chocolate, spinach, almonds) support nervous system calm\n"
            "• Regular exercise releases endorphins — nature's anxiety relief\n"
            "• Limit caffeine, which can amplify anxiety\n"
            "• Mindfulness apps (like Headspace or Calm) used for just 5 minutes help\n\n"
            "If anxiety is significantly affecting your daily life, speaking to a therapist or counsellor is a brave and worthwhile step. You deserve support. 🌸",
        related: ['Stress', 'Mood Swings', 'Sleep'],
      );
    }

    // ── EXERCISE ──────────────────────────────────────────────────
    if (_has(input, [
      'exercise',
      'workout',
      'gym',
      'fitness',
      'walk',
      'yoga',
      'movement',
      'active',
    ])) {
      return _respond(
        topic: 'exercise',
        text:
            "Movement is medicine for PCOS! 💪 Exercise helps lower insulin resistance, balance hormones, and improve mood.\n\n"
            "The sweet spot for PCOS:\n"
            "• Strength training 2–3x/week — builds muscle, boosts metabolism\n"
            "• Low-impact cardio: walking, swimming, cycling (30 mins most days)\n"
            "• Yoga and Pilates — reduce cortisol and inflammation\n"
            "• Avoid overtraining — it raises cortisol and can worsen symptoms\n\n"
            "Start where you are. Even a 20-minute daily walk has been shown to improve insulin sensitivity. The best workout is the one you'll actually enjoy and stick to! 🌿",
        related: ['Weight Loss', 'Insulin Resistance', 'Mood Swings'],
      );
    }

    // ── MOOD SWINGS ───────────────────────────────────────────────
    if (_has(input, [
      'mood',
      'mood swing',
      'emotional',
      'irritable',
      'cry',
      'sad',
      'depressed',
    ])) {
      return _respond(
        topic: 'mood',
        text:
            "Mood swings with PCOS are so real — and so valid. 💜 Fluctuating oestrogen and progesterone directly affect serotonin (your feel-good neurotransmitter).\n\n"
            "Things that genuinely help:\n"
            "• Regular meals to avoid blood sugar crashes that worsen mood\n"
            "• Omega-3 rich foods (salmon, walnuts, flaxseed) support brain health\n"
            "• Daily movement — even a short walk lifts mood noticeably\n"
            "• Track your mood alongside your cycle to spot patterns\n"
            "• Don't isolate — connection with loved ones is powerful medicine\n\n"
            "If low mood persists, please reach out to a mental health professional. You deserve to feel well. 🌸",
        related: ['Anxiety', 'Stress', 'Sleep'],
      );
    }

    // ── IRREGULAR PERIODS ─────────────────────────────────────────
    if (_has(input, [
      'irregular period',
      'late period',
      'missed period',
      'cycle',
      'period irregular',
      'no period',
    ])) {
      return _respond(
        topic: 'periods',
        text:
            "Irregular periods are one of the most common PCOS symptoms, caused by disrupted ovulation. 📅\n\n"
            "What can help regulate your cycle:\n"
            "• Balanced diet that stabilises blood sugar and insulin\n"
            "• Regular moderate exercise\n"
            "• Stress management — high cortisol delays ovulation\n"
            "• Maintaining a healthy weight\n"
            "• Tracking your cycle helps you spot patterns over time\n\n"
            "If your periods are very irregular or absent for more than 3 months, it's worth checking in with your gynaecologist — there are effective medical options too. 💜",
        related: ['PCOS', 'Fertility', 'Stress'],
      );
    }

    // ── PERIOD PAIN ───────────────────────────────────────────────
    if (_has(input, [
      'period pain',
      'cramps',
      'dysmenorrhea',
      'painful period',
    ])) {
      return _respond(
        topic: 'period_pain',
        text:
            "Period pain is no joke — and with PCOS, it can be intense. 💜\n\n"
            "Some natural relief strategies:\n"
            "• Heat therapy: a warm pad on your lower abdomen works wonders\n"
            "• Gentle yoga poses like child's pose and supine twists ease cramps\n"
            "• Magnesium and omega-3 supplements can reduce prostaglandin-related pain\n"
            "• Stay hydrated — dehydration worsens cramps\n"
            "• Avoid caffeine during your period\n\n"
            "If your pain is severe or disrupting your life, please see a doctor — conditions like endometriosis can co-exist with PCOS and need their own treatment. 🌸",
        related: ['Irregular Periods', 'Stress', 'Diet'],
      );
    }

    // ── ACNE ──────────────────────────────────────────────────────
    if (_has(input, ['acne', 'pimple', 'skin', 'breakout', 'blemish'])) {
      return _respond(
        topic: 'acne',
        text:
            "PCOS-related acne is driven by excess androgens (male hormones) that overstimulate oil glands. 🌸\n\n"
            "What helps from the inside out:\n"
            "• Low-GI diet: spikes in insulin trigger androgen production\n"
            "• Stay hydrated and reduce dairy if you notice a link\n"
            "• Anti-inflammatory foods: turmeric, berries, leafy greens\n"
            "• Manage stress — cortisol worsens breakouts\n\n"
            "Topically, look for salicylic acid or niacinamide. If acne is persistent or cystic, a dermatologist can recommend treatments like spironolactone or specific topicals. You deserve clear, comfortable skin! 💜",
        related: ['Hair Fall', 'Diet', 'PCOS'],
      );
    }

    // ── HAIR FALL ─────────────────────────────────────────────────
    if (_has(input, [
      'hair fall',
      'hair loss',
      'thinning hair',
      'bald',
      'hair',
    ])) {
      return _respond(
        topic: 'hair_fall',
        text:
            "Hair thinning with PCOS is caused by high androgens, particularly DHT, affecting the hair follicles. It's distressing, but manageable! 💜\n\n"
            "What helps:\n"
            "• Iron, zinc, and biotin deficiencies are common with PCOS — get your levels checked\n"
            "• A protein-rich diet supports hair structure\n"
            "• Scalp massages with rosemary oil have shown results comparable to minoxidil in some studies\n"
            "• Reduce heat styling and harsh chemical treatments\n"
            "• Managing insulin resistance helps lower androgen levels overall\n\n"
            "A dermatologist can recommend medical treatments like minoxidil or anti-androgens if needed. 🌸",
        related: ['Acne', 'Insulin Resistance', 'Diet'],
      );
    }

    // ── INSULIN RESISTANCE ────────────────────────────────────────
    if (_has(input, [
      'insulin',
      'insulin resistance',
      'blood sugar',
      'diabetes',
      'glucose',
    ])) {
      return _respond(
        topic: 'insulin_resistance',
        text:
            "Insulin resistance is at the root of many PCOS symptoms — up to 70% of women with PCOS have it. 💡\n\n"
            "When cells resist insulin, the pancreas produces more, which triggers higher androgen levels — causing many familiar PCOS symptoms.\n\n"
            "How to improve insulin sensitivity:\n"
            "• Low-GI diet: whole grains, fibre-rich veg, legumes\n"
            "• Exercise — even walking 30 mins/day makes a difference\n"
            "• Intermittent fasting (with medical guidance) can help some women\n"
            "• Myo-inositol supplements are well-studied for PCOS insulin resistance\n"
            "• Cinnamon has modest blood sugar-lowering effects\n\n"
            "Getting your fasting insulin and HbA1c tested is a great first step! 💜",
        related: ['Diet', 'Weight Loss', 'Exercise'],
      );
    }

    // ── CRAVINGS ──────────────────────────────────────────────────
    if (_has(input, [
      'craving',
      'sugar craving',
      'binge',
      'junk food',
      'chocolate',
      'sweet',
    ])) {
      return _respond(
        topic: 'cravings',
        text:
            "Those intense sugar cravings? They're not weakness — they're often a sign of blood sugar instability or low serotonin, both common in PCOS. 🍫\n\n"
            "How to tame them:\n"
            "• Never skip meals — eat protein + healthy fat at every meal to stay satiated\n"
            "• Chromium-rich foods (broccoli, eggs, whole grains) help regulate blood sugar\n"
            "• Dark chocolate (70%+) satisfies sweet cravings with less sugar impact\n"
            "• When a craving hits, drink a glass of water and wait 10 minutes\n"
            "• Magnesium deficiency often drives chocolate cravings — try adding more leafy greens\n\n"
            "You're not out of control — your hormones are asking for something. Let's figure out what! 💜",
        related: ['Diet', 'Insulin Resistance', 'Mood Swings'],
      );
    }

    // ── ENERGY ────────────────────────────────────────────────────
    if (_has(input, [
      'energy',
      'fatigue',
      'tired',
      'exhausted',
      'low energy',
      'sluggish',
    ])) {
      return _respond(
        topic: 'energy',
        text:
            "Constant fatigue with PCOS is so common — insulin resistance, poor sleep, thyroid issues, and anaemia all play a role. 💜\n\n"
            "Energy boosters that actually work:\n"
            "• Check your vitamin D, B12, iron, and thyroid levels — deficiencies are common\n"
            "• Balanced meals every 3–4 hours prevent energy crashes\n"
            "• Hydration is underrated — even mild dehydration causes fatigue\n"
            "• Morning sunlight + gentle exercise kicks off your energy for the day\n"
            "• Prioritise 7–9 hours of sleep\n\n"
            "If fatigue is persistent despite lifestyle changes, please speak to your doctor about testing. You deserve to feel energised! ⚡",
        related: ['Sleep', 'Diet', 'Insulin Resistance'],
      );
    }

    // ── HYDRATION ─────────────────────────────────────────────────
    if (_has(input, ['hydration', 'water', 'drink', 'dehydrat'])) {
      return _respond(
        topic: 'hydration',
        text:
            "Hydration is a simple but powerful part of PCOS management that's easy to overlook! 💧\n\n"
            "Why it matters:\n"
            "• Supports kidney function in flushing excess hormones\n"
            "• Reduces bloating and water retention (counterintuitive, but true!)\n"
            "• Helps transport nutrients and regulate blood sugar\n"
            "• Improves energy and focus\n\n"
            "Aim for 8–10 glasses (2–2.5L) of water daily. Herbal teas like spearmint (shown to reduce androgens!), cinnamon, and chamomile count too.\n\n"
            "Tip: Keep a water bottle visible on your desk as a reminder. Small habits, big impact! 💜",
        related: ['Diet', 'Energy Levels', 'Cravings'],
      );
    }

    // ── CONTEXT-AWARE FOLLOW-UPS ──────────────────────────────────
    // If no direct keyword match, check if the question relates to the last topic
    if (context != null) {
      final followUp = _contextualFollowUp(input, context);
      if (followUp != null) return followUp;
    }

    // ── GREETINGS ─────────────────────────────────────────────────
    if (_has(input, ['hi', 'hello', 'hey', 'hiya', 'good morning', 'howdy'])) {
      return _respond(
        topic: null,
        text:
            "Hey there! 💜 I'm so glad you're here.\n\n"
            "I'm CysterEase AI — your personal PCOS wellness companion. I'm here to help with questions about diet, exercise, sleep, stress, periods, fertility, and more.\n\n"
            "What's on your mind today? 🌸",
        related: ['PCOS', 'Diet', 'Stress'],
      );
    }

    // ── THANK YOU ─────────────────────────────────────────────────
    if (_has(input, ['thank', 'thanks', 'helpful', 'great', 'awesome'])) {
      return _respond(
        topic: null,
        text:
            "You're so welcome! 💜 Remember, every small step you take is progress.\n\n"
            "Is there anything else on your mind? I'm here whenever you need me. 🌸",
        related: ['Diet', 'Sleep', 'Exercise'],
      );
    }

    // ── DEFAULT FALLBACK ──────────────────────────────────────────
    return _respond(
      topic: null,
      text:
          "That's a great question! 💜 I'm best at helping with PCOS/PCOD topics like diet, exercise, sleep, stress, periods, fertility, and emotional wellness.\n\n"
          "Could you tell me a bit more, or try one of the quick topics below? I want to make sure I give you the most helpful answer! 🌸",
      related: ['PCOS', 'Diet', 'Stress'],
    );
  }

  /// Handles context-aware follow-up questions based on the previous topic.
  ChatMessage? _contextualFollowUp(String input, String context) {
    // e.g. user asked about diet, now asks "what about snacks?"
    if (context == 'diet' &&
        _has(input, ['snack', 'between meal', 'hunger'])) {
      return _respond(
        topic: 'diet',
        text:
            "Great follow-up! 🥗 Smart snacking keeps your blood sugar stable between meals.\n\n"
            "PCOS-friendly snack ideas:\n"
            "• Apple slices with almond butter\n"
            "• A small handful of mixed nuts\n"
            "• Greek yoghurt with berries\n"
            "• Hummus with veggie sticks\n"
            "• A boiled egg with a few whole grain crackers\n\n"
            "Aim for snacks that combine protein + healthy fat + fibre — this trio keeps cravings at bay! 💜",
        related: ['Insulin Resistance', 'Cravings', 'Weight Loss'],
      );
    }

    if (context == 'exercise' &&
        _has(input, ['beginner', 'start', 'new', 'where'])) {
      return _respond(
        topic: 'exercise',
        text:
            "Starting out is the hardest part — and you're already asking, which means you're ready! 💪\n\n"
            "A beginner-friendly PCOS workout week:\n"
            "• Mon/Wed/Fri: 20–30 min brisk walk\n"
            "• Tue/Thu: 20 min gentle yoga or stretching\n"
            "• Weekend: rest or a fun activity you enjoy\n\n"
            "After 2–3 weeks, you can add light strength training. Progress, not perfection! 💜",
        related: ['Weight Loss', 'Mood Swings', 'Energy Levels'],
      );
    }

    if (context == 'sleep' && _has(input, ['tip', 'help', 'improve'])) {
      return _respond(
        topic: 'sleep',
        text:
            "Here are my favourite sleep tips for PCOS specifically 😴💜\n\n"
            "• Try a magnesium glycinate supplement before bed — it promotes deep sleep\n"
            "• Chamomile or valerian root tea is wonderfully calming\n"
            "• A 10-minute body scan meditation helps quiet a racing mind\n"
            "• Keep your phone out of the bedroom if possible\n"
            "• A consistent bedtime (even 10:30pm) trains your body's clock\n\n"
            "Which of these would you like to try first? 🌙",
        related: ['Stress', 'Energy Levels', 'Mood Swings'],
      );
    }

    return null; // No context match found
  }

  // ── HELPERS ─────────────────────────────────────────────────────

  /// Checks whether the input contains any of the given [keywords].
  bool _has(String input, List<String> keywords) {
    return keywords.any((k) => input.contains(k));
  }

  /// Builds a [ChatMessage] bot response with optional topic and related chips.
  ChatMessage _respond({
    required String text,
    required String? topic,
    List<String>? related,
  }) {
    return ChatMessage(
      text: text,
      isUser: false,
      timestamp: DateTime.now(),
      topic: topic,
      relatedTopics: related,
    );
  }
}