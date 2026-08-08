import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';
import 'main_screen.dart';
import 'websocket_service.dart';

void main() => runApp(TeleflzGramApp());

class TeleflzGramApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState()..init(),
      child: MaterialApp(
        title: 'TeleflzGram',
        theme: ThemeData.dark(),
        home: Consumer<AppState>(
          builder: (_, state, __) => state.token.isEmpty ? LoginScreen() : MainScreen(),
        ),
      ),
    );
  }
}

class AppState extends ChangeNotifier {
  String token = '';
  String username = '';
  double coins = 0.0;
  List<Map<String, dynamic>> messages = [];
  List<Map<String, dynamic>> contacts = [];
  WebSocketService? ws;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
    username = prefs.getString('username') ?? '';
    coins = prefs.getDouble('coins') ?? 0.0;
    if (token.isNotEmpty) connectWebSocket();
  }

  void setAuth(String t, String u, double c) {
    token = t;
    username = u;
    coins = c;
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('token', t);
      prefs.setString('username', u);
      prefs.setDouble('coins', c);
    });
    connectWebSocket();
    notifyListeners();
  }

  void connectWebSocket() {
    ws = WebSocketService(token, this);
    ws!.connect();
  }

  void addMessage(Map<String, dynamic> msg) {
    messages.insert(0, msg);
    notifyListeners();
  }

  void updateCoins(double newCoins) {
    coins = newCoins;
    SharedPreferences.getInstance().then((prefs) => prefs.setDouble('coins', newCoins));
    notifyListeners();
  }

  void logout() {
    ws?.disconnect();
    token = '';
    username = '';
    coins = 0.0;
    messages.clear();
    SharedPreferences.getInstance().then((prefs) {
      prefs.remove('token');
      prefs.remove('username');
      prefs.remove('coins');
    });
    notifyListeners();
  }
}
