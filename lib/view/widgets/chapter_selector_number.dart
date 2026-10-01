import 'package:flutter/material.dart';

class ChapterSelectorNumber extends StatelessWidget {
  final String bookName;
  final int totalChapters;
  final String testamentInfo;

  const ChapterSelectorNumber({
    super.key,
    required this.bookName,
    required this.totalChapters,
    this.testamentInfo = 'Old Testament • 39 Books',
  });

  // Helper method to open this bottom sheet easily from anywhere:
  static void show(
    BuildContext context, {
    required String bookName,
    required int totalChapters,
    String testamentInfo = 'Old Testament • 39 Books',
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => ChapterSelectorNumber(
        bookName: bookName,
        totalChapters: totalChapters,
        testamentInfo: testamentInfo,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: "Select Scripture" & Close Button (X)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bookName.isNotEmpty ? bookName : 'Select Scripture',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    testamentInfo,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // CHAPTER Grid (6 columns)
          Text(
            'CHAPTER ($totalChapters)',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            itemCount: totalChapters,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              final chapterNumber = index + 1;

              return InkWell(
                onTap: () {
                  Navigator.pop(context); // Close modal
                },
                child: CircleAvatar(
                  backgroundColor: const Color(0xFFF2EBE1),
                  child: Text(
                    '$chapterNumber',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
