import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Model/contents.dart';
import 'Model/parts.dart';
import 'Model/request.dart';
import 'Model/response.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Gemini REST API Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black87),
          titleLarge: TextStyle(color: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0),
            ),
            minimumSize: const Size(88, 36),
            padding: EdgeInsets.zero,
          ),
        ),
      ),
      home: const MyHomePage(title: 'Flutter Gemini REST API Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String GEMINI_API_KEY = "YOUR_API_KEY_HERE"; //TODO: Replace with your actual API key
  final TextEditingController _chatController = TextEditingController();
  String responseMessage = "Hello 👋, No response yet!";
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(widget.title, style: Theme.of(context).textTheme.titleLarge),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _isLoading ? _buildLoadingIndicator() : Container(),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    responseMessage,
                    style: const TextStyle(fontSize: 18.0),
                  ),
                ),
              ),
              TextField(
                controller: _chatController,
                decoration: InputDecoration(
                  hintText: "Type a message",
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(
                      color: Colors.deepPurple,
                      width: 2.0,
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(16.0),
                ),
                maxLines: 5,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ElevatedButton.icon(
                  onPressed: () => _callGemini(),
                  iconAlignment: IconAlignment.end,
                  label: const Text('Send', style: TextStyle(color: Colors.white)),
                  icon: const Icon(Icons.send, color: Colors.white),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const CircularProgressIndicator(color: Colors.deepPurple);
  }

  _callGemini() async {
    setState(() {
      _isLoading = true;
    });
    final url = "https://generativelanguage.googleapis.com/v1/models/gemini-pro:generateContent?key=$GEMINI_API_KEY";
    final uri = Uri.parse(url);
    Request request = Request();
    List<Parts> partsList = [Parts(text: _chatController.text)];
    List<Contents> contentsList = [Contents(parts: partsList)];
    request.contents = contentsList;

    final rawResponse = await http.post(uri, body: jsonEncode(request.toJson()));
    Response response = Response.fromJson(jsonDecode(rawResponse.body));
    setState(() {
      _isLoading = false;
      responseMessage = response.candidates!.first.content!.parts!.first.text!;
    });
  }
}