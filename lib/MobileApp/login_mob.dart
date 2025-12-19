import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'menu_mob.dart';
import 'register_web.dart';
import 'admin_menu.dart';
import '../Core/auth_service.dart';
import '../Core/user_service.dart';

class LoginMob extends StatefulWidget {
  const LoginMob({super.key});

  @override
  State<LoginMob> createState() => _LoginMobState();
}

class _LoginMobState extends State<LoginMob> {
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passC = TextEditingController();
  String errorMessage = '';
  bool isLoading = false;

  void login() async {
    try {
      setState(() => isLoading = true);

      UserCredential userCred = await authService.value.signIn(
        email: emailC.text.trim(),
        password: passC.text.trim(),
      );

      String email = userCred.user!.email!;

      // 🔥 Ambil Firestore UID berbasis email
      int? firestoreUid = await UserService().getFirestoreUidByEmail(email);

      if (firestoreUid == null) {
        errorMessage = "Akun belum memiliki data Firestore!";
        setState(() => isLoading = false);
        return;
      }

      // 🔥 Ambil role berdasarkan UID Firestore
      String? role = await UserService().getUserRole(firestoreUid);

      if (role == "admin") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => AdminHome(uid: firestoreUid.toString())),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => MenuMob(uid: firestoreUid.toString()),
          ),
        );
      }
    } on FirebaseAuthException catch (_) {
      errorMessage = 'Login Gagal!';
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7E9),

      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 450),
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: [
                    const Text(
                      "Login Web",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 30),

                    TextField(
                      controller: emailC,
                      decoration: InputDecoration(
                        labelText: "Email",
                        prefixIcon: const Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    TextField(
                      controller: passC,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        prefixIcon: const Icon(Icons.lock),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 35),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8B1E3F),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: isLoading ? null : login,
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                "Login",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 20),
                    Text(errorMessage, style: TextStyle(color: Colors.red)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Belum punya akun?"),
                        TextButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RegisterWeb(),
                            ),
                          ),
                          child: const Text(
                            "Register",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
