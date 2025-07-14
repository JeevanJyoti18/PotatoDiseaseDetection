import 'dart:io' as io; // For mobile
import 'dart:typed_data'; // For Uint8List
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PotatoDiseaseDetector extends StatefulWidget {
  final String apiUrl; // ✅ Accept API URL from main.dart

  const PotatoDiseaseDetector({
    super.key,
    required this.apiUrl, // ✅ Required parameter
  });

  @override
  PotatoDiseaseDetectorState createState() => PotatoDiseaseDetectorState();
}

class PotatoDiseaseDetectorState extends State<PotatoDiseaseDetector> {
  Uint8List? webImage;        // For web
  io.File? pickedFile;        // For mobile
  String resultText = "";     // API result text
  bool isLoading = false;     // Loading indicator
  String? predictedClass;
  double? confidence;

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
      debugPrint("No file selected"); // ✅ Use debugPrint
    }
  }

  Future<void> classifyImage(PlatformFile selectedFile) async {
    setState(() {
      isLoading = true;
    });

    try {
      var uri = Uri.parse("${widget.apiUrl}/predict"); // ✅ Use dynamic API URL
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
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          predictedClass = data['class'];
          confidence = (data['confidence'] as num?)?.toDouble();
          resultText = ""; // Clear old text
        });
      } else {
        setState(() {
          predictedClass = null;
          confidence = null;
          resultText = "Error: ${response.body}";
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
        decoration: const BoxDecoration(
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
              else if (predictedClass != null && confidence != null)
                Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.pink[50]!.withOpacity(0.85), // ✅ Fix deprecated withValues
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.pink.withOpacity(0.3), // ✅ Fix deprecated withValues
                      width: 1.5,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Class:",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.pink,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Text(
                        predictedClass!,
                        style: const TextStyle(
                          fontSize: 28,
                          color: Colors.pink,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "Confidence:",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "${(confidence! * 100).toStringAsFixed(3)}%",
                        style: const TextStyle(
                          fontSize: 24,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )
              else if (resultText.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.red[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    resultText,
                    style: const TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold),
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
