import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:toyshop/MobileApp/admin_edit.dart';
import 'package:toyshop/MobileApp/profile_admin.dart';
import 'add_admin.dart';
import 'order_admin.dart';

class AdminHome extends StatefulWidget {
  final String uid;
  const AdminHome({super.key, required this.uid});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7E9),

      appBar: AppBar(
        title: const Text(
          "Admin Dashboard",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF8B1E3F),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              onChanged: (value) => setState(() => searchQuery = value),
              decoration: InputDecoration(
                hintText: "Search Produk...",
                prefixIcon: const Icon(Icons.search, color: Colors.black54),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFF8B1E3F)),
                ),
              ),
            ),
            const SizedBox(height: 18),

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("daftar_produk")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text("Error memuat data");
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final docs = snapshot.data!.docs;

                  // FILTER by search
                  final filtered = docs.where((doc) {
                    final title = doc['title'].toString().toLowerCase();
                    return title.contains(searchQuery.toLowerCase());
                  }).toList();

                  if (filtered.isEmpty) {
                    return const Center(
                      child: Text(
                        "Tidak ada produk ditemukan",
                        style: TextStyle(fontSize: 18),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final doc = filtered[index];
                      final id = doc.id;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: const Color(0xFF8B1E3F),
                            width: 2,
                          ),
                        ),
                        child: ListTile(
                          title: Text(
                            doc['title'],
                            style: const TextStyle(
                              color: Color(0xFF8B1E3F),
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Color(0xFF8B1E3F),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => EditAdminPage(
                                        docId: id,
                                        data:
                                            doc.data() as Map<String, dynamic>,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  FirebaseFirestore.instance
                                      .collection("daftar_produk")
                                      .doc(id)
                                      .delete();
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFD4AF37),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddAdmin()),
          );
        },
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF8B1E3F),
        selectedItemColor: const Color(0xFFFFD700),
        unselectedItemColor: Colors.white,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrderAdmin(uid: widget.uid),
              ),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileAdmin(uid: widget.uid),
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
