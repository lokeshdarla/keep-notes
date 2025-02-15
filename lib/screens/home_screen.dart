import 'package:flutter/material.dart';
import 'package:notes_app/models/note_database.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/screens/note_screen.dart';
import 'package:notes_app/widgets/note_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Note> notes = [];
  String searchQuery = "";
  String sortType = "Last Modified";
  bool isSearchActive = false;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  Future<void> loadNotes() async {
    List<Note> fetchedNotes;

    switch (sortType) {
      case "Title":
        fetchedNotes = await NoteDatabase.getNotesSortedByName();
        break;
      case "Created Date":
        fetchedNotes = await NoteDatabase.getNotesSortedByCreatedDate();
        break;
      case "Last Modified":
      default:
        fetchedNotes = await NoteDatabase.getNotesSortedByLastModified();
    }

    if (searchQuery.isNotEmpty) {
      fetchedNotes =
          fetchedNotes
              .where(
                (note) =>
                    note.title.toLowerCase().contains(
                      searchQuery.toLowerCase(),
                    ) ||
                    note.text.toLowerCase().contains(searchQuery.toLowerCase()),
              )
              .toList();
    }

    setState(() => notes = fetchedNotes);
  }

  Future<void> deleteNote(int id) async {
    await NoteDatabase.deleteNote(id);
    loadNotes();
  }

  void clearFilters() {
    setState(() {
      searchQuery = "";
      sortType = "Last Modified";
      isSearchActive = false;
      searchController.clear();
    });
    loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Light background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        title:
            isSearchActive
                ? TextField(
                  controller: searchController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: "Search notes...",
                    border: InputBorder.none,
                  ),
                  onChanged: (query) {
                    setState(() => searchQuery = query);
                    loadNotes();
                  },
                )
                : const Text(
                  'Notes',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: Icon(
              isSearchActive ? Icons.close : Icons.search,
              color: Colors.black,
            ),
            onPressed: () {
              setState(() {
                isSearchActive = !isSearchActive;
                if (!isSearchActive) {
                  searchQuery = "";
                  searchController.clear();
                  loadNotes();
                }
              });
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort, color: Colors.black),
            onSelected: (value) {
              if (value == "Remove Filters") {
                clearFilters();
              } else {
                setState(() => sortType = value);
                loadNotes();
              }
            },
            itemBuilder:
                (context) => [
                  const PopupMenuItem(
                    value: "Last Modified",
                    child: Text("Last Modified"),
                  ),
                  const PopupMenuItem(value: "Title", child: Text("Title")),
                  const PopupMenuItem(
                    value: "Created Date",
                    child: Text("Created Date"),
                  ),
                  const PopupMenuDivider(),
                  const PopupMenuItem(
                    value: "Remove Filters",
                    child: Text(
                      "Remove Filters",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
          ),
        ],
      ),
      body:
          notes.isEmpty
              ? const Center(
                child: Text(
                  'No Notes Yet!',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              )
              : Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                child: ListView.builder(
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final note = notes[index];
                    return Card(
                      color: Colors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: NoteTile(note: note, onDelete: deleteNote),
                    );
                  },
                ),
              ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NoteScreen()),
            ).then((_) => loadNotes()),
        shape: const CircleBorder(),
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, size: 30),
      ),
    );
  }
}
