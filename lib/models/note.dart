import 'package:isar/isar.dart';

part 'note.g.dart'; // Ensure this file is generated

@collection
class Note {
  Id id = Isar.autoIncrement; // Auto-increment ID

  late String title;
  late String text;

  @Index()
  late DateTime createdAt; // Creation timestamp

  @Index()
  late DateTime lastModified; // Last modified timestamp
}
