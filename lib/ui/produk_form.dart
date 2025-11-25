// lib/ui/produk_form.dart
import 'package:flutter/material.dart';
import '../model/produk.dart';
import '../services/api_service.dart';
import '../widgets/warning_dialog.dart';

class ProdukForm extends StatefulWidget {
  final Produk? produk;
  const ProdukForm({Key? key, this.produk}) : super(key: key);

  @override
  _ProdukFormState createState() => _ProdukFormState();
}

class _ProdukFormState extends State<ProdukForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String judul = "TAMBAH PRODUK ZAZA";
  String tombolSubmit = "SIMPAN";

  final _kodeProdukTextboxController = TextEditingController();
  final _namaProdukTextboxController = TextEditingController();
  final _hargaProdukTextboxController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.produk != null) {
      judul = "UBAH PRODUK ZAZA";
      tombolSubmit = "UBAH";
      _kodeProdukTextboxController.text = widget.produk!.kodeProduk ?? '';
      _namaProdukTextboxController.text = widget.produk!.namaProduk ?? '';
      _hargaProdukTextboxController.text = widget.produk!.hargaProduk?.toString() ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(judul),
        leading: const Icon(Icons.edit),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _kodeProdukTextboxController,
                  decoration: const InputDecoration(labelText: "Kode Produk"),
                  validator: (v) => v != null && v.isNotEmpty ? null : "Kode produk harus diisi",
                ),
                TextFormField(
                  controller: _namaProdukTextboxController,
                  decoration: const InputDecoration(labelText: "Nama Produk"),
                  validator: (v) => v != null && v.isNotEmpty ? null : "Nama produk harus diisi",
                ),
                TextFormField(
                  controller: _hargaProdukTextboxController,
                  decoration: const InputDecoration(labelText: "Harga"),
                  keyboardType: TextInputType.number,
                  validator: (v) => v != null && v.isNotEmpty ? null : "Harga harus diisi",
                ),
                const SizedBox(height: 16),
                OutlinedButton(
                  child: _isLoading ? const CircularProgressIndicator() : Text(tombolSubmit + " ZAZA"),
                  onPressed: _isLoading ? null : _onSubmit,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final produk = Produk(
      kodeProduk: _kodeProdukTextboxController.text.trim(),
      namaProduk: _namaProdukTextboxController.text.trim(),
      hargaProduk: int.tryParse(_hargaProdukTextboxController.text.trim()) ?? 0,
    );

    if (widget.produk == null) {
      final res = await ApiService.createProduk(produk);
      setState(() => _isLoading = false);
      if (res != null) {
        Navigator.pop(context, true);
      } else {
        showDialog(context: context, builder: (_) => const WarningDialog(description: "Tambah produk gagal"));
      }
    } else {
      final res = await ApiService.updateProduk(widget.produk!.id!, produk);
      setState(() => _isLoading = false);
      if (res != null) {
        Navigator.pop(context, true);
      } else {
        showDialog(context: context, builder: (_) => const WarningDialog(description: "Ubah produk gagal"));
      }
    }
  }
}
