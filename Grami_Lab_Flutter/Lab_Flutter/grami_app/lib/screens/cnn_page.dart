import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:http/http.dart' as http;

class CnnPage extends StatefulWidget {
  const CnnPage({super.key});

  @override
  _CnnPageState createState() => _CnnPageState();
}

class _CnnPageState extends State<CnnPage> {
  File? _imageFile;
  String _prediction = "No prediction yet.";
  String _modelStatus = "Loading model...";
  final List<String> _classNames = [
    'apple',
    'banana',
    'beetroot',
    'bell pepper',
    'cabbage',
    'capsicum',
    'carrot',
    'cauliflower',
    'chilli pepper',
    'corn',
    'cucumber',
    'eggplant',
    'garlic',
    'ginger',
    'grapes',
    'jalepeno',
    'kiwi',
    'lemon',
    'lettuce',
    'mango',
    'onion',
    'orange',
    'paprika',
    'pear',
    'peas',
    'pineapple',
    'pomegranate',
    'potato',
    'raddish',
    'soy beans',
    'spinach',
    'sweetcorn',
    'sweetpotato',
    'tomato',
    'turnip',
    'watermelon'
  ];

  Interpreter? _interpreter;
  TextEditingController _questionController = TextEditingController();
  String _llmResponse = "";
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    try {
      _updateModelStatus("Loading model...");
      _interpreter =
          await Interpreter.fromAsset("assets/models/cnnModel.tflite");
      _updateModelStatus("Model loaded successfully.");
    } catch (e) {
      _updateModelStatus("Error loading model: $e");
    }
  }

  void _updateModelStatus(String status) {
    setState(() {
      _modelStatus = status;
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source);

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
        await _processImage(_imageFile!);
      }
    } catch (e) {
      setState(() {
        _prediction = "Error picking image: $e";
      });
    }
  }

  Future<void> _processImage(File imageFile) async {
    try {
      final rawImage = await imageFile.readAsBytes();
      final img.Image? image = img.decodeImage(rawImage);

      if (image == null) {
        throw Exception("Cannot decode image.");
      }

      final resizedImage = img.copyResize(image, width: 224, height: 224);

      final input = List.generate(224, (i) {
        return List.generate(224, (j) {
          final pixel = resizedImage.getPixel(j, i);
          return [
            (pixel & 0xFF).toDouble(),
            ((pixel >> 8) & 0xFF).toDouble(),
            ((pixel >> 16) & 0xFF).toDouble(),
          ];
        });
      });

      final inputTensor = [input];
      final output =
          List.generate(1, (_) => List.filled(_classNames.length, 0.0));

      _interpreter?.run(inputTensor, output);

      final probabilities = output[0];
      final maxIndex =
          probabilities.indexWhere((prob) => prob == probabilities.reduce(max));

      setState(() {
        _prediction = "Detected: ${_classNames[maxIndex]}";
      });
    } catch (e) {
      setState(() {
        _prediction = "Error processing image: $e";
      });
    }
  }

  Future<void> _askLLM() async {
    if (_questionController.text.isEmpty) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Make a real API request to LLM (replace with your actual API endpoint and key)
    final response = await _fetchLLMResponse(_questionController.text);

    setState(() {
      _llmResponse = response;
      _isLoading = false;
    });

    // Show floating dialog with the response
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("LLM Response"),
          content: Text(_llmResponse),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }

  Future<String> _fetchLLMResponse(String question) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:5000/ask'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: '{"question": "$question"}',
      );

      if (response.statusCode == 200) {
        return 'LLM says: ${response.body}';
      } else {
        return 'Failed to get a response from the LLM.';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }

  @override
  void dispose() {
    _interpreter?.close();
    _questionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Fruit Detection App"),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_imageFile != null)
                    Image.file(_imageFile!)
                  else
                    const Text("No image selected."),
                  const SizedBox(height: 20),
                  Text(
                    _modelStatus,
                    style: const TextStyle(
                        fontSize: 16, fontStyle: FontStyle.italic),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () => _pickImage(ImageSource.gallery),
                        child: const Text("Select from Gallery"),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () => _pickImage(ImageSource.camera),
                        child: const Text("Take a Photo"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _prediction,
                    style: const TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _questionController,
                    decoration: InputDecoration(
                      labelText: 'Ask a question',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _askLLM,
                    child: const Text("Ask LLM"),
                  ),
                  const SizedBox(height: 20),
                  if (_isLoading)
                    CircularProgressIndicator(), // Show progress bar
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
