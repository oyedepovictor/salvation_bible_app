import '../models/bible.dart';
import '../services/bible_networking.dart';

class BibleController {
  Future<dynamic> getBibleData(String bibleScripture) async {
    String formattedScripture = Uri.encodeComponent(bibleScripture);
    var url = 'https://bible-api.com/$formattedScripture?translation=kjv';
    NetworkHelper networkHelper = NetworkHelper(url);
    var bibleData = await networkHelper.getData();
    return Bible.fromJson(bibleData);
  }
}
