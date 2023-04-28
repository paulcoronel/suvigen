import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:suvigen/text_util.dart';

import 'constant.dart';

class SpeechTextSyncScreen extends StatefulWidget {
  const SpeechTextSyncScreen({super.key});

  @override
  SpeechTextSyncScreenState createState() => SpeechTextSyncScreenState();
}

class SpeechTextSyncScreenState extends State<SpeechTextSyncScreen> {
  late FlutterTts flutterTts;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    initTts();
    //_speakAndDisplayText();
  }

  Future initTts() async {
    flutterTts = FlutterTts();
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
  }

  Future speak(String text) async {
    await flutterTts.speak(text);
  }

  Future<void> _speakAndDisplayText() async {
    for (int i = currentIndex; i < Constant.originalText.length; i++) {
      await speak(Constant.originalText[i]);
      setState(() {
        currentIndex = i;
      });
      double secondsPerWord = 60 / Constant.averageReadingSpeed;
      double seconds = TextUtil.countWords(Constant.originalText[i]) * secondsPerWord;
      TextUtil.countWords(Constant.originalText[i]);
      await Future.delayed(
          Duration(seconds: seconds.toInt() + 1)); // Display text for 1 second
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Speech and text synchronization"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 60,
            child: Center(
              child: Text(
                Constant.originalText[currentIndex],
                textAlign: TextAlign.center,
                style:
                    const TextStyle(color: Colors.deepPurpleAccent, fontSize: 22),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            flex: 40,
            child: Text(
              Constant.subtitleText[currentIndex],
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ),
        ],
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          currentIndex = 0;
          _speakAndDisplayText();
        },
        child: const Icon(Icons.start),
      ),
    );
  }
}
