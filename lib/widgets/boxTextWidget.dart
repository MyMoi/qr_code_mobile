import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class BoxText extends StatelessWidget {
  final String content;
  const BoxText({
    Key key,
    this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: EdgeInsets.all(10),

      // width: Double.infinite,
      decoration: BoxDecoration(
          //color: Colors.amber,
          color: Colors.white10,
          //border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.all(Radius.circular(10))),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        //mainAxisSize: MainAxisSize,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // Expanded(
          //  child:
          ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight:
                    610 //put here the max height to which you need to resize the textbox

                ),
            child: SelectableLinkify(
              onOpen: (link) async {
                if (await canLaunch(link.url)) {
                  await launch(link.url);
                } else {
                  throw 'Could not launch $link';
                }
              },
              text: content,
              style: TextStyle(color: Colors.yellow),
              linkStyle: TextStyle(color: Colors.red),
              options: LinkifyOptions(humanize: false),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {},
                    ),
                    OutlineButton.icon(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: content));
                      },
                      icon: Icon(Icons.copy_outlined),
                      label: Text("Copy"),
                    ),
                  ]),
              /*   IconButton(
                onPressed: () {},
                icon: Icon(Icons.send,
                    color: // Color(
                        //0xffc5e1a5), //
                        Theme.of(context).accentColor),
              ),*/
            ],
          ),
        ],
      ),
    );
  }
}
