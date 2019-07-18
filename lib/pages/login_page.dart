
import 'package:autenticacion/pages/profilescreen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignApp extends StatefulWidget {
  @override
  _GoogleSignAppState createState() => _GoogleSignAppState();
}

class _GoogleSignAppState extends State<GoogleSignApp> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = new GoogleSignIn();

  Future<FirebaseUser> _signIn(BuildContext context) async{
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text('Sign In'),
    ));

    final GoogleSignInAccount googleUser=await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth=await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken
    );

    FirebaseUser userDetail = await _firebaseAuth.signInWithCredential(credential);
    ProviderDetails providerInfo = new ProviderDetails(userDetail.providerId);

    List<ProviderDetails> providerData = new List<ProviderDetails>();
    providerData.add(providerInfo);

    UserDetails details = new UserDetails(userDetail.providerId, userDetail.displayName, userDetail.photoUrl,
    userDetail.email,providerData);

    Navigator.push(context, MaterialPageRoute(
      builder: (context)=>ProfileScreen(detailsUser:details)
    ));
    return userDetail;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context)=>Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Image.network('https://biblioteca.acropolis.org/wp-content/uploads/2014/12/azul.png',
              fit: BoxFit.fill,
              color: Color.fromRGBO(255, 255, 255, 0.6),
              colorBlendMode: BlendMode.modulate,),
            
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 10.0,),
                Container(
                  width: 250.0,
                  child: Align(
                    alignment: Alignment.center,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      color: Color(0xffffffff),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(FontAwesomeIcons.google,color: Color(0xffCE107C),),
                          SizedBox(width: 10.0,),
                          Text('SignIn With Google',
                          style: TextStyle(color: Colors.black,fontSize: 18.0),),

                        ],
                      ),
                      onPressed: ()=>_signIn(context).then((FirebaseUser user)=>print(user))
                                                     .catchError((e)=>print(e)),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class UserDetails{
  final String providerDetails;
  final String userName;
  final String photoUrl;
  final String userEmail;
  final List<ProviderDetails> providerData;

  UserDetails(this.providerDetails,this.userName,this.photoUrl,this.userEmail,this.providerData);

}
class ProviderDetails{
  ProviderDetails(this.providerDetails);
  final String providerDetails;
}