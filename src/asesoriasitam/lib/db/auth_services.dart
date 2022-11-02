import 'package:asesoriasitam/global.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  final userRef = FirebaseFirestore.instance.collection("usuarios");
  final grupoRef = FirebaseFirestore.instance.collection("grupos");
  final claseRef = FirebaseFirestore.instance.collection("clases");
  final profRef = FirebaseFirestore.instance.collection("profesores");

  AuthenticationService(this._firebaseAuth);
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  //Auth Stuff
  Future<String> signIn(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      print("signed in: ${_firebaseAuth.currentUser!.email}");

      await Global.getUsuario(uid: _firebaseAuth.currentUser!.uid);
      return "Signed In";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return "Correo no registrado";
      } else if (e.code == 'wrong-password') {
        return "Contraseña incorrecta";
      } else if (e.code == 'too-many-requests') {
        return "Demasiados intentos desde dispositivo";
      } else {
        return "Ocurrio un error";
      }
    }
    //return "Already signed in";
  }

  Future<void> deleteCurrentUser() async {
    await _firebaseAuth.currentUser!.delete();
  }

  Future<void> reauth({required String password}) async {
    AuthCredential credential = EmailAuthProvider.credential(
        email: _firebaseAuth.currentUser!.email!, password: password);
    await _firebaseAuth.currentUser!.reauthenticateWithCredential(credential);
  }

  Future<void> sendVerificationEmail({required String email}) async {
    print("sending email to ${_firebaseAuth.currentUser?.email}");
    await _firebaseAuth.currentUser?.sendEmailVerification();
  }

  Future<String?> signUp(
      {required String email, required String password}) async {
    print(email);
    try {
      UserCredential cred = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      await cred.user!.sendEmailVerification();
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return "La contrasena es muy debil";
      } else if (e.code == 'email-already-in-use') {
        return "Ya existe una cuenta con este correo.";
      } else {
        print(e);
        return "Algo malo paso y npi xd";
      }
    } catch (e) {
      print(e);
      return "Error";
    }
  }

  Future<void> signOut() async {
    Global.clear();
    await _firebaseAuth.signOut();
  }
}
