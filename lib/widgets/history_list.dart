import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HistoryListWidget extends StatefulWidget {
  final List<String> textHistory;
  HistoryListWidget({Key key, this.textHistory}) : super(key: key);
  @override
  _HistoryListWidgetState createState() => new _HistoryListWidgetState();
}

class _HistoryListWidgetState extends State<HistoryListWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(
        color: Colors.black,
      ),
      itemCount: widget.textHistory.length,
      itemBuilder: (context, index) {
        return Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          child: ListTile(

              /// selected: true,
              //leading: Text('${widget.textHistory.id}'),
              title: Text(
                '${widget.textHistory[index]}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () {}),
          actions: <Widget>[
            IconSlideAction(
                caption: 'Copy',
                color: Colors.grey[300],
                icon: Icons.delete_forever,
                onTap: () {}),
          ],
          secondaryActions: <Widget>[
            IconSlideAction(
                caption: 'Delete',
                color: Colors.redAccent[200],
                icon: Icons.delete_forever,
                onTap: () {}),
          ],
        );
      },
    );
  }
}
