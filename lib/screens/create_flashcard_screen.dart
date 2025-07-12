import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/flashcard.dart';
import '../services/storage_service.dart';
import '../widgets/color_picker_grid.dart';

class CreateFlashcardScreen extends StatefulWidget {
  final Flashcard? flashcard;
  final int? index;

  const CreateFlashcardScreen({super.key, this.flashcard, this.index});

  @override
  State<CreateFlashcardScreen> createState() => _CreateFlashcardScreenState();
}

class _CreateFlashcardScreenState extends State<CreateFlashcardScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _linkController = TextEditingController();

  String? _imagePath;
  Color _selectedColor = Flashcard.predefinedColors[0];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.flashcard != null) {
      _titleController.text = widget.flashcard!.title;
      _descriptionController.text = widget.flashcard!.description;
      _linkController.text = widget.flashcard!.link ?? '';
      _imagePath = widget.flashcard!.imagePath;
      _selectedColor = widget.flashcard!.color;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _linkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.flashcard != null ? 'Edit Flashcard' : 'Create Flashcard'),
        actions: [
          TextButton(
            onPressed: _saveFlashcard,
            child: const Text('Save'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _linkController,
                decoration: const InputDecoration(
                  labelText: 'Link (Optional)',
                  border: OutlineInputBorder(),
                  hintText: 'https://example.com',
                ),
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final urlPattern = RegExp(r'^https?://');
                    if (!urlPattern.hasMatch(value)) {
                      return 'Please enter a valid URL (starting with http:// or https://)';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  const Text(
                    'Image: ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  TextButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.image),
                    label: const Text('Pick Image'),
                  ),
                  if (_imagePath != null) ...[
                    const SizedBox(width: 8),
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _imagePath = null;
                        });
                      },
                      icon: const Icon(Icons.close, color: Colors.red),
                      label: const Text('Remove', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ],
              ),
              if (_imagePath != null) ...[
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    File(_imagePath!),
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
              const SizedBox(height: 24),
              const Text(
                'Color:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              ColorPickerGrid(
                selectedColor: _selectedColor,
                onColorSelected: (color) {
                  setState(() {
                    _selectedColor = color;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imagePath = image.path;
      });
    }
  }

  void _saveFlashcard() {
    if (_formKey.currentState!.validate()) {
      final flashcard = Flashcard(
        title: _titleController.text,
        description: _descriptionController.text,
        imagePath: _imagePath,
        link: _linkController.text.isEmpty ? null : _linkController.text,
        colorValue: _selectedColor.value,
        createdAt: widget.flashcard?.createdAt ?? DateTime.now(),
      );

      final storageService = Provider.of<StorageService>(context, listen: false);

      if (widget.flashcard != null && widget.index != null) {
        storageService.updateFlashcard(widget.index!, flashcard);
      } else {
        storageService.addFlashcard(flashcard);
      }

      Navigator.pop(context);
    }
  }
}