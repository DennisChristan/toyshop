import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:toyshop/MobileApp/profile_admin.dart';
import 'admin_menu.dart';

class OrderAdmin extends StatelessWidget {
  final String uid;
  const OrderAdmin({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7E9),

      appBar: AppBar(
        backgroundColor: const Color(0xFF8B1E3F),
        title: const Text(
          "Semua Transaksi",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("transaksi")
            .orderBy("tanggal", descending: true) // terbaru di atas
            .snapshots(),
        builder: (context, snapshot) {
          // jika tidak ada data sama sekali
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "Belum ada transaksi",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            );
          }

          final data = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: data.length,
            itemBuilder: (context, index) {
              var tr = data[index];

              var items = tr["items"] as List;
              var total = tr["totalHarga"];
              var metode = tr["metodePembayaran"];
              var status = tr["status"];
              var userId = tr["userId"];

              return Card(
                elevation: 5,
                margin: const EdgeInsets.only(bottom: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Transaksi ID: ${tr.id}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        "User: $userId",
                        style: const TextStyle(fontSize: 14),
                      ),

                      const SizedBox(height: 6),

                      // daftar item dibeli
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: items.map((item) {
                          return Text(
                            "${item['qty']}x ${item['nama']}",
                            style: const TextStyle(fontSize: 16),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        "Metode: $metode",
                        style: const TextStyle(fontSize: 14),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        "Status: $status",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: status == "success"
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        "Total: Rp $total",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
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

      bottomNavigationBar: _adminNav(context, 1),
    );
  }

  BottomNavigationBar _adminNav(BuildContext context, int current) {
    return BottomNavigationBar(
      currentIndex: current,
      backgroundColor: const Color(0xFF8B1E3F),
      selectedItemColor: const Color(0xFFD4AF37),
      unselectedItemColor: Colors.white,
      onTap: (index) {
        if (index == 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => AdminHome(uid: uid)),
          );
        } else if (index == 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => OrderAdmin(uid: uid)),
          );
        } else if (index == 2) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => ProfileAdmin(uid: uid)),
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
    );
  }
}
