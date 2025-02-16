import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'note.dart';

class NoteDatabase {
  static late Box<Note> _noteBox;

  /// Initializes Hive and opens the box
  static Future<void> initialize() async {
    if (!Hive.isAdapterRegistered(0)) {
      // Ensure adapter is registered
      Hive.registerAdapter(NoteAdapter());
    }
    _noteBox = await Hive.openBox<Note>('notes');
  }

  /// Adds a new note
  static Future<int> addNote(String title, String text) async {
    final note =
        Note()
          ..title = title
          ..text = text
          ..createdAt = DateTime.now()
          ..lastModified = DateTime.now();

    return await _noteBox.add(note);
  }

  /// Gets all notes sorted by last modified (default)
  static List<Note> getNotes() {
    return _noteBox.values.toList()
      ..sort((a, b) => b.lastModified.compareTo(a.lastModified));
  }

  /// Sort notes by name (A-Z)
  static List<Note> getNotesSortedByName() {
    return _noteBox.values.toList()..sort((a, b) => a.title.compareTo(b.title));
  }

  /// Sort notes by last modified (Newest first)
  static List<Note> getNotesSortedByLastModified() {
    return _noteBox.values.toList()
      ..sort((a, b) => b.lastModified.compareTo(a.lastModified));
  }

  /// Sort notes by created date (Oldest first)
  static List<Note> getNotesSortedByCreatedDate() {
    return _noteBox.values.toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }

  /// Updates an existing note
  static Future<void> updateNote(
    int key,
    String newTitle,
    String newText,
  ) async {
    final note = _noteBox.get(key);
    if (note != null) {
      note.title = newTitle;
      note.text = newText;
      note.lastModified = DateTime.now();
      await _noteBox.put(key, note); // Save update using key
    }
  }

  /// Deletes a note
  static Future<void> deleteNote(int key) async {
    await _noteBox.delete(key);
  }

  /// Searches for notes containing a keyword (case-insensitive)
  static List<Note> searchNotes(String query) {
    return _noteBox.values
        .where(
          (note) =>
              note.title.toLowerCase().contains(query.toLowerCase()) ||
              note.text.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }
}
