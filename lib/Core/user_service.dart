import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// 🔥 Generate Firestore UID otomatis mulai dari 1
  Future<int> generateFirestoreUid() async {
    return await firestore.runTransaction((transaction) async {
      DocumentReference counterRef =
          firestore.collection("metadata").doc("counters");

      DocumentSnapshot counterSnap = await transaction.get(counterRef);

      int current = 0;

      // Jika dokumen belum ada → buat otomatis
      if (!counterSnap.exists) {
        transaction.set(counterRef, {"userCounter": 0});
      } else {
        current = counterSnap.get("userCounter");
      }

      int newId = current + 1;

      // Update counter
      transaction.update(counterRef, {"userCounter": newId});

      return newId;
    });
  }

  /// 🔥 Buat user memakai UID Firestore (bukan Auth UID)
  Future<int> createUserData({
    required String email,
    required String username,
    required String notelp,
    String role = "user",
  }) async {
    int uid = await generateFirestoreUid();

    await firestore.collection("users").doc(uid.toString()).set({
      "uid": uid,
      "email": email,
      "username": username,
      "notelp": notelp,
      "role": role,
    });

    return uid; // optional, kalau mau dipakai
  }

  /// 🔥 Ambil role berdasarkan UID Firestore
  Future<String?> getUserRole(int uid) async {
    var userDoc = await firestore.collection("users").doc(uid.toString()).get();
    return userDoc.data()?["role"];
  }

  /// 🔥 Ambil data user berdasarkan UID Firestore
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    print("DEBUG => fetching users/$uid");
    var doc = await firestore.collection('users').doc(uid.toString()).get();

    if (!doc.exists) {
      print("DEBUG => document does NOT exist");
      return null;
    }

    print("DEBUG => document found: ${doc.data()}");
    return doc.data() as Map<String, dynamic>;
  }
  Future<int?> getFirestoreUidByEmail(String email) async {
  var q = await firestore
      .collection("users")
      .where("email", isEqualTo: email)
      .limit(1)
      .get();

  if (q.docs.isEmpty) return null;

  return q.docs.first.data()["uid"];
}

}
