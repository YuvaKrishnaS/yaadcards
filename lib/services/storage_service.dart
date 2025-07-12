import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/flashcard.dart';

class StorageService extends ChangeNotifier {
  static const String _boxName = 'flashcards';
  Box<Flashcard>? _box;

  List<Flashcard> _flashcards = [];
  List<Flashcard> get flashcards => _flashcards;

  Future<void> init() async {
    _box = await Hive.openBox<Flashcard>(_boxName);
    _loadFlashcards();
  }

  void _loadFlashcards() {
    if (_box != null) {
      _flashcards = _box!.values.toList();
      _flashcards.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      notifyListeners();
    }
  }

  Future<void> addFlashcard(Flashcard flashcard) async {
    await _box?.add(flashcard);
    _loadFlashcards();
  }

  Future<void> updateFlashcard(int index, Flashcard flashcard) async {
    await _box?.putAt(index, flashcard);
    _loadFlashcards();
  }

  Future<void> deleteFlashcard(int index) async {
    await _box?.deleteAt(index);
    _loadFlashcards();
  }

  Future<void> clearAllFlashcards() async {
    await _box?.clear();
    _loadFlashcards();
  }

  int get flashcardCount => _flashcards.length;
}