import 'package:flutter/material.dart';
import 'dart:async';

import 'package:ketch_flutter/ketch.dart';
import 'package:ketch_flutter/ketch_flutter.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _ketch = KetchFlutter();

  @override
  void initState() {
    _ketch.setup(enableLogs: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Plugin example app')),
        body: ListView(
          children: [
            ElevatedButton(
              onPressed: _startTestDownload,
              child: Text("Start test download"),
            ),
          ],
        ),
      ),
    );
  }

  Future _startTestDownload() async {
    _ketch.download(
      url: "https://sample-files.com/downloads/documents/txt/simple.txt",
      path: (await getApplicationDocumentsDirectory()).path,
      fileName: "${DateTime.now().millisecondsSinceEpoch}.txt",
    );
  }
}
