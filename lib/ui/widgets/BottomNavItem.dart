import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sarahah_chat/ui/screens/AccountScreen.dart';
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
        actions: [
          DropdownButtonHideUnderline(
            child: DropdownButton(
              icon: Icon(Icons.more_vert, color: Colors.white,),
              items: [
                DropdownMenuItem(
                  child: Container(
                    child: Row(
                      children: [
                        Icon(Icons.account_circle),
                        SizedBox(width: 10,),
                        Text("Account")
                      ],
                    ),
                  ),
                  value: "account",
                ),
                DropdownMenuItem(
                  child: Container(
                    child: Row(
                      children: [
                        Icon(Icons.exit_to_app),
                        SizedBox(width: 10,),
                        Text("Logout")
                      ],
                    ),
                  ),
                  value: "logout",
                ),

              ],
              onChanged: (val){
                switch(val){
                  case "logout":FirebaseAuth.instance.signOut();
                  break;
                  case "account": Navigator.of(context).pushNamed(AccountScreen.ROUTE_NAME);
                }

              },
            ),
          ),
          SizedBox(width: 10,),
        ],
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
