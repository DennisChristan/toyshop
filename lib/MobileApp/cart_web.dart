import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toyshop/MobileApp/menu_mob.dart';
import 'package:toyshop/MobileApp/pembayaran.dart';
import 'package:toyshop/MobileApp/profile_web.dart';
import 'package:toyshop/MobileApp/transaksi_web.dart'; // <--- Tambahkan ini
import 'cart_provider.dart';

class CartPage extends StatelessWidget {
  final String uid;

  const CartPage({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFFF7E9),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF8B1E3F),
        centerTitle: true,
        title: const Text(
          "Keranjang",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
      ),

      body: cart.items.isEmpty
          ? const Center(
              child: Text(
                "Keranjang masih kosong",
                style: TextStyle(fontSize: 18, color: Color(0xFF8B1E3F)),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
              itemCount: cart.items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = cart.items[index];

                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAEBD7),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: const Color(0xFF8B1E3F),
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.shopping_bag,
                        size: 40,
                        color: Color(0xFFD4AF37),
                      ),
                      const SizedBox(width: 14),

                      Expanded(
                        child: Text(
                          item["title"],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF8B1E3F),
                          ),
                        ),
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Rp ${item['harga']}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF8B1E3F),
                            ),
                          ),

                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.remove,
                                  color: Color(0xFF8B1E3F),
                                ),
                                onPressed: () =>
                                    cart.decreaseQty(item['productId']),
                              ),

                              Text(
                                item['qty'].toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF8B1E3F),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              IconButton(
                                icon: const Icon(
                                  Icons.add,
                                  color: Color(0xFF8B1E3F),
                                ),
                                onPressed: () =>
                                    cart.increaseQty(item['productId']),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),

      // ===========================
      // 🟨 BOTTOM BUTTON PEMBAYARAN
      // ===========================
      bottomSheet: cart.items.isEmpty
          ? const SizedBox()
          : Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFF8B1E3F),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total: Rp ${cart.totalHarga}",
                      style: const TextStyle(
                        fontSize: 18,
                        color: Color(0xFFD4AF37),
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD4AF37),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PaymentPage(uid: uid),
                          ),
                        );
                      },
                      child: const Text(
                        "Lanjut Pembayaran",
                        style: TextStyle(
                          color: Color(0xFF8B1E3F),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF8B1E3F),
        selectedItemColor: const Color(0xFFD4AF37),
        unselectedItemColor: Colors.white,
        currentIndex: 0,

        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => MenuMob(uid: uid)),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => TransaksiWeb(uid: uid)),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => ProfileWeb(uid: uid)),
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
