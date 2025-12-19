
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Core/auth_service.dart';
import '../Core/user_service.dart';
import 'login_mob.dart';

class RegisterWeb extends StatefulWidget {
  const RegisterWeb({super.key});

  @override
  State<RegisterWeb> createState() => _RegisterWebState();
}

class _RegisterWebState extends State<RegisterWeb> {
  final TextEditingController nameC = TextEditingController();
  final TextEditingController emailC = TextEditingController();
  final TextEditingController phoneC = TextEditingController();
  final TextEditingController passC = TextEditingController();
  final TextEditingController confPassC = TextEditingController();

  bool loading = false;

  void register() async {
    if (passC.text != confPassC.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Password tidak cocok!")));
      return;
    }

    try {
      setState(() => loading = true);

      // 1️⃣ Daftar ke FirebaseAuth
      UserCredential userCred = await authService.value.createAccount(
        email: emailC.text.trim(),
        password: passC.text.trim(),
      );

      // 2️⃣ Update displayName
      await authService.value.updaterUsername(username: nameC.text.trim());

      // 4️⃣ Simpan ke Firestore (gunakan UID Firestore, bukan UID Auth)
      await UserService().createUserData(
        email: emailC.text.trim(),
        username: nameC.text.trim(),
        notelp:phoneC.text.trim(),
        role: "user",
      );

      // 5️⃣ Notifikasi
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Akun berhasil dibuat!")));

      // 6️⃣ Pindah ke login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginMob()),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal daftar: $e")));
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7E9),

      appBar: AppBar(
        backgroundColor: const Color(0xFF8B1E3F),
        centerTitle: true,
        title: const Text(
          "Register",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),

      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Daftar Akun",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF8B1E3F),
                      ),
                    ),

                    const SizedBox(height: 30),

                    _buildInput(
                      "Nama Lengkap",
                      Icons.person,
                      controller: nameC,
                    ),
                    const SizedBox(height: 15),

                    _buildInput("Email", Icons.email, controller: emailC),
                    const SizedBox(height: 15),

                    _buildInput(
                      "Nomor Telepon",
                      Icons.phone,
                      controller: phoneC,
                    ),
                    const SizedBox(height: 15),

                    _buildInput(
                      "Password",
                      Icons.lock,
                      controller: passC,
                      obscure: true,
                    ),
                    const SizedBox(height: 15),

                    _buildInput(
                      "Konfirmasi Password",
                      Icons.lock,
                      controller: confPassC,
                      obscure: true,
                    ),
                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8B1E3F),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: loading ? null : register,
                        child: loading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                "Daftar",
                                style: TextStyle(fontSize: 20),
                              ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginMob(),
                          ),
                        );
                      },
                      child: const Text(
                        "Sudah punya akun? Login",
                        style: TextStyle(
                          color: Color(0xFFE85C70),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

  Widget _buildInput(
    String label,
    IconData icon, {
    bool obscure = false,
    required TextEditingController controller,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
