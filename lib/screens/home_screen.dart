import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../services/storage_service.dart';
import '../widgets/flashcard_tile.dart';
import '../ads/ad_helper.dart';
import 'create_flashcard_screen.dart';
import 'settings_screen.dart';
import 'flashcard_detail_screen.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late StorageService _storageService;

  @override
  void initState() {
    super.initState();
    _storageService = Provider.of<StorageService>(context, listen: false);
    _storageService.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'YaadCards',
          style: GoogleFonts.instrumentSans(
            // fontSize: 24
            fontWeight: FontWeight.w700
          )
        ),
        actions: [
          IconButton(
            icon: const Icon(LineAwesomeIcons.cogs_solid),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<StorageService>(
              builder: (context, storageService, child) {
                if (storageService.flashcards.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.note_add,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No flashcards yet!',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Tap the + button to create your first flashcard',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return LayoutBuilder(
                  builder: (context, constraints) {
                    final crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
                    return GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: 0.8,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: storageService.flashcards.length,
                      itemBuilder: (context, index) {
                        final flashcard = storageService.flashcards[index];
                        return FlashcardTile(
                          flashcard: flashcard,
                          onTap: () => _handleFlashcardTap(flashcard),
                          onLongPress: () => _showFlashcardOptions(context, flashcard, index),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
          const BannerAdWidget(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateFlashcardScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _handleFlashcardTap(flashcard) {
    if (flashcard.link != null && flashcard.link!.isNotEmpty) {
      AdHelper.showInterstitialAd(() {
        AdHelper.launchURL(flashcard.link!);
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FlashcardDetailScreen(flashcard: flashcard),
        ),
      );
    }
  }

  void _showFlashcardOptions(BuildContext context, flashcard, int index) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateFlashcardScreen(
                        flashcard: flashcard,
                        index: index,
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Delete', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _confirmDelete(context, index);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Flashcard'),
          content: const Text('Are you sure you want to delete this flashcard?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _storageService.deleteFlashcard(index);
                Navigator.pop(context);
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
