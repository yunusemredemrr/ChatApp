import 'package:cloud_firestore_platform_interface/src/timestamp.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:talkto/model/message.dart';
import 'package:talkto/viewmodel/chat_view_model.dart';

class TalkPage extends StatefulWidget {
  @override
  _TalkPageState createState() => _TalkPageState();
}

class _TalkPageState extends State<TalkPage> {
  var _messageControler = TextEditingController();
  ScrollController _scrollController = new ScrollController();
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    final _chatModel = Provider.of<ChatViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Sohbet"),
      ),
      body: _chatModel.state == ChatViewState.Bussy
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: Column(
                children: <Widget>[
                  _buildMessageList(),
                  _buildNewMessageEnter(),
                ],
              ),
            ),
    );
  }

  Widget _buildMessageList() {
    return Consumer<ChatViewModel>(
      builder: (context, chatModel, child) {
        return Expanded(
          child: ListView.builder(
            controller: _scrollController,
            reverse: true,
            itemCount: chatModel.hasMoreLoading
                ? chatModel.messageList.length + 1
                : chatModel.messageList.length,
            itemBuilder: (context, index) {
              if (chatModel.hasMoreLoading && chatModel.messageList.length == index) {
                return _newMessageLoadingIndicator();
              } else
                return _createSpeechBubble(chatModel.messageList[index]);
            },
          ),
        );
      },
    );
  }

  Widget _buildNewMessageEnter() {
    final _chatModel = Provider.of<ChatViewModel>(context);
    return Container(
      padding: EdgeInsets.only(bottom: 8, left: 8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _messageControler,
              cursorColor: Colors.blueGrey,
              style: new TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: "Mesajınızı Yazınız",
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: 4,
            ),
            child: FloatingActionButton(
              elevation: 0,
              backgroundColor: Colors.blue,
              child: Icon(
                Icons.navigation,
                size: 35,
                color: Colors.white,
              ),
              onPressed: () async {
                if (_messageControler.text.trim().length > 0) {
                  Message _tobeRecordedMessage = Message(
                    fromWho: _chatModel.currentUser.userID,
                    toWho: _chatModel.oppositeUser.userID,
                    isMe: true,
                    message: _messageControler.text,
                  );
                  var result =
                      await _chatModel.saveMessage(_tobeRecordedMessage,_chatModel.currentUser);
                  if (result) {
                    _messageControler.clear();
                    _scrollController.animateTo(
                      0.0,
                      curve: Curves.easeOut,
                      duration: Duration(milliseconds: 15),
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _createSpeechBubble(Message currentMessage) {
    Color _incomingMessageColor = Colors.blue;
    Color _outgoingMessageColor = Theme.of(context).primaryColor;
    final _chatModel = Provider.of<ChatViewModel>(context);

    var _hourMinuteValue = "";

    try {
      _hourMinuteValue =
          _hourMinuteShow(currentMessage.date) ?? Timestamp(1, 1);
    } catch (e) {
      print("hata " + e.toString());
    }

    var _isMeMessage = currentMessage.isMe;
    if (_isMeMessage) {
      return Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Flexible(
                  child: Container(
                    constraints: BoxConstraints(maxWidth: 300),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                      ),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 20.0,
                          offset: Offset(10, 10),
                          color: Colors.black54,
                        ),
                      ],
                      color: _outgoingMessageColor,
                    ),
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          currentMessage.message,
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          _hourMinuteValue,
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundImage:
                      NetworkImage(_chatModel.oppositeUser.profilURL),
                  backgroundColor: Colors.grey.withAlpha(40),
                ),
                Flexible(
                  child: Container(
                    constraints: BoxConstraints(maxWidth: 300),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 20.0,
                          offset: Offset(10, 10),
                          color: Colors.black54,
                        ),
                      ],
                      color: _incomingMessageColor,
                    ),
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(currentMessage.message),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          _hourMinuteValue,
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade800,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }

  String _hourMinuteShow(Timestamp date) {
    var _formatter = DateFormat.Hm();
    var _formattedDate = _formatter.format(date.toDate());
    return _formattedDate;
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      bringOldMessages();
    }
  }

  void bringOldMessages() async {
    final _chatModel = Provider.of<ChatViewModel>(context, listen: false);
    if (isLoading == false) {
      isLoading = true;
      await _chatModel.bringMoreMessages();
      isLoading = false;
    }
  }

  _newMessageLoadingIndicator() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
