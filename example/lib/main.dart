import 'package:flutter/material.dart';
import 'dart:async';

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
  List<DownloadModel> _downloadModels = [];
  StreamSubscription? _eventSub;

  @override
  void initState() {
    _setupKetch();
    super.initState();
  }

  void _setupKetch() async {
    _ketch.setup(enableLogs: true);
    _downloadModels = await _ketch.getDownloadModels();
    _eventSub = _ketch.eventStream.listen((event) {
      setState(() {
        _downloadModels = event;
      });
    });
  }

  @override
  void dispose() {
    _eventSub?.cancel();
    super.dispose();
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
            ..._downloadModels.map(
              (model) => ListTile(
                title: Text(model.fileName),
                trailing: Text("${model.progress}%"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(model.status.toString()),
                    Wrap(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _ketch.pause(id: model.id);
                          },
                          child: Text("Pause"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _ketch.resume(id: model.id);
                          },
                          child: Text("Resume"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _ketch.retry(id: model.id);
                          },
                          child: Text("Retry"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _ketch.cancel(id: model.id);
                          },
                          child: Text("Cancel"),
                        ),
                      ],
                    ),
                  ],
                ),
                onTap: () {
                  _ketch.cancel(id: model.id);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _startTestDownload() async {
    _ketch.download(
      // url: "https://sample-files.com/downloads/documents/txt/simple.txt",
      // url: "https://ash-speed.hetzner.com/100MB.bin",
      url: "https://testfile.org/1.3GBiconpng",
      path: (await getApplicationDocumentsDirectory()).path,
      fileName: "${DateTime.now().millisecondsSinceEpoch}.bin",
    );
  }
}
