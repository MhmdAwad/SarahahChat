import 'package:flutter/material.dart';
import 'package:sarahah_chat/ui/widgets/TextFormWidget.dart';
import 'package:sarahah_chat/utils/FindStatus.dart';

class FindUserWidget extends StatefulWidget {
  final FindStatus _findStatus;
  final Function _findUser;
  FindUserWidget(this._findStatus, this._findUser);
  @override
  _FindUserWidgetState createState() => _FindUserWidgetState();
}

class _FindUserWidgetState extends State<FindUserWidget> {
  final controller = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormWidget("Add user link", controller,
              TextInputAction.search, false, null),
        ),
        widget._findStatus == FindStatus.LOADING
            ? Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircularProgressIndicator(),
        )
            : IconButton(
          icon: Icon(Icons.search,
              color: Theme.of(context).primaryColor),
          onPressed: ()=>widget._findUser(controller.text),
        )
      ],
    );
  }
}
