import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:permission_handler/permission_handler.dart';

class Chat extends StatefulWidget {
  final String nutritionistName; // Ajoutez cette ligne
  const Chat({super.key, required this.nutritionistName});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController _messageController = TextEditingController();
  final List<String> _messages = [];
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _initializeRecorder();
  }

  Future<void> _initializeRecorder() async {
    await _recorder.openRecorder();
    await Permission.microphone.request();
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    super.dispose();
  }

  void _sendMessage() {
    final String message = _messageController.text;
    if (message.isNotEmpty) {
      setState(() {
        _messages.add(message);
      });
      _messageController.clear();
    }
  }

  Future<void> _startRecording() async {
    if (await Permission.microphone.request().isGranted) {
      setState(() => _isRecording = true);
      await _recorder.startRecorder(toFile: 'audioMessage.aac');
    }
  }

  Future<void> _stopRecording() async {
    final path = await _recorder.stopRecorder();
    setState(() => _isRecording = false);

    if (path != null) {
      setState(() {
        _messages.add('audio:$path'); // Préfixer l'audio pour différencier les messages
      });
    }
  }

  void _playAudio(String path) async {
    final FlutterSoundPlayer player = FlutterSoundPlayer();
    await player.openPlayer();
    await player.startPlayer(fromURI: path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat avec ${widget.nutritionistName}", style: TextStyle(color: Color(0xFFF7A73D)),),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                if (message.startsWith('audio:')) {
                  final path = message.substring(6);
                  return ListTile(
                    title: InkWell(
                      onTap: () => _playAudio(path),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.play_arrow, color: Colors.orange),
                            SizedBox(width: 10),
                            Text('Message vocal'),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return ListTile(
                    title: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(message),
                    ),
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Écrivez votre message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Color(0xFFF7A73D)),
                  onPressed: _sendMessage,
                ),
                IconButton(
                  icon: Icon(
                    _isRecording ? Icons.stop : Icons.mic,
                    color: Color(0xFFF7A73D),
                  ),
                  onPressed: _isRecording ? _stopRecording : _startRecording,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
