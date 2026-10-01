import 'package:flutter/material.dart';
import 'package:salvation_bible_app/view/main_navigation/chapter_selector.dart';
import 'package:salvation_bible_app/view/main_navigation/note_book.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int currentIndex = 0;
  final List<Widget> pages = [ChapterSelector(), NoteBook()];
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: pages[currentIndex], // display the current selected page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        backgroundColor: scheme.surface,
        selectedItemColor: scheme.primary,
        unselectedItemColor: scheme.onSurface.withValues(alpha: 0.5),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Bible'),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border),
            label: 'Notes',
          ),
        ],
      ),
    );
  }
}
