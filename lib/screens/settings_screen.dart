import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/storage_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Consumer<StorageService>(
              builder: (context, storageService, child) {
                return ListTile(
                  leading: const Icon(Icons.delete_forever, color: Colors.red),
                  title: const Text('Reset All Flashcards'),
                  subtitle: Text('${storageService.flashcardCount} flashcards will be deleted'),
                  onTap: () => _showResetDialog(context, storageService),
                );
              },
            ),
            const Divider(),
            const Spacer(),
            const Text(
              'YaadCards v1.0.0',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showResetDialog(BuildContext context, StorageService storageService) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reset All Flashcards'),
          content: const Text(
            'Are you sure you want to delete all flashcards? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                storageService.clearAllFlashcards();
                Navigator.pop(context);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('All flashcards deleted')),
                );
              },
              child: const Text('Delete All', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}