import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditAdminPage extends StatefulWidget {
  final String docId;
  final Map<String, dynamic> data;

  const EditAdminPage({super.key, required this.docId, required this.data});

  @override
  State<EditAdminPage> createState() => _EditAdminPageState();
}

class _EditAdminPageState extends State<EditAdminPage> {
  late TextEditingController titleC;
  late TextEditingController hargaC;
  late TextEditingController descC;
  late TextEditingController imageC;

  @override
  void initState() {
    super.initState();
    titleC = TextEditingController(text: widget.data['title']);
    hargaC = TextEditingController(text: widget.data['harga']);
    descC = TextEditingController(text: widget.data['description']);
    imageC = TextEditingController(text: widget.data['imageUrl']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7E9),
      appBar: AppBar(
        title: const Text(
          "Edit Produk",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF8B1E3F),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: titleC,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Nama Produk",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: hargaC,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Harga",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: imageC,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "ImageUrl",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: descC,
              maxLines: 3,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Description",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B1E3F),
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection("daftar_produk")
                    .doc(widget.docId)
                    .update({
                      "title": titleC.text,
                      "harga": hargaC.text,
                      "imageUrl": imageC.text,
                      "description": descC.text,
                    });

                Navigator.pop(context);
              },
              child: const Text(
                "Simpan Perubahan",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
