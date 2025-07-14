import 'package:flutter/material.dart';
import 'dart:io';

class DragDropWidget extends StatefulWidget {
  final Function(File) onFileSelected;
  final String dropText;

  const DragDropWidget({
    super.key,
    required this.onFileSelected,
    this.dropText = 'Drag and drop an image of a potato plant leaf to process',
  });

  @override
  State<DragDropWidget> createState() => _DragDropWidgetState();
}

class _DragDropWidgetState extends State<DragDropWidget> {
  bool _isDragOver = false;

  @override
  Widget build(BuildContext context) {
    return DragTarget<File>(
      onWillAcceptWithDetails: (data) {
        setState(() {
          _isDragOver = true;
        });
        return true;
      },
      onAcceptWithDetails: (details) {
        setState(() {
          _isDragOver = false;
        });
        widget.onFileSelected(details.data);
      },
      onLeave: (data) {
        setState(() {
          _isDragOver = false;
        });
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          height: 300,
          decoration: BoxDecoration(
            border: Border.all(
              color: _isDragOver
                  ? Theme.of(context).primaryColor
                  : Colors.grey.shade300,
              width: _isDragOver ? 3 : 2,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(15),
            color: _isDragOver
                ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
                : Colors.grey.shade50,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _isDragOver ? Icons.cloud_download : Icons.cloud_upload,
                size: 80,
                color: _isDragOver
                    ? Theme.of(context).primaryColor
                    : Colors.grey.shade400,
              ),
              const SizedBox(height: 20),
              Text(
                widget.dropText, // ✅ use passed-in dropText for flexibility
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: _isDragOver
                      ? Theme.of(context).primaryColor
                      : Colors.grey.shade600,
                  fontWeight:
                      _isDragOver ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.photo_library),
                label: const Text('Select Image'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage() async {
    // ✅ NOTE: This method is still a placeholder for file picker logic
    // Implement image picking here if needed later

    // Simulated dialog for demo
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Image'),
        content: const Text(
          'This would open the file picker in a real implementation.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
