class Bible {
  final String bookId;
  final String bookName;
  final int chapter;
  final int verse;
  final String text;

  Bible({
    required this.bookId,
    required this.bookName,
    required this.chapter,
    required this.verse,
    required this.text,
  });
  factory Bible.fromJson(Map<String, dynamic> json) {
    // 1. Get the first verse object from the 'verses' list
    final List verses = json['verses'] ?? [];
    final firstVerse = verses.isNotEmpty ? verses[0] : {};

    // 2. Extract values safely from the first verse
    return Bible(
      bookId: json['book_id'] ?? '',
      bookName: json['book_name'] ?? '',
      chapter: json['chapter'] ?? 0,
      verse: json['verse'] ?? 0,
      text: json['text'] ?? firstVerse['text'] ?? '',
    );
  }
}
