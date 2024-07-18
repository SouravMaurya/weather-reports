import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseConstants {
  static FirebaseFirestore getFireStoreInstance() {
    return FirebaseFirestore.instance;
  }

  static CollectionReference getCollectionReference() {
    return getFireStoreInstance().collection('weathers');
  }
}
