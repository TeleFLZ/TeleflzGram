import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(radius: 50, child: Text(state.username[0].toUpperCase())),
          SizedBox(height: 10),
          Text('@${state.username}', style: TextStyle(fontSize: 24)),
          Text('Balance: ${state.coins.toStringAsFixed(2)} 🪙', style: TextStyle(fontSize: 20)),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () => state.logout(),
            child: Text('Logout'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          ),
        ],
      ),
    );
  }
}
