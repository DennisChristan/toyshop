import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddAdmin extends StatefulWidget {
  const AddAdmin({super.key});

  @override
  State<AddAdmin> createState() => _AddAdminState();
}

class _AddAdminState extends State<AddAdmin> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController hargaController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();
  final TextEditingController imageController = TextEditingController();

  bool isLoading = false;

  Future<void> simpanBarang() async {
    String nama = namaController.text.trim();
    String harga = hargaController.text.trim();
    String deskripsi = deskripsiController.text.trim();
    String imageUrl = imageController.text.trim();

    if (nama.isEmpty ||
        harga.isEmpty ||
        deskripsi.isEmpty ||
        imageUrl.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Semua field harus diisi!")));
      return;
    }

    setState(() => isLoading = true);

    try {
      await FirebaseFirestore.instance.collection("daftar_produk").add({
        "title": nama,
        "harga": harga,
        "description": deskripsi,
        "imageUrl": imageUrl,
        "created_at": Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Barang berhasil ditambahkan!")),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7E9),

      appBar: AppBar(
        backgroundColor: const Color(0xFF8B1E3F),
        title: const Text(
          "Tambah Barang",
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: namaController,
              decoration: InputDecoration(
                labelText: "Nama Barang",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 15),

            TextField(
              controller: hargaController,
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
              controller: deskripsiController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: "Deskripsi",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 15),

            TextField(
              controller: imageController,
              decoration: InputDecoration(
                labelText: "URL Gambar (imageUrl)",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B1E3F),
                ),
                onPressed: isLoading ? null : simpanBarang,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Simpan",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
