import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Gemini REST API Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
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
  final String GeminiAPIKey = ""; //TODO: ADD YOUR API KEY HERE
  final TextEditingController _chatController = TextEditingController();
  String responseMessage = "No Status Code";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(responseMessage),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(50.0)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: "Type a message",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(8.0),
                    ),
                    controller: _chatController,
                  ),
                ),
              ),
            ),
            // const SizedBox(width: 4.0,),
            MaterialButton(
              onPressed: () => callGemini(),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(80.0)),
              padding: const EdgeInsets.all(0.0),
              child: Ink(
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.all(Radius.circular(50.0)),
                ),
                child: Container(
                    constraints: const BoxConstraints(
                        minWidth: 88.0, minHeight: 36.0),
                    alignment: Alignment.center,
                    child: const Icon(Icons.send, color: Colors.white,)
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  callGemini() async {
    final url = "https://generativelanguage.googleapis.com/v1/models/gemini-pro:generateContent?key="+GeminiAPIKey;
    final uri = Uri.parse(url);
    List<Map<String,String>> msg = [];
    msg.add({"text":  _chatController.text});
    Map<String, dynamic> request = {
      "contents": {
        "parts": [msg]
      },
    };

    final response = await http.post(uri, body: jsonEncode(request));
    setState(() {
      responseMessage = json.decode(response.body)["candidates"][0]["content"]["parts"][0]["text"];
    });
  }
}
