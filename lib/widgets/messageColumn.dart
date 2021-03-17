import 'package:flutter/material.dart';
import 'package:send_qr/communication/messageManager.dart';
import 'package:send_qr/model/messageClass.dart';
import 'package:send_qr/widgets/boxFileWidget.dart';
import 'package:send_qr/widgets/boxTextWidget.dart';
import 'package:send_qr/widgets/inputBox.dart';

class MessageColumn extends StatefulWidget {
  const MessageColumn({
    Key key,
  }) : super(key: key);

  @override
  _MessageColumnState createState() => _MessageColumnState();
}

class _MessageColumnState extends State<MessageColumn> {
  MessageManager _messageManager = MessageManager();

  void dispose() {
    super.dispose();
    _messageManager.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    /*  _messageManager.updateMessageListStream.listen((event) {
      print('object');
      setState(() {});
    });*/
    // List messageList = ['aaaa', 'aaab', 'caaaa', 'aaaa https://google.com'];
    return CustomScrollView(slivers: <Widget>[
      const SliverAppBar(
        //stretch: true,
        backgroundColor: const Color(0xff303030),
        automaticallyImplyLeading: false,
        //      elevation: 0,
        pinned: true,
        floating: true,
        snap: true,
        collapsedHeight: 150.0,
        expandedHeight: 377,
        flexibleSpace: InputBox(),
      ),

      //Sliver
      //InputBox(),
      StreamBuilder(
          stream: _messageManager.updateMessageListStream,
          builder: (context, snapshot) {
            //print(Theme.of(context).backgroundColor);
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  final _message = _messageManager.messageList[
                      _messageManager.messageList.length - (index + 1)];
                  return (_message.type == MessageType.text)
                      ? BoxText(content: _message.content)
                      : BoxFile(content: _message.content);
                },
                childCount: _messageManager.messageList.length,
              ),
            );
          }),
      /*  Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[

          ]),*/
    ]);
  }
}
