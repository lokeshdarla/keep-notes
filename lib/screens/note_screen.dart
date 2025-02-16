import 'package:flutter/material.dart';
import 'package:notes_app/models/note_database.dart';
import 'package:notes_app/models/note.dart';

class NoteScreen extends StatefulWidget {
  final Note? note;

  const NoteScreen({super.key, this.note});

  @override
  _NoteScreenState createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      titleController.text = widget.note!.title;
      textController.text = widget.note!.text;
    }
  }

  /// Saves a new note or updates an existing one
  Future<void> saveNote() async {
    if (titleController.text.isEmpty || textController.text.isEmpty) return;

    if (widget.note == null) {
      await NoteDatabase.addNote(titleController.text, textController.text);
    } else {
      await NoteDatabase.updateNote(
        widget.note!.key, // ✅ Passes the correct key instead of typecasting
        titleController.text,
        textController.text,
      );
    }

    Navigator.pop(context, true); // ✅ Returns success flag
  }

  /// Custom input field for title & content
  Widget buildTextField({
    required String label,
    required TextEditingController controller,
    bool isMultiline = false,
  }) {
    return TextField(
      controller: controller,
      maxLines: isMultiline ? null : 1,
      expands: isMultiline,
      keyboardType: isMultiline ? TextInputType.multiline : TextInputType.text,
      textAlignVertical: TextAlignVertical.top,
      style: const TextStyle(fontSize: 16, color: Colors.black),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[700]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(12), // ✅ Added better padding
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          widget.note == null ? 'New Note' : 'Edit Note',
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildTextField(label: 'Title', controller: titleController),
            const SizedBox(height: 12),
            Expanded(
              child: buildTextField(
                label: 'Content',
                controller: textController,
                isMultiline: true,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveNote,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Save Note',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
