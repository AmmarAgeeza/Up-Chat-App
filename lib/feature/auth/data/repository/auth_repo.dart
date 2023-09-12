import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';

class AuthRepo {
  // Either<int,int>
//login
  Future<Either<String, UserModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      //  login with firebase auth
      UserCredential user =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // get user data from firestore
      final result = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.user!.uid)
          .get();

      return Right(UserModel.fromJson(result.data()!));
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
  Future<Either<String, String>> register({
    required String name,
    required String phone,
    required String email,
    required String password,
    required String department,
  }) async {
    try {
      //register with firebase auth
      final userAccount =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // save user data in firestore
      FirebaseFirestore.instance
          .collection('users')
          .doc(userAccount.user!.uid)
          .set(
        {
          'name': name,
          'email': email,
          'phone': phone,
          'department': department,
          'uid': userAccount.user!.uid,
        },
      );
      return const Right('Registration Sucessfully');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return const Left('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        return const Left('The account already exists for that email.');
      } else {
        return Left(e.code);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

//forget password
  Future<Either<String, String>> forgetPassword({
    required String email,
  }) async {
    try {
      FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return const Right('Code is sended sucessfully');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return const Left('No user found for that email.');
      } else {
        return Left(e.code.toString());
      }
    } catch (e) {
      return Left(e.toString());
    }
  }
}
//algorithm
//1. register with firebase auth
//2. save user data in firestore
//3. login with firebase auth
//4. get user data from firestore
