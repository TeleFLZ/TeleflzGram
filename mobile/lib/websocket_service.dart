import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'main.dart';

class WebSocketService {
  final String token;
  final AppState state;
  WebSocketChannel? channel;

  WebSocketService(this.token, this.state);

  void connect() {
    final url = 'ws://YOUR_SERVER_IP:8000/ws?token=$token'; // замени на твой IP или домен
    channel = WebSocketChannel.connect(Uri.parse(url));
    channel!.stream.listen((data) {
      final msg = jsonDecode(data);
      if (msg['type'] == 'message' || msg['type'] == 'history') {
        state.addMessage(msg);
      } else if (msg['type'] == 'balance') {
        state.updateCoins(msg['coins'].toDouble());
      } else if (msg['type'] == 'sent') {
        // подтверждение
      }
    }, onDone: () {
      // reconnect logic
    });
  }

  void sendMessage(String to, String content) {
    channel?.sink.add(jsonEncode({'type': 'send', 'to': to, 'content': content}));
  }

  void tip(String to, double amount) {
    channel?.sink.add(jsonEncode({'type': 'tip', 'to': to, 'amount': amount}));
  }

  void disconnect() {
    channel?.sink.close();
  }
}
