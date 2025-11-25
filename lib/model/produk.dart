// lib/models/produk.dart
class Produk {
  String? id;
  String? kodeProduk;
  String? namaProduk;
  int? hargaProduk;

  Produk({this.id, this.kodeProduk, this.namaProduk, this.hargaProduk});

  factory Produk.fromJson(Map<String, dynamic> obj) {
    return Produk(
      id: obj['id']?.toString(),
      kodeProduk: obj['kode_produk']?.toString(),
      namaProduk: obj['nama_produk']?.toString(),
      hargaProduk: obj['harga'] is String
          ? int.tryParse(obj['harga'])
          : obj['harga'] is int
              ? obj['harga']
              : int.tryParse(obj['harga']?.toString() ?? '0'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'kode_produk': kodeProduk,
      'nama_produk': namaProduk,
      'harga': hargaProduk,
    };
  }
}
