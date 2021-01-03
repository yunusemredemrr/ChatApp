import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talkto/app/talk_page.dart';
import 'package:talkto/viewmodel/all_users_view_model.dart';
import 'package:talkto/viewmodel/chat_view_model.dart';
import 'package:talkto/viewmodel/user_model.dart';

class UsersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  bool isLoading = false;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _scrollController.addListener(_listScrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kullanıcılar"),
      ),
      body: Consumer<AllUserViewModel>(
        builder: (context, model, child) {
          if (model.state == AllUserViewState.Busy) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (model.state == AllUserViewState.Loaded) {
            return RefreshIndicator(
              onRefresh: model.refresh,
              child: ListView.builder(
                controller: _scrollController,
                itemBuilder: (context, index) {
                  if (model.usersList.length == 1) {
                    return _noUserUI();
                  }
                  if (model.hasMoreLoading && index == model.usersList.length) {
                    return _yeniElemanlarYukleniyorIndicator();
                  } else {
                    return _userListeElemaniOlustur(index);
                  }
                },
                itemCount: model.hasMoreLoading == true
                    ? model.usersList.length + 1
                    : model.usersList.length,
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget _noUserUI() {
    final _usersModel = Provider.of<AllUserViewModel>(context);
    return RefreshIndicator(
      onRefresh: _usersModel.refresh,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.supervised_user_circle,
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

  Widget _userListeElemaniOlustur(int index) {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    final _allUsersViewModel =
        Provider.of<AllUserViewModel>(context, listen: false);
    var _oankiUser = _allUsersViewModel.usersList[index];
    if (_oankiUser.userID == _userModel.user.userID) {
      return Container();
    } else
      return GestureDetector(
        onTap: () {
          Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider<ChatViewModel>(
                create: (context) => ChatViewModel(
                    currentUser: _userModel.user, oppositeUser: _oankiUser),
                child: TalkPage(),
              ),
            ),
          );
        },
        child: Column(
          children: [
            Container(
              height: 70,
              padding: EdgeInsets.only(top: 5),
              child: ListTile(
                title: Text(
                  _oankiUser.userName,
                  style: TextStyle(
                      fontSize: _oankiUser.userName.length < 28 ? 18.5 : 15),
                ),
                //subtitle: Text(_oankiUser.email),
                leading: CircleAvatar(
                  backgroundImage: _oankiUser.profilURL == "images/unknown.jpg"
                      ? ExactAssetImage(_oankiUser.profilURL)
                      : NetworkImage(_oankiUser.profilURL),
                  radius: 34,
                ),
              ),
            ),
            Container(
              height: 1,
              width: MediaQuery.of(context).size.width * 1,
              margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.23),
              color: Colors.black45,
            ),
          ],
        ),
      );
  }

  _yeniElemanlarYukleniyorIndicator() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void bringMoreUsers() async {
    if (isLoading == false) {
      isLoading = true;
      final _allUsersViewModel =
          Provider.of<AllUserViewModel>(context, listen: false);
      await _allUsersViewModel.bringMoreUsers();
      isLoading = false;
    }
  }

  void _listScrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      bringMoreUsers();
    }
  }
}
