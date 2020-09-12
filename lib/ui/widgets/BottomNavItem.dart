import 'package:flutter/material.dart';
import 'package:sarahah_chat/ui/screens/ChatScreen.dart';
import 'package:sarahah_chat/ui/screens/FindScreen.dart';

class BottomNavItem extends StatefulWidget {
  @override
  _BottomNavItemState createState() => _BottomNavItemState();
}

class _BottomNavItemState extends State<BottomNavItem> {
  final List<Map<String, Object>>_widgetsList= [
    {"title": "Chats", "body": ChatScreen()},
    {"title": "Find", "body": FindScreen()}
  ];
  var _widgetIndex = 0;
  void _selectScreen(int index){
    setState(() {
      _widgetIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_widgetsList[_widgetIndex]["title"]),
      ),
      body: _widgetsList[_widgetIndex]["body"],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectScreen,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black54,
        currentIndex: _widgetIndex,
        type: BottomNavigationBarType.shifting,
        items: [
          BottomNavigationBarItem(
              backgroundColor: Theme.of(context).primaryColor,
              icon: Icon(Icons.chat_bubble),
              title: Text("Chats")
          ),
          BottomNavigationBarItem(
              backgroundColor: Theme.of(context).primaryColor,
              icon: Icon(Icons.person_add),
              title: Text("Find")
          ),
        ],
      ),
    );
  }
}
