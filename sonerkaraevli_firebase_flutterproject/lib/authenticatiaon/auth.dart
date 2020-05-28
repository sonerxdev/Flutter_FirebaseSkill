
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';



final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

String name;
String email;
String imageUrl;

Future<String> signInWithGoogle() async {
  //Firebase'in SignInWithGoogle fonksiyonu. Bütün dillerde aynıdır. Firebaseauth.dart kütüphanesiyle çağrılır.
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final AuthResult authResult = await _auth.signInWithCredential(credential);
  final FirebaseUser user = authResult.user;

  //email ve diğerlerinin null olup olmadığını check ediyor.
  assert(user.email != null);
  assert(user.displayName != null);
  assert(user.photoUrl != null);
//user'a ait değişkenleri atıyorum.
  name = user.displayName;
  email = user.email;
  imageUrl = user.photoUrl;

  //ismin sadece ilk kısmını alıyor.
  if (name.contains(" ")) {
    name = name.substring(0, name.indexOf(" "));
  }

  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  final FirebaseUser currentUser = await _auth.currentUser();
  assert(user.uid == currentUser.uid);

  return 'signInWithGoogle succeeded: $user';
}

//Firebase Log out fonksiyonu.
void signOutGoogle() async {
  await googleSignIn.signOut();

  print("User Sign Out");
}