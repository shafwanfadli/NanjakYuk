import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> registerUser(
    String email, String password, String username) async {
  try {
    if (email.isEmpty || password.isEmpty || username.isEmpty) {
      throw 'Please enter all fields';
    }

    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    // Ganti ini dengan data yang ingin disimpan di Firestore
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential.user!.uid)
        .set({
      'email': email,
      'username': username,
    });

    print('Registration successful! User ID: ${userCredential.user?.uid}');
  } catch (e) {
    print('Registration failed: $e');
  }
}
