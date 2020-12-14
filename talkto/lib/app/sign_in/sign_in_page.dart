
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talkto/common_widget/social_log_in_button.dart';
import 'package:talkto/model/user.dart';
import 'package:talkto/viewmodel/user_model.dart';

import 'email_pasword_login_signup.dart';

class SignInPage extends StatelessWidget {
  /*void _guestLogin(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    User _user = await _userModel.signInAnonymously();
    debugPrint("kullanıcı id : " + _user.userID.toString());
  }*/

  void _googleLogin(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context,listen: false);
    Users _user = await _userModel.signInWithGoogle();
    //if (_user != null) print("Oturum açan user id:" + _user.userID.toString());
  }

  void _facebookLogin(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    Users _user = await _userModel.signInWithFacebook();
    //if (_user != null) debugPrint("kullanıcı id : " + _user.userID.toString());
  }

  void _emailAndPasswordLogin(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => EmailAndPasswordLoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TolkTo"),
        elevation: 0,
      ),
      backgroundColor: Colors.grey.shade200,
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Oturum Açın",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 32,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            SocialLoginButton(
              buttonText: "Gmail ile Giriş Yap",
              buttonColor: Colors.white,
              onPressed: () => _googleLogin(context),
              textColor: Colors.black87,
              buttonIcon: Image.asset("images/google-logo.png"),
            ),
            SocialLoginButton(
              buttonColor: Color(0xFF334D92),
              buttonText: "Facebook ile Giriş Yap",
              buttonIcon: Image.asset("images/facebook-logo.png"),
              onPressed: () => _facebookLogin(context),
            ),
            SocialLoginButton(
              buttonText: "Email ve Şifre ile Giriş Yap",
              buttonIcon: Icon(
                Icons.email,
                size: 32,
                color: Colors.white,
              ),
              onPressed: () => _emailAndPasswordLogin(context),
            ),
            /*SocialLoginButton(
              buttonText: "Misafir Girişi",
              buttonIcon: Icon(Icons.supervised_user_circle),
              buttonColor: Colors.teal,
              onPressed: () => _guestLogin(context),
            ),
             */
          ],
        ),
      ),
    );
  }
}
