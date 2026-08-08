import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'main.dart';

class ContactsScreen extends StatefulWidget {
  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  List contacts = [];
  TextEditingController tipController = TextEditingController();
  String? selectedContact;

  @override
  void initState() {
    super.initState();
    fetchContacts();
  }

  Future<void> fetchContacts() async {
    final state = Provider.of<AppState>(context, listen: false);
    final res = await http.get(Uri.parse('http://YOUR_SERVER_IP:8000/users?token=${state.token}'));
    if (res.statusCode == 200) {
      setState(() => contacts = jsonDecode(res.body));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (_, i) {
              final c = contacts[i];
              return ListTile(
                leading: Icon(Icons.person, color: c['online'] ? Colors.green : Colors.grey),
                title: Text(c['display_name'] ?? c['username']),
                subtitle: Text('@${c['username']}'),
                trailing: IconButton(
                  icon: Icon(Icons.monetization_on, color: Colors.amber),
                  onPressed: () => _showTipDialog(c['username']),
                ),
                onTap: () {
                  // открыть диалог с этим пользователем
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void _showTipDialog(String username) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Send coins to @$username'),
        content: TextField(
          controller: tipController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: 'Amount'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          TextButton(
            onPressed: () {
              final amount = double.tryParse(tipController.text) ?? 0;
              if (amount > 0) {
                Provider.of<AppState>(context, listen: false).ws?.tip(username, amount);
              }
              Navigator.pop(context);
            },
            child: Text('Send'),
          ),
        ],
      ),
    );
  }
}
