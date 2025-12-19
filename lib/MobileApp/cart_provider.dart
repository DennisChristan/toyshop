import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _items = [];

  List<Map<String, dynamic>> get items => _items;

  int get totalHarga {
  return _items.fold(0, (total, item) {
    final harga = int.tryParse(item['harga'].toString()) ?? 0;
    return total + (harga * item['qty']).toInt();
  });
}



  void addToCart(Map<String, dynamic> product) {
    final index = _items.indexWhere((e) => e['productId'] == product['productId']);

    if (index >= 0) {
      _items[index]['qty']++;
    } else {
      _items.add({
        "productId": product["productId"],
        "title": product["title"],
        "harga": product["harga"],
        "imageUrl": product["imageUrl"],
        "qty": 1,
      });
    }

    notifyListeners();
  }

  void increaseQty(String productId) {
    final index = _items.indexWhere((e) => e['productId'] == productId);
    _items[index]['qty']++;
    notifyListeners();
  }

  void decreaseQty(String productId) {
  final index = items.indexWhere((item) => item['productId'] == productId);

  if (index != -1) {
    items[index]['qty']--;

    // Jika qty sudah 0 → hapus item
    if (items[index]['qty'] <= 0) {
      items.removeAt(index);
    }

    notifyListeners();
  }
}


  void removeItem(String productId) {
    _items.removeWhere((item) => item['productId'] == productId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
