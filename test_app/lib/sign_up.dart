import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:test_app/login.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController fNameCon;
  TextEditingController lNameCon;
  TextEditingController emailCon;
  TextEditingController pwdCon;


  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fNameCon = new TextEditingController();
    lNameCon = new TextEditingController();
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
        title: Text("Sign up"),
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

                labelText: 'Firstname',
              ),controller: fNameCon,),
              SizedBox(height: 16.0,),
              TextField(decoration: InputDecoration(
                border: new OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.teal)
                ),

                labelText: 'Last Name',
              ),controller: lNameCon,),
              SizedBox(height: 16.0,),
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
                registerUser(email, pwdCon.text).then((user){
                  if (user!=null){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));
                  }
                }).catchError((e)=>print(e));
              },
              child: Text("Sign Up"),)

            ],
          ),
        ),
      ),
    );
  }


  Future<FirebaseUser> registerUser(String email, String pwd)async{
    final FirebaseUser user = (await _auth.createUserWithEmailAndPassword(email: email, password: pwd)).user;
    return user;
  }

}
