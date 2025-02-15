import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'note.dart';

class NoteDatabase {
  static late Isar isar;

  static Future<void> initialise() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([NoteSchema], directory: dir.path);
  }

  // Add a new note
  static Future<void> addNote(String title, String text) async {
    final note =
        Note()
          ..title = title
          ..text = text
          ..createdAt = DateTime.now()
          ..lastModified = DateTime.now();

    await isar.writeTxn(() async => await isar.notes.put(note));
  }

  // Get all notes sorted by last modified (default)
  static Future<List<Note>> getNotes() async {
    return await isar.notes.where().sortByLastModifiedDesc().findAll();
  }

  // Sort notes by name (A-Z)
  static Future<List<Note>> getNotesSortedByName() async {
    return await isar.notes.where().sortByTitle().findAll();
  }

  // Sort notes by last modified (Newest first)
  static Future<List<Note>> getNotesSortedByLastModified() async {
    return await isar.notes.where().sortByLastModifiedDesc().findAll();
  }

  // Sort notes by created date (Oldest first)
  static Future<List<Note>> getNotesSortedByCreatedDate() async {
    return await isar.notes.where().sortByCreatedAt().findAll();
  }

  // Update a note
  static Future<void> updateNote(
    Note note,
    String newTitle,
    String newText,
  ) async {
    note.title = newTitle;
    note.text = newText;
    note.lastModified = DateTime.now();

    await isar.writeTxn(() async => await isar.notes.put(note));
  }

  // Delete a note
  static Future<void> deleteNote(int id) async {
    await isar.writeTxn(() async => await isar.notes.delete(id));
  }

  // Search for notes containing a keyword (case-insensitive)
  static Future<List<Note>> searchNotes(String query) async {
    return await isar.notes
        .filter()
        .titleContains(query, caseSensitive: false)
        .or()
        .textContains(query, caseSensitive: false)
        .findAll();
  }
}
