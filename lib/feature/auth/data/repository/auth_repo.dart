import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepo {

  // Either<int,int>
//login
  Future<Either<String, String>> login({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential user =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return const Right('Login Sussefully');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return const Left('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        return const Left('Wrong password provided for that user.');
      } else {
        return Left(e.code.toString());
      }
    }
  }

//register
//forget password
Future<Either<String, String>> forgetPassword({
    required String email,
   
  }) async {
    try {
      FirebaseAuth.instance
              .sendPasswordResetEmail(email: email);
      return const Right('Code is sended sucessfully');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return const Left('No user found for that email.');
      }  else {
        return Left(e.code.toString());
      }
    }catch (e){
      return Left(e.toString());
    }
  }
}