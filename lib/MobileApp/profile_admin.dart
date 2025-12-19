import 'package:flutter/material.dart';
import 'package:toyshop/MobileApp/admin_menu.dart';
import 'package:toyshop/MobileApp/order_admin.dart';
import '../Core/user_service.dart';
import 'login_mob.dart';

class ProfileAdmin extends StatefulWidget {
  final String uid;
  const ProfileAdmin({super.key, required this.uid});

  @override
  State<ProfileAdmin> createState() => _ProfileAdminState();
}

class _ProfileAdminState extends State<ProfileAdmin> {
  Map<String, dynamic>? userData;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    print("Fetching data for UID: ${widget.uid}");
    userData = await UserService().getUserData(widget.uid);

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F4EF),

      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFF8B1E3F),
        title: const Text(
          "Profile Diri",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),

                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Data Diri",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 25),

                        // ============================
                        // NAMA USER
                        // ============================
                        const Text(
                          "Nama:",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          userData?["username"] ?? "-",
                          style: const TextStyle(fontSize: 18),
                        ),

                        const SizedBox(height: 20),

                        // ============================
                        // EMAIL USER
                        // ============================
                        const Text(
                          "Email:",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          userData?["email"] ?? "-",
                          style: const TextStyle(fontSize: 18),
                        ),

                        const SizedBox(height: 20),

                        // ============================
                        // NOMOR HP
                        // ============================
                        const Text(
                          "Nomor HP:",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          userData?["notelp"] ?? "-",
                          style: const TextStyle(fontSize: 18),
                        ),

                        const SizedBox(height: 40),

                        // ============================
                        // LOGOUT BUTTON
                        // ============================
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF8B1E3F),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),

                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginMob(),
                                ),
                              );
                            },

                            child: const Text(
                              "Logout",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF8B1E3F),
        selectedItemColor: const Color(0xFFFFD700),
        unselectedItemColor: Colors.white,
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => AdminHome(uid: widget.uid),
              ),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => OrderAdmin(uid: widget.uid),
              ),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: "Orders"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
