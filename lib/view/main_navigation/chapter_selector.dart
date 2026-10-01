import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:salvation_bible_app/view/widgets/bible_search_bar.dart';
import 'package:salvation_bible_app/view/widgets/chapter_selector_number.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../widgets/scriptures_container.dart';
import '../widgets/testaments_containers.dart';

class ChapterSelector extends StatefulWidget {
  const ChapterSelector({super.key});

  @override
  State<ChapterSelector> createState() => _ChapterSelectorState();
}

class _ChapterSelectorState extends State<ChapterSelector> {
  // 0 = All, 1 = Old Testament, 2 = New Testament
  int selectedCategoryIndex = 0;

  late stt.SpeechToText speech;
  bool isListening = false;

  @override
  void initState() {
    super.initState();
    speech = stt.SpeechToText();
  }

  void listen() async {
    if (!isListening) {
      bool available = await speech.initialize(
        onStatus: (status) => debugPrint('status: $status'),
        onError: (error) => debugPrint('error: $error'),
      );
      if (available) {
        setState(() {
          isListening = true;
        });
        speech.listen(
          onResult: (result) {
            setState(() {
              searchController.text = result.recognizedWords;
              if (result.recognizedWords.trim().isEmpty) {
                filteredBooks = [];
              } else {
                filteredBooks = allBookNames
                    .where(
                      (book) => book.toLowerCase().contains(
                        result.recognizedWords.toLowerCase(),
                      ),
                    )
                    .toList();
              }

              // Auto-open book if speech is finalized and matches a book
              if (result.finalResult) {
                String spokenText = result.recognizedWords.trim();
                for (String book in allBookNames) {
                  if (book.toLowerCase() == spokenText.toLowerCase()) {
                    filteredBooks = [];
                    bool isNT = allBookNames.indexOf(book) >= 39;
                    openChapters(book, getChaptersForBook(book), isNT: isNT);
                    break;
                  }
                }
              }
            });
          },
        );
      }
    } else {
      setState(() {
        isListening = false;
      });
      speech.stop();
    }
  }

  final TextEditingController searchController = TextEditingController();

  // All 66 Bible books for real-time suggestions
  final List<String> allBookNames = const [
    'Genesis',
    'Exodus',
    'Leviticus',
    'Numbers',
    'Deuteronomy',
    'Joshua',
    'Judges',
    'Ruth',
    '1 Samuel',
    '2 Samuel',
    '1 Kings',
    '2 Kings',
    '1 Chronicles',
    '2 Chronicles',
    'Ezra',
    'Nehemiah',
    'Esther',
    'Job',
    'Psalms',
    'Proverbs',
    'Ecclesiastes',
    'Song of Solomon',
    'Isaiah',
    'Jeremiah',
    'Lamentations',
    'Ezekiel',
    'Daniel',
    'Hosea',
    'Joel',
    'Amos',
    'Obadiah',
    'Jonah',
    'Micah',
    'Nahum',
    'Habakkuk',
    'Zephaniah',
    'Haggai',
    'Zechariah',
    'Malachi',
    'Matthew',
    'Mark',
    'Luke',
    'John',
    'Acts',
    'Romans',
    '1 Corinthians',
    '2 Corinthians',
    'Galatians',
    'Ephesians',
    'Philippians',
    'Colossians',
    '1 Thessalonians',
    '2 Thessalonians',
    '1 Timothy',
    '2 Timothy',
    'Titus',
    'Philemon',
    'Hebrews',
    'James',
    '1 Peter',
    '2 Peter',
    '1 John',
    '2 John',
    '3 John',
    'Jude',
    'Revelation',
  ];

  List<String> filteredBooks = [];

  int getChaptersForBook(String bookName) {
    const chaptersMap = {
      'Genesis': 50,
      'Exodus': 40,
      'Leviticus': 27,
      'Numbers': 36,
      'Deuteronomy': 34,
      'Joshua': 24,
      'Judges': 21,
      'Ruth': 4,
      '1 Samuel': 31,
      '2 Samuel': 24,
      '1 Kings': 22,
      '2 Kings': 25,
      '1 Chronicles': 29,
      '2 Chronicles': 36,
      'Ezra': 10,
      'Nehemiah': 13,
      'Esther': 10,
      'Job': 42,
      'Psalms': 150,
      'Proverbs': 31,
      'Ecclesiastes': 12,
      'Song of Solomon': 8,
      'Isaiah': 66,
      'Jeremiah': 52,
      'Lamentations': 5,
      'Ezekiel': 48,
      'Daniel': 12,
      'Hosea': 14,
      'Joel': 3,
      'Amos': 9,
      'Obadiah': 1,
      'Jonah': 4,
      'Micah': 7,
      'Nahum': 3,
      'Habakkuk': 3,
      'Zephaniah': 3,
      'Haggai': 2,
      'Zechariah': 14,
      'Malachi': 4,
      'Matthew': 28,
      'Mark': 16,
      'Luke': 24,
      'John': 21,
      'Acts': 28,
      'Romans': 16,
      '1 Corinthians': 16,
      '2 Corinthians': 13,
      'Galatians': 6,
      'Ephesians': 6,
      'Philippians': 4,
      'Colossians': 4,
      '1 Thessalonians': 5,
      '2 Thessalonians': 3,
      '1 Timothy': 6,
      '2 Timothy': 4,
      'Titus': 3,
      'Philemon': 1,
      'Hebrews': 13,
      'James': 5,
      '1 Peter': 5,
      '2 Peter': 3,
      '1 John': 5,
      '2 John': 1,
      '3 John': 1,
      'Jude': 1,
      'Revelation': 22,
    };
    return chaptersMap[bookName] ?? 1;
  }

  void openChapters(String bookName, int chapters, {bool isNT = false}) {
    ChapterSelectorNumber.show(
      context,
      bookName: bookName,
      totalChapters: chapters,
      testamentInfo: isNT
          ? 'New Testament • 27 Books'
          : 'Old Testament • 39 Books',
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        title: Text(
          'Bible',
          style: GoogleFonts.nunitoSans(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: scheme.primary,
              child: const Icon(
                Icons.perm_identity,
                color: Colors.white,
                size: 25,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Edition & 66 Books Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.menu_book, color: scheme.primary, size: 22),
                    const SizedBox(width: 8),
                    Text(
                      'STANDARD EDITION • BEREAN STUDY',
                      style: GoogleFonts.nunitoSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: scheme.onSurface.withValues(alpha: 0.8),
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: scheme.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: scheme.primary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.bookmark_outline,
                        size: 16,
                        color: scheme.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '66 Books',
                        style: GoogleFonts.nunitoSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: scheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Daily Devotion Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: scheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: scheme.primary.withValues(alpha: 0.15),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'DAILY DEVOTION',
                          style: GoogleFonts.nunitoSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: scheme.primary,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '"Your word is a lamp to my feet and a light to my path."',
                          style: GoogleFonts.merriweather(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            color: scheme.onSurface,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Psalm 119:105',
                          style: GoogleFonts.nunitoSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: scheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: scheme.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.wb_sunny_outlined, color: scheme.primary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Search Bar with Real-Time Autocomplete & Voice Search (Mic)
            BibleSearchBar(
              controller: searchController,
              onChanged: (query) {
                setState(() {
                  if (query.trim().isEmpty) {
                    filteredBooks = [];
                  } else {
                    filteredBooks = allBookNames
                        .where(
                          (book) =>
                              book.toLowerCase().contains(query.toLowerCase()),
                        )
                        .toList();
                  }
                });
              },
              onMicTap: listen,
            ),

            // Real-Time Suggestions Dropdown List
            if (filteredBooks.isNotEmpty) ...[
              const SizedBox(height: 6),
              Container(
                constraints: const BoxConstraints(maxHeight: 200),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  clipBehavior: Clip.antiAlias,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: filteredBooks.length,
                    itemBuilder: (context, index) {
                      final book = filteredBooks[index];
                      final isNT = allBookNames.indexOf(book) >= 39;
                      return ListTile(
                        leading: Icon(
                          Icons.menu_book,
                          size: 18,
                          color: scheme.primary,
                        ),
                        title: Text(
                          book,
                          style: GoogleFonts.nunitoSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onTap: () {
                          searchController.text = book;
                          setState(() {
                            filteredBooks = [];
                          });
                          openChapters(
                            book,
                            getChaptersForBook(book),
                            isNT: isNT,
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],

            const SizedBox(height: 10),

            // 1. Horizontal Category Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  TestamentsContainers(
                    text: 'All',
                    color: selectedCategoryIndex == 0
                        ? scheme.primary
                        : const Color(0xFFF2EBE1),
                    textColor: selectedCategoryIndex == 0
                        ? Colors.white
                        : scheme.onSurface,
                    onTap: () {
                      setState(() {
                        selectedCategoryIndex = 0;
                      });
                    },
                  ),
                  TestamentsContainers(
                    text: 'Old Testament',
                    color: selectedCategoryIndex == 1
                        ? scheme.primary
                        : const Color(0xFFF2EBE1),
                    textColor: selectedCategoryIndex == 1
                        ? Colors.white
                        : scheme.onSurface,
                    onTap: () {
                      setState(() {
                        selectedCategoryIndex = 1;
                      });
                    },
                  ),
                  TestamentsContainers(
                    text: 'New Testament',
                    color: selectedCategoryIndex == 2
                        ? scheme.primary
                        : const Color(0xFFF2EBE1),
                    textColor: selectedCategoryIndex == 2
                        ? Colors.white
                        : scheme.onSurface,
                    onTap: () {
                      setState(() {
                        selectedCategoryIndex = 2;
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // SHOW OLD TESTAMENT SECTION IF 'All' (0) OR 'Old Testament' (1) IS SELECTED
            if (selectedCategoryIndex == 0 || selectedCategoryIndex == 1) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            'Old Testament',
                            style: GoogleFonts.nunitoSans(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: scheme.onSurface,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: scheme.primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '39 Books',
                            style: GoogleFonts.nunitoSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: scheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Hebrew Scriptures',
                    style: GoogleFonts.nunitoSans(
                      fontSize: 12,
                      color: scheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              ScripturesContainer(
                scriptureIndex: '1',
                scriptureVerse: 'Genesis',
                scriptureNumberOfChapters: '50 chapters • Law & Origins',
                onTap: () => openChapters('Genesis', 50),
              ),
              const SizedBox(height: 10),
              ScripturesContainer(
                scriptureIndex: '2',
                scriptureVerse: 'Exodus',
                scriptureNumberOfChapters:
                    '40 chapters • Deliverance & Covenant',
                onTap: () => openChapters('Exodus', 40),
              ),
              const SizedBox(height: 10),
              ScripturesContainer(
                scriptureIndex: '3',
                scriptureVerse: 'Leviticus',
                scriptureNumberOfChapters: '27 chapters • Holiness & Worship',
                onTap: () => openChapters('Leviticus', 27),
              ),
              const SizedBox(height: 10),
              ScripturesContainer(
                scriptureIndex: '4',
                scriptureVerse: 'Numbers',
                scriptureNumberOfChapters: '36 chapters • Wilderness Journey',
                onTap: () => openChapters('Numbers', 36),
              ),
              const SizedBox(height: 10),
              ScripturesContainer(
                scriptureIndex: '5',
                scriptureVerse: 'Deuteronomy',
                scriptureNumberOfChapters:
                    '34 chapters • Renewal of the Covenant',
                onTap: () => openChapters('Deuteronomy', 34),
              ),
              const SizedBox(height: 10),
              ScripturesContainer(
                scriptureIndex: '6',
                scriptureVerse: 'Joshua',
                scriptureNumberOfChapters: '24 chapters • Conquest of Canaan',
                onTap: () => openChapters('Joshua', 24),
              ),
              const SizedBox(height: 10),
              ScripturesContainer(
                scriptureIndex: '7',
                scriptureVerse: 'Judges',
                scriptureNumberOfChapters:
                    '21 chapters • Cycles of Faithlessness',
                onTap: () => openChapters('Judges', 21),
              ),
              const SizedBox(height: 10),
              ScripturesContainer(
                scriptureIndex: '8',
                scriptureVerse: 'Ruth',
                scriptureNumberOfChapters: '4 chapters • Devotion & Lineage',
                onTap: () => openChapters('Ruth', 4),
              ),
              const SizedBox(height: 10),
              ScripturesContainer(
                scriptureIndex: '9',
                scriptureVerse: '1 Samuel',
                scriptureNumberOfChapters: '31 chapters • Rise of the Monarchy',
                onTap: () => openChapters('1 Samuel', 31),
              ),
              const SizedBox(height: 10),
              ScripturesContainer(
                scriptureIndex: '10',
                scriptureVerse: '2 Samuel',
                scriptureNumberOfChapters: '24 chapters • King David\'s Reign',
                onTap: () => openChapters('2 Samuel', 24),
              ),
              const SizedBox(height: 10),
              ScripturesContainer(
                scriptureIndex: '11',
                scriptureVerse: '1 Kings',
                scriptureNumberOfChapters: '22 chapters • Kingdom Divided',
                onTap: () => openChapters('1 Kings', 22),
              ),
              const SizedBox(height: 10),
              ScripturesContainer(
                scriptureIndex: '12',
                scriptureVerse: '2 Kings',
                scriptureNumberOfChapters: '25 chapters • Captivity & Exile',
                onTap: () => openChapters('2 Kings', 25),
              ),
              const SizedBox(height: 10),
              ScripturesContainer(
                scriptureIndex: '13',
                scriptureVerse: '1 Chronicles',
                scriptureNumberOfChapters:
                    '29 chapters • Genealogies & Worship',
                onTap: () => openChapters('1 Chronicles', 29),
              ),
              const SizedBox(height: 10),
              ScripturesContainer(
                scriptureIndex: '14',
                scriptureVerse: '2 Chronicles',
                scriptureNumberOfChapters:
                    '36 chapters • Temple & Judah\'s Kings',
                onTap: () => openChapters('2 Chronicles', 36),
              ),
              const SizedBox(height: 10),
              ScripturesContainer(
                scriptureIndex: '15',
                scriptureVerse: 'Ezra',
                scriptureNumberOfChapters: '10 chapters • Return & Restoration',
                onTap: () => openChapters('Ezra', 10),
              ),
              const SizedBox(height: 10),
              ScripturesContainer(
                scriptureIndex: '16',
                scriptureVerse: 'Nehemiah',
                scriptureNumberOfChapters: '13 chapters • Rebuilding the Walls',
                onTap: () => openChapters('Nehemiah', 13),
              ),
              const SizedBox(height: 10),
              ScripturesContainer(
                scriptureIndex: '17',
                scriptureVerse: 'Esther',
                scriptureNumberOfChapters:
                    '10 chapters • Providence & Protection',
                onTap: () => openChapters('Esther', 10),
              ),
              const SizedBox(height: 10),
              ScripturesContainer(
                scriptureIndex: '18',
                scriptureVerse: 'Job',
                scriptureNumberOfChapters:
                    '42 chapters • Suffering & Sovereignty',
                onTap: () => openChapters('Job', 42),
              ),
              const SizedBox(height: 10),
              ScripturesContainer(
                scriptureIndex: '19',
                scriptureVerse: 'Psalms',
                scriptureNumberOfChapters: '150 chapters • Prayers & Hymns',
                badgeText: 'BELOVED',
                isHighlighted: true,
                onTap: () => openChapters('Psalms', 150),
              ),
              const SizedBox(height: 10),
              ScripturesContainer(
                scriptureIndex: '20',
                scriptureVerse: 'Proverbs',
                scriptureNumberOfChapters: '31 chapters • Wisdom for Living',
                onTap: () => openChapters('Proverbs', 31),
              ),
              const SizedBox(height: 10),
              ScripturesContainer(
                scriptureIndex: '21',
                scriptureVerse: 'Ecclesiastes',
                scriptureNumberOfChapters: '12 chapters • Meaning of Life',
                onTap: () => openChapters('Ecclesiastes', 12),
              ),
              const SizedBox(height: 10),
              ScripturesContainer(
                scriptureIndex: '22',
                scriptureVerse: 'Song of Solomon',
                scriptureNumberOfChapters: '8 chapters • Love & Devotion',
                onTap: () => openChapters('Song of Solomon', 8),
              ),
              const SizedBox(height: 10),
              ScripturesContainer(
                scriptureIndex: '23',
                scriptureVerse: 'Isaiah',
                scriptureNumberOfChapters:
                    '66 chapters • The Messianic Prophet',
                onTap: () => openChapters('Isaiah', 66),
              ),
              const SizedBox(height: 10),
              ScripturesContainer(
                scriptureIndex: '24',
                scriptureVerse: 'Jeremiah',
                scriptureNumberOfChapters: '52 chapters • The Weeping Prophet',
                onTap: () => openChapters('Jeremiah', 52),
              ),
              const SizedBox(height: 10),
              ScripturesContainer(
                scriptureIndex: '25',
                scriptureVerse: 'Lamentations',
                scriptureNumberOfChapters: '5 chapters • Grief & Hope',
                onTap: () => openChapters('Lamentations', 5),
              ),
              const SizedBox(height: 10),
              ScripturesContainer(
                scriptureIndex: '26',
                scriptureVerse: 'Ezekiel',
                scriptureNumberOfChapters: '48 chapters • Visions of Glory',
                onTap: () => openChapters('Ezekiel', 48),
              ),
              const SizedBox(height: 10),
              ScripturesContainer(
                scriptureIndex: '27',
                scriptureVerse: 'Daniel',
                scriptureNumberOfChapters: '12 chapters • Faith in Babylon',
                onTap: () => openChapters('Daniel', 12),
              ),
              const SizedBox(height: 10),
              ScripturesContainer(
                scriptureIndex: '28',
                scriptureVerse: 'Hosea',
                scriptureNumberOfChapters: '14 chapters • Unfailing Love',
                onTap: () => openChapters('Hosea', 14),
              ),
              const SizedBox(height: 10),
              ScripturesContainer(
                scriptureIndex: '29',
                scriptureVerse: 'Joel',
                scriptureNumberOfChapters: '3 chapters • Day of the Lord',
                onTap: () => openChapters('Joel', 3),
              ),
              const SizedBox(height: 10),
              ScripturesContainer(
                scriptureIndex: '30',
                scriptureVerse: 'Amos',
                scriptureNumberOfChapters: '9 chapters • Call for Justice',
                onTap: () => openChapters('Amos', 9),
              ),
              const SizedBox(height: 10),
              ScripturesContainer(
                scriptureIndex: '31',
                scriptureVerse: 'Obadiah',
                scriptureNumberOfChapters: '1 chapter • Judgment on Edom',
                onTap: () => openChapters('Obadiah', 1),
              ),
              const SizedBox(height: 10),
              ScripturesContainer(
                scriptureIndex: '32',
                scriptureVerse: 'Jonah',
                scriptureNumberOfChapters: '4 chapters • Mercy to Gentiles',
                onTap: () => openChapters('Jonah', 4),
              ),
              const SizedBox(height: 10),
              ScripturesContainer(
                scriptureIndex: '33',
                scriptureVerse: 'Micah',
                scriptureNumberOfChapters: '7 chapters • Justice & Mercy',
                onTap: () => openChapters('Micah', 7),
              ),
              const SizedBox(height: 10),
              ScripturesContainer(
                scriptureIndex: '34',
                scriptureVerse: 'Nahum',
                scriptureNumberOfChapters: '3 chapters • Fall of Nineveh',
                onTap: () => openChapters('Nahum', 3),
              ),
              const SizedBox(height: 10),
              ScripturesContainer(
                scriptureIndex: '35',
                scriptureVerse: 'Habakkuk',
                scriptureNumberOfChapters: '3 chapters • Trusting God',
                onTap: () => openChapters('Habakkuk', 3),
              ),
              const SizedBox(height: 10),
              ScripturesContainer(
                scriptureIndex: '36',
                scriptureVerse: 'Zephaniah',
                scriptureNumberOfChapters: '3 chapters • Day of Wrath',
                onTap: () => openChapters('Zephaniah', 3),
              ),
              const SizedBox(height: 10),
              ScripturesContainer(
                scriptureIndex: '37',
                scriptureVerse: 'Haggai',
                scriptureNumberOfChapters: '2 chapters • Rebuild the Temple',
                onTap: () => openChapters('Haggai', 2),
              ),
              const SizedBox(height: 10),
              ScripturesContainer(
                scriptureIndex: '38',
                scriptureVerse: 'Zechariah',
                scriptureNumberOfChapters:
                    '14 chapters • Visions of Restoration',
                onTap: () => openChapters('Zechariah', 14),
              ),
              const SizedBox(height: 10),
              ScripturesContainer(
                scriptureIndex: '39',
                scriptureVerse: 'Malachi',
                scriptureNumberOfChapters: '4 chapters • The Final Exhortation',
                onTap: () => openChapters('Malachi', 4),
              ),
              const SizedBox(height: 30),
            ],

            // SHOW NEW TESTAMENT SECTION IF 'All' (0) OR 'New Testament' (2) IS SELECTED
            if (selectedCategoryIndex == 0 || selectedCategoryIndex == 2) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            'New Testament',
                            style: GoogleFonts.nunitoSans(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: scheme.onSurface,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: scheme.secondary.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '27 Books',
                            style: GoogleFonts.nunitoSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: scheme.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Covenant & Grace',
                    style: GoogleFonts.nunitoSans(
                      fontSize: 12,
                      color: scheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              ScripturesContainer(
                scriptureIndex: '40',
                scriptureVerse: 'Matthew',
                scriptureNumberOfChapters: '28 chapters • The Promised King',
                onTap: () => openChapters('Matthew', 28, isNT: true),
              ),
              const SizedBox(height: 10),
              ScripturesContainer(
                scriptureIndex: '41',
                scriptureVerse: 'Mark',
                scriptureNumberOfChapters:
                    '16 chapters • The Suffering Servant',
                onTap: () => openChapters('Mark', 16, isNT: true),
              ),
              const SizedBox(height: 10),
              ScripturesContainer(
                scriptureIndex: '42',
                scriptureVerse: 'Luke',
                scriptureNumberOfChapters:
                    '24 chapters • Savior of All Peoples',
                onTap: () => openChapters('Luke', 24, isNT: true),
              ),
              const SizedBox(height: 10),
              ScripturesContainer(
                scriptureIndex: '43',
                scriptureVerse: 'John',
                scriptureNumberOfChapters: '21 chapters • The Son of God',
                badgeText: 'LIVING WORD',
                isHighlighted: true,
                onTap: () => openChapters('John', 21, isNT: true),
              ),
              const SizedBox(height: 10),
              ScripturesContainer(
                scriptureIndex: '44',
                scriptureVerse: 'Acts',
                scriptureNumberOfChapters:
                    '28 chapters • The Early Church & Spirit',
                onTap: () => openChapters('Acts', 28, isNT: true),
              ),
              const SizedBox(height: 10),
              ScripturesContainer(
                scriptureIndex: '45',
                scriptureVerse: 'Romans',
                scriptureNumberOfChapters:
                    '16 chapters • The Righteousness of God',
                onTap: () => openChapters('Romans', 16, isNT: true),
              ),
              const SizedBox(height: 10),
              ScripturesContainer(
                scriptureIndex: '46',
                scriptureVerse: '1 Corinthians',
                scriptureNumberOfChapters: '16 chapters • Church Unity & Love',
                onTap: () => openChapters('1 Corinthians', 16, isNT: true),
              ),
              const SizedBox(height: 10),
              ScripturesContainer(
                scriptureIndex: '47',
                scriptureVerse: '2 Corinthians',
                scriptureNumberOfChapters: '13 chapters • Apostle\'s Defense',
                onTap: () => openChapters('2 Corinthians', 13, isNT: true),
              ),
              const SizedBox(height: 10),
              ScripturesContainer(
                scriptureIndex: '48',
                scriptureVerse: 'Galatians',
                scriptureNumberOfChapters: '6 chapters • Freedom in Christ',
                onTap: () => openChapters('Galatians', 6, isNT: true),
              ),
              const SizedBox(height: 10),
              ScripturesContainer(
                scriptureIndex: '49',
                scriptureVerse: 'Ephesians',
                scriptureNumberOfChapters:
                    '6 chapters • Church as Christ\'s Body',
                onTap: () => openChapters('Ephesians', 6, isNT: true),
              ),
              const SizedBox(height: 10),
              ScripturesContainer(
                scriptureIndex: '50',
                scriptureVerse: 'Philippians',
                scriptureNumberOfChapters: '4 chapters • Joy in All Things',
                onTap: () => openChapters('Philippians', 4, isNT: true),
              ),
              const SizedBox(height: 10),
              ScripturesContainer(
                scriptureIndex: '51',
                scriptureVerse: 'Colossians',
                scriptureNumberOfChapters: '4 chapters • Christ Preeminent',
                onTap: () => openChapters('Colossians', 4, isNT: true),
              ),
              const SizedBox(height: 10),
              ScripturesContainer(
                scriptureIndex: '52',
                scriptureVerse: '1 Thessalonians',
                scriptureNumberOfChapters: '5 chapters • Christ\'s Return',
                onTap: () => openChapters('1 Thessalonians', 5, isNT: true),
              ),
              const SizedBox(height: 10),
              ScripturesContainer(
                scriptureIndex: '53',
                scriptureVerse: '2 Thessalonians',
                scriptureNumberOfChapters: '3 chapters • Stand Firm in Faith',
                onTap: () => openChapters('2 Thessalonians', 3, isNT: true),
              ),
              const SizedBox(height: 10),
              ScripturesContainer(
                scriptureIndex: '54',
                scriptureVerse: '1 Timothy',
                scriptureNumberOfChapters: '6 chapters • Leadership & Doctrine',
                onTap: () => openChapters('1 Timothy', 6, isNT: true),
              ),
              const SizedBox(height: 10),
              ScripturesContainer(
                scriptureIndex: '55',
                scriptureVerse: '2 Timothy',
                scriptureNumberOfChapters: '4 chapters • Faithful to the End',
                onTap: () => openChapters('2 Timothy', 4, isNT: true),
              ),
              const SizedBox(height: 10),
              ScripturesContainer(
                scriptureIndex: '56',
                scriptureVerse: 'Titus',
                scriptureNumberOfChapters: '3 chapters • Good Works & Order',
                onTap: () => openChapters('Titus', 3, isNT: true),
              ),
              const SizedBox(height: 10),
              ScripturesContainer(
                scriptureIndex: '57',
                scriptureVerse: 'Philemon',
                scriptureNumberOfChapters: '1 chapter • Reconciliation & Grace',
                onTap: () => openChapters('Philemon', 1, isNT: true),
              ),
              const SizedBox(height: 10),
              ScripturesContainer(
                scriptureIndex: '58',
                scriptureVerse: 'Hebrews',
                scriptureNumberOfChapters:
                    '13 chapters • Superiority of Christ',
                onTap: () => openChapters('Hebrews', 13, isNT: true),
              ),
              const SizedBox(height: 10),
              ScripturesContainer(
                scriptureIndex: '59',
                scriptureVerse: 'James',
                scriptureNumberOfChapters: '5 chapters • Faith in Action',
                onTap: () => openChapters('James', 5, isNT: true),
              ),
              const SizedBox(height: 10),
              ScripturesContainer(
                scriptureIndex: '60',
                scriptureVerse: '1 Peter',
                scriptureNumberOfChapters: '5 chapters • Hope in Suffering',
                onTap: () => openChapters('1 Peter', 5, isNT: true),
              ),
              const SizedBox(height: 10),
              ScripturesContainer(
                scriptureIndex: '61',
                scriptureVerse: '2 Peter',
                scriptureNumberOfChapters: '3 chapters • Growing in Grace',
                onTap: () => openChapters('2 Peter', 3, isNT: true),
              ),
              const SizedBox(height: 10),
              ScripturesContainer(
                scriptureIndex: '62',
                scriptureVerse: '1 John',
                scriptureNumberOfChapters:
                    '5 chapters • Walking in Light & Love',
                onTap: () => openChapters('1 John', 5, isNT: true),
              ),
              const SizedBox(height: 10),
              ScripturesContainer(
                scriptureIndex: '63',
                scriptureVerse: '2 John',
                scriptureNumberOfChapters: '1 chapter • Abiding in Truth',
                onTap: () => openChapters('2 John', 1, isNT: true),
              ),
              const SizedBox(height: 10),
              ScripturesContainer(
                scriptureIndex: '64',
                scriptureVerse: '3 John',
                scriptureNumberOfChapters: '1 chapter • Hospitality & Truth',
                onTap: () => openChapters('3 John', 1, isNT: true),
              ),
              const SizedBox(height: 10),
              ScripturesContainer(
                scriptureIndex: '65',
                scriptureVerse: 'Jude',
                scriptureNumberOfChapters: '1 chapter • Contend for the Faith',
                onTap: () => openChapters('Jude', 1, isNT: true),
              ),
              const SizedBox(height: 10),
              ScripturesContainer(
                scriptureIndex: '66',
                scriptureVerse: 'Revelation',
                scriptureNumberOfChapters:
                    '22 chapters • Consummation & New Creation',
                onTap: () => openChapters('Revelation', 22, isNT: true),
              ),
            ],

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
