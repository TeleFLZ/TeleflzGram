import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';
import 'chat_screen.dart';
import 'contacts_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('TeleflzGram'),
          bottom: TabBar(tabs: [
            Tab(icon: Icon(Icons.chat), text: 'Chats'),
            Tab(icon: Icon(Icons.people), text: 'Contacts'),
            Tab(icon: Icon(Icons.person), text: 'Profile'),
          ]),
        ),
        body: TabBarView(
          children: [
            ChatScreen(),
            ContactsScreen(),
            ProfileScreen(),
          ],
        ),
      ),
    );
  }
}
