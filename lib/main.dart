import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: [
    'profile',
    'email'
  ]
);

void main() => runApp(MaterialApp(
  title: 'Google Sign In',
  home: SignInDemo(),
  debugShowCheckedModeBanner: false,
));

class SignInDemo extends StatefulWidget {
  @override
  _SignInDemoState createState() => _SignInDemoState();
}

class _SignInDemoState extends State<SignInDemo> {

  GoogleSignInAccount _currentUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
    });

    _googleSignIn.signInSilently();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Sign In Demo'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if(_currentUser != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          ListTile(
            leading: GoogleUserCircleAvatar(
                identity: _currentUser
            ),
            title: Text(_currentUser.displayName ?? ''),
            subtitle: Text(_currentUser.email ?? ''),
          ),
          RaisedButton(
            onPressed: _handleSignOut,
            child: Text('Sign Out'),
          ),
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text('Não está logado'),
          RaisedButton(
            onPressed: _handleSignIn,
            child: Text('Sign In'),
          ),
        ],
      );
    }

  }

  Future<void> _handleSignIn() async {
    try{
      await _googleSignIn.signIn();
    } catch(error){
      print(error);
    }
  }

  Future<void> _handleSignOut() async {
    try{
      await _googleSignIn.disconnect();
    } catch(error){
      print(error);
    }
  }

}
