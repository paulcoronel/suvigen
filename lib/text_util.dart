class TextUtil {
  static List<String> splitIntoSentences(String text) {
    List<String> sentences = [];
    final RegExp endOfSentence = RegExp(r"(\w|\s|,|')+[。.?!]*\s*");
    Iterable matches = endOfSentence.allMatches(text);

    //  Iterate all matches:
    for (Match m in matches) {
      String? sentence = m.group(0);
      sentences.add(sentence ?? "");
    }
    return sentences;
  }
}
