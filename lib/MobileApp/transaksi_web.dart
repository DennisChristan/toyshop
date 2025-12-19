import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:toyshop/MobileApp/cart_web.dart';
import 'menu_mob.dart';
import 'profile_web.dart';

class TransaksiWeb extends StatefulWidget {
  final String uid;
  const TransaksiWeb({super.key, required this.uid});

  @override
  State<TransaksiWeb> createState() => _TransaksiWebState();
}

class _TransaksiWebState extends State<TransaksiWeb> {
  String? userNumberId; // <-- ID angkanya (contoh: "3")

  @override
  void initState() {
    super.initState();
    loadUserNumberId();
  }

  Future<void> loadUserNumberId() async {
    final snap = await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.uid)
        .get();
    print("USER NUMBER ID = $userNumberId");

    if (snap.exists) {
      setState(() {
        userNumberId = snap.data()?["userId"]; // contoh: "3"
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAEBD7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF8B1E3F),
        centerTitle: true,
        title: const Text(
          "Transaksi",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Color(0xFFFFD700)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartPage(uid: widget.uid),
                ),
              );
            },
          ),
          const SizedBox(width: 12),
        ],
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("transaksi")
            .where("userId", isEqualTo: widget.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "Belum ada transaksi.",
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          final data = snapshot.data!.docs;

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              var tr = data[index];
              var items = tr["items"] as List;

              return Card(
                margin: const EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: items.map((item) {
                          return Text(
                            "${item['qty']}x ${item['nama']}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 8),

                      Text("Metode: ${tr['metodePembayaran']}"),
                      Text(
                        "Status: ${tr['status']}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: tr['status'] == "success"
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),

                      const SizedBox(height: 8),
                      Text(
                        "Total: Rp ${tr['totalHarga']}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF8B1E3F),
        selectedItemColor: const Color(0xFFFFD700),
        unselectedItemColor: Colors.white,
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MenuMob(uid: widget.uid)),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileWeb(uid: widget.uid),
              ),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: "Transaksi",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
