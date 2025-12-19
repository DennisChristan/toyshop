import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toyshop/MobileApp/transaksi_web.dart';
import 'cart_provider.dart';

class PaymentPage extends StatefulWidget {
  final String uid;

  const PaymentPage({super.key, required this.uid});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String metodePembayaran = "QRIS";

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFFF7E9),
      appBar: AppBar(
        title: const Text(
          "Pembayaran",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF8B1E3F),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, 
          children: [
            const Text(
              "Metode Pembayaran",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF8B1E3F),
              ),
            ),

            const SizedBox(height: 16),

            // PILIHAN METODE PEMBAYARAN
            paymentOption("QRIS"),
            paymentOption("Transfer Bank"),
            paymentOption("COD"),

            const SizedBox(height: 30),

            const Text(
              "Total Pembayaran:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),

            Text(
              "Rp ${cart.totalHarga}",
              style: const TextStyle(
                fontSize: 24,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Spacer(),

            // TOMBOL BAYAR
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B1E3F),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () async {
                await prosesPembayaran(cart);

                if (mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PembayaranBerhasilPage(uid: widget.uid),
                    ),
                  );
                }
              },
              child: const Text(
                "Bayar Sekarang",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // WIDGET RADIO BUTTON PEMBAYARAN
  Widget paymentOption(String title) {
    return RadioListTile(
      value: title,
      groupValue: metodePembayaran,
      activeColor: const Color(0xFF8B1E3F),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      onChanged: (value) {
        setState(() {
          metodePembayaran = value.toString();
        });
      },
    );
  }

  // PROSES SIMPAN TRANSAKSI
  Future<void> prosesPembayaran(CartProvider cart) async {
    final transaksiRef = FirebaseFirestore.instance
        .collection("transaksi")
        .doc(); // auto id

    // 🔥 KONVERSI ITEM → hanya simpan yg perlu
    List<Map<String, dynamic>> itemsToSave = cart.items.map((item) {
      return {
        "nama": item["title"],
        "productId": item["productId"],
        "qty": item["qty"],
      };
    }).toList();

    await transaksiRef.set({
      "transaksiId": transaksiRef.id,
      "userId": widget.uid,
      "items": itemsToSave, // <— SUDAH TIDAK SIMPAN TITLE/HARGA
      "totalHarga": cart.totalHarga,
      "metodePembayaran": metodePembayaran,
      "tanggal": Timestamp.now(), // <— PERBAIKAN! HARUS TIMESTAMP
      "status": "success",
    });

    cart.clearCart();
  }
}

class PembayaranBerhasilPage extends StatefulWidget {
  final String uid;

  const PembayaranBerhasilPage({super.key, required this.uid});

  @override
  State<PembayaranBerhasilPage> createState() => _PembayaranBerhasilPageState();
}

class _PembayaranBerhasilPageState extends State<PembayaranBerhasilPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => TransaksiWeb(uid: widget.uid)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7E9),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.check_circle, size: 120, color: Colors.green),
            SizedBox(height: 20),
            Text(
              "Pembayaran Berhasil!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
