import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:test_app/dashboard.dart';
import 'package:test_app/sign_up.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {


  TextEditingController emailCon;
  TextEditingController pwdCon;


  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    emailCon = new TextEditingController();
    pwdCon = new TextEditingController();
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Sign in"),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[

              TextField(decoration: InputDecoration(
                border: new OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.teal)
                ),

                labelText: 'Email',
              ),controller: emailCon,),
              SizedBox(height: 16.0,),
              TextField(decoration: InputDecoration(
                border: new OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.teal)
                ),

                labelText: 'Password',
              ),controller: pwdCon,),

              RaisedButton(onPressed: (){
                String email = emailCon.text.trim();
                print(email);
                _handleSignIn(email, pwdCon.text).then((user){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Dashboard()));
                });
              },
                child: Text("Sign In"),),
              RaisedButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUp()));
              },
                child: Text("No Account? Sign Up"),)

            ],
          ),
        ),
      ),
    );
  }

  Future<FirebaseUser> _handleSignIn(String email, String pwd) async {
    final FirebaseUser user = (await _auth.signInWithEmailAndPassword(email:email,password: pwd)).user;
   // print("signed in " + user.displayName);
    return user;
  }
}
