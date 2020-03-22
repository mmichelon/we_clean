import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
final databaseReference = Firestore.instance;

String name;
String email;
String userID;
//String imageUrl;

Future<String> signInWithGoogle() async {
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
  await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final AuthResult authResult = await _auth.signInWithCredential(credential);
  final FirebaseUser user = authResult.user;

  // Checking if email and name is null
  assert(user.email != null);
  assert(user.displayName != null);
//  assert(user.photoUrl != null);

  name = user.displayName;
  email = user.email;
  userID = user.uid;
//  imageUrl = user.photoUrl;

  // Only taking the first part of the name, i.e., First Name
  if (name.contains(" ")) {
    name = name.substring(0, name.indexOf(" "));
  }

  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  final FirebaseUser currentUser = await _auth.currentUser();
  assert(user.uid == currentUser.uid);

  //Create new document for the user with uid
  //Should init if it hasn't been yet
  createRecord();
//  await DatabaseService(uid:user.uid).updateUserData('0');

  return 'signInWithGoogle succeeded: $user';
}
void createRecord() async {
  try {
    await Firestore.instance.collection(email).document('Score').get().then((doc) {
      if (doc.exists){
        print("Score exists");
      } else{
        print("Setting Score");
        databaseReference.collection(email).document('Score').setData({
          'Score': 0,
          'title': "Your First Clean!",
          'description': "Congrats for helping the Environment! \nHere you can see you completed cleans!"
        });
      }
    });
  } catch (e) {
    print("Error");
  }
}
void signOutGoogle() async {
  await googleSignIn.signOut();

  print("User Sign Out");
}