import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@module
abstract class RegisterModule {
  // register firebaseAuth as a singleton
  @lazySingleton
  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;

  // register firebaseFirestore as a singleton
  @lazySingleton
  FirebaseFirestore get firebaseFirestore => FirebaseFirestore.instance;
}
