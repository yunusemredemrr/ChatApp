import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talkto/app/talk_page.dart';
import 'package:talkto/model/talk.dart';
import 'package:talkto/model/user.dart';
import 'package:talkto/viewmodel/chat_view_model.dart';
import 'package:talkto/viewmodel/user_model.dart';

class MySpeechesPage extends StatefulWidget {
  @override
  _MySpeechesPageState createState() => _MySpeechesPageState();
}

class _MySpeechesPageState extends State<MySpeechesPage> {
  @override
  Widget build(BuildContext context) {
    UserModel _userModel = Provider.of<UserModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Konuşmalarım"),
      ),
      body: FutureBuilder<List<Talk>>(
        future: _userModel.getAllConversations(_userModel.user.userID),
        builder: (context, talkList) {
          if (talkList.hasData) {
            var allSpech = talkList.data;
            if (allSpech.length > 0) {
              return RefreshIndicator(
                onRefresh: _konusmalarinListesiniYenile,
                child: ListView.builder(
                  itemCount: allSpech.length,
                  addAutomaticKeepAlives: true,
                  itemBuilder: (context, index) {
                    var currentSpech = allSpech[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                ChangeNotifierProvider<ChatViewModel>(
                              create: (context) => ChatViewModel(
                                  currentUser: _userModel.user,
                                  oppositeUser: Users.idVeResim(
                                      userID: currentSpech.who_is_talking,
                                      profilURL:
                                          currentSpech.konusulanUserProfilURL)),
                              child: TalkPage(),
                            ),
                          ),
                        );
                      },
                      child: ListTile(
                        title: Text(currentSpech.last_message_sent),
                        subtitle: Text(currentSpech.konusulanUserName +
                            "  " +
                            currentSpech.aradakiFark),
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey.withAlpha(40),
                          backgroundImage:
                              NetworkImage(currentSpech.konusulanUserProfilURL),
                        ),
                      ),
                    );
                  },
                ),
              );
            } else {
              return RefreshIndicator(
                onRefresh: _konusmalarinListesiniYenile,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Container(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.chat,
                            color: Theme.of(context).primaryColor,
                            size: 120,
                          ),
                          Text(
                            "Henüz kullanıcı yok",
                            style: TextStyle(fontSize: 36),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    height: MediaQuery.of(context).size.height - 150,
                  ),
                ),
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  /*
  void _mySpeechesIncomign() async {
    final _userModel = Provider.of<UserModel>(context);
    var mySpeeches = await FirebaseFirestore.instance
        .collection("speeches")
        .where("konusma_sahibi", isEqualTo: _userModel.user.userID)
        .orderBy("olusturulma_tarihi", descending: true)
        .get();

    for (var speak in mySpeeches.docs) {
      print("Konuşma : " + speak.data.toString());
    }
  }

   */

  Future<Null> _konusmalarinListesiniYenile() async {
    setState(() {});
    await Future.delayed(Duration(milliseconds: 10));
    return null;
  }
}
