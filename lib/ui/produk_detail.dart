// lib/ui/produk_detail.dart
import 'package:flutter/material.dart';
import '../model/produk.dart';
import '../bloc/produk_bloc.dart';
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
        title: const Text('Product Detail'),
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green, Colors.white],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.white, Colors.greenAccent],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.code, color: Colors.white),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              "Code: ${widget.produk.kodeProduk}",
                              style: const TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.label, color: Colors.white),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              "Name: ${widget.produk.namaProduk}",
                              style: const TextStyle(
                                fontSize: 18.0,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.attach_money, color: Colors.white),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              "Price: Rp ${widget.produk.hargaProduk}",
                              style: const TextStyle(
                                fontSize: 18.0,
                                color: Colors.green,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              _tombolHapusEdit()
            ],
          ),
        ),
      ),
    );
  }

  Widget _tombolHapusEdit() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () async {
              var result = await Navigator.push(context, MaterialPageRoute(builder: (context) => ProdukForm(produk: widget.produk)));
              if (result == true) {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ProdukPage()));
              }
            },
            icon: const Icon(Icons.edit, color: Colors.white),
            label: const Text("Edit", style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => confirmHapus(),
            icon: const Icon(Icons.delete, color: Colors.white),
            label: const Text("Delete", style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
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
            try {
              bool result = await ProdukBloc.deleteProduk(id: int.parse(widget.produk.id!));
              if (result) {
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const ProdukPage()));
              } else {
                showDialog(context: context, builder: (BuildContext context) => const WarningDialog(description: "Hapus gagal, silahkan coba lagi"));
              }
            } catch (e) {
              showDialog(context: context, builder: (BuildContext context) => WarningDialog(description: "Terjadi kesalahan: $e"));
            }
          },
        ),
        OutlinedButton(child: const Text("Batal"), onPressed: () => Navigator.pop(context)),
      ],
    );

    showDialog(builder: (context) => alertDialog, context: context);
  }
}
