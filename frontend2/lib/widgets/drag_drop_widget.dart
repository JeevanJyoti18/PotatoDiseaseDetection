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
              ? Theme.of(context).primaryColor.withOpacity(0.1)
              : Colors.grey.shade50,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                _isDragOver ? Icons.cloud_download : Icons.cloud_upload,
                size: 80,
                color: _isDragOver 
                  ? Theme.of(context).primaryColor 
                  : Colors.grey.shade400,
              ),
              SizedBox(height: 20),
              Text(
                'Drag and drop an image of a potato plant leaf to process',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: _isDragOver 
                    ? Theme.of(context).primaryColor 
                    : Colors.grey.shade600,
                  fontWeight: _isDragOver ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: Icon(Icons.photo_library),
                label: Text('Select Image'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
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
    // This would typically use image_picker, but for drag-drop demo
    // we'll simulate file selection
    // In a real implementation, you'd use:
    // final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    // if (image != null) {
    //   widget.onFileSelected(File(image.path));
    // }
    
    // For now, we'll show a dialog to simulate file selection
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Image'),
        content: const Text('This would open the file picker in a real implementation.'),
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