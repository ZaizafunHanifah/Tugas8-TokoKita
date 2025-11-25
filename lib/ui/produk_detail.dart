// lib/ui/produk_detail.dart
import 'package:flutter/material.dart';
import '../model/produk.dart';
import '../services/api_service.dart';
import 'produk_form.dart';
import 'produk_page.dart';
import '../widgets/warning_dialog.dart';

class ProdukDetail extends StatefulWidget {
  final Produk produk;
  const ProdukDetail({Key? key, required this.produk}) : super(key: key);

  @override
  _ProdukDetailState createState() => _ProdukDetailState();
}

class _ProdukDetailState extends State<ProdukDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Produk ZAZA'),
        leading: const Icon(Icons.info),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.code, color: Colors.purple),
                        const SizedBox(width: 8),
                        Text("Kode : ${widget.produk.kodeProduk}", style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.label, color: Colors.purple),
                        const SizedBox(width: 8),
                        Text("Nama : ${widget.produk.namaProduk}", style: const TextStyle(fontSize: 18.0)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.attach_money, color: Colors.green),
                        const SizedBox(width: 8),
                        Text("Harga : Rp. ${widget.produk.hargaProduk}", style: const TextStyle(fontSize: 18.0, color: Colors.green)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            _tombolHapusEdit()
          ],
        ),
      ),
    );
  }

  Widget _tombolHapusEdit() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        OutlinedButton(
          child: const Text("EDIT ZAZA"),
          onPressed: () async {
            final changed = await Navigator.push(context, MaterialPageRoute(builder: (context) => ProdukForm(produk: widget.produk)));
            if (changed == true) {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ProdukPage()));
            }
          },
        ),
        const SizedBox(width: 12),
        OutlinedButton(
          child: const Text("DELETE ZAZA"),
          onPressed: () => confirmHapus(),
        ),
      ],
    );
  }

  void confirmHapus() {
    AlertDialog alertDialog = AlertDialog(
      content: const Text("Yakin ingin menghapus data ini?"),
      actions: [
        OutlinedButton(
          child: const Text("Ya"),
          onPressed: () async {
            Navigator.pop(context); // tutup dialog
            final ok = await ApiService.deleteProduk(widget.produk.id!);
            if (ok) {
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const ProdukPage()));
            } else {
              showDialog(context: context, builder: (BuildContext context) => const WarningDialog(description: "Hapus gagal, silahkan coba lagi"));
            }
          },
        ),
        OutlinedButton(child: const Text("Batal"), onPressed: () => Navigator.pop(context)),
      ],
    );

    showDialog(builder: (context) => alertDialog, context: context);
  }
}
