import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'main.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _user = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  bool isRegister = false;

  Future<void> auth() async {
    final endpoint = isRegister ? '/register' : '/login';
    final url = 'http://YOUR_SERVER_IP:8000$endpoint';
    final body = {'username': _user.text, 'password': _pass.text};
    if (isRegister) body['display_name'] = _user.text;
    final res = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body));
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      if (data['ok'] == true) {
        Provider.of<AppState>(context, listen: false)
            .setAuth(data['token'], _user.text, data['coins']?.toDouble() ?? 0.0);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Auth failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('TeleflzGram', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.blue)),
            SizedBox(height: 40),
            TextField(controller: _user, decoration: InputDecoration(labelText: 'Username')),
            TextField(controller: _pass, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(onPressed: auth, child: Text(isRegister ? 'Sign Up' : 'Sign In')),
            TextButton(onPressed: () => setState(() => isRegister = !isRegister), child: Text(isRegister ? 'Login' : 'Create account')),
          ],
        ),
      ),
    );
  }
}
