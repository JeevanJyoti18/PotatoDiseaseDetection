import 'dart:typed_data';
import 'dart:io' as io; // For mobile
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

class PotatoDiseaseDetector extends StatefulWidget {
  @override
  _PotatoDiseaseDetectorState createState() => _PotatoDiseaseDetectorState();
}

class _PotatoDiseaseDetectorState extends State<PotatoDiseaseDetector> {
  Uint8List? webImage;        // For web
  io.File? pickedFile;        // For mobile
  String resultText = "";     // API result text
  bool isLoading = false;     // Loading indicator

  Future<void> pickAndClassifyImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true, // Needed for web
    );

    if (result != null && result.files.single.bytes != null) {
      setState(() {
        if (kIsWeb) {
          webImage = result.files.single.bytes;
        } else {
          pickedFile = io.File(result.files.single.path!);
        }
        resultText = ""; // Clear previous result
      });

      // Call your backend API for classification
      await classifyImage(result.files.single);
    } else {
      print("No file selected");
    }
  }

  Future<void> classifyImage(PlatformFile selectedFile) async {
    setState(() {
      isLoading = true;
    });

    try {
      var uri = Uri.parse("http://localhost:8000/predict"); // Updated endpoint

      http.Response response;

      if (kIsWeb) {
        // Web: Send as multipart
        var request = http.MultipartRequest('POST', uri);
        request.files.add(http.MultipartFile.fromBytes(
          'file', webImage!, filename: selectedFile.name,
        ));
        var streamedResponse = await request.send();
        response = await http.Response.fromStream(streamedResponse);
      } else {
        // Mobile: Send as multipart file
        var request = http.MultipartRequest('POST', uri);
        request.files.add(await http.MultipartFile.fromPath(
          'file', pickedFile!.path,
        ));
        var streamedResponse = await request.send();
        response = await http.Response.fromStream(streamedResponse);
      }

      if (response.statusCode == 200) {
        setState(() {
          resultText = response.body; // Show backend response
        });
      } else {
        setState(() {
          resultText = "Error: "+response.body;
        });
      }
    } catch (e) {
      setState(() {
        resultText = "Error: $e";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Potato Disease Detector')),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (kIsWeb && webImage != null)
                Image.memory(
                  webImage!,
                  height: 300,
                  width: 300,
                  fit: BoxFit.cover,
                )
              else if (!kIsWeb && pickedFile != null)
                Image.file(
                  pickedFile!,
                  height: 300,
                  width: 300,
                  fit: BoxFit.cover,
                )
              else
                const Text("No image selected"),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: pickAndClassifyImage,
                child: const Text("Upload & Classify Image"),
              ),
              const SizedBox(height: 20),
              if (isLoading)
                const CircularProgressIndicator()
              else if (resultText.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "Result: $resultText",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
} 