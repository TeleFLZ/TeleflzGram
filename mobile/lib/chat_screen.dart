import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    return ListView.builder(
      itemCount: state.messages.length,
      itemBuilder: (_, i) {
        final msg = state.messages[i];
        return ListTile(
          title: Text('${msg['from']}: ${msg['content']}'),
          subtitle: Text(msg['time'] ?? ''),
        );
      },
    );
  }
}
