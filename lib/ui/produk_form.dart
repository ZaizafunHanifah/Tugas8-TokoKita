// lib/ui/produk_form.dart
import 'package:flutter/material.dart';
import '../model/produk.dart';
import '../bloc/produk_bloc.dart';
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
  String judul = "TAMBAH PRODUK";
  String tombolSubmit = "SIMPAN";

  final _kodeProdukTextboxController = TextEditingController();
  final _namaProdukTextboxController = TextEditingController();
  final _hargaProdukTextboxController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.produk != null) {
      judul = "UBAH PRODUK";
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
        backgroundColor: Colors.orange,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.orange, Colors.white],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        widget.produk == null ? Icons.add_box : Icons.edit,
                        size: 80,
                        color: Colors.orange,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        judul,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                      const SizedBox(height: 32),
                      TextFormField(
                        controller: _kodeProdukTextboxController,
                        decoration: InputDecoration(
                          labelText: "Product Code",
                          prefixIcon: const Icon(Icons.code),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                        validator: (v) => v != null && v.isNotEmpty ? null : "Kode produk harus diisi",
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _namaProdukTextboxController,
                        decoration: InputDecoration(
                          labelText: "Product Name",
                          prefixIcon: const Icon(Icons.label),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                        validator: (v) => v != null && v.isNotEmpty ? null : "Nama produk harus diisi",
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _hargaProdukTextboxController,
                        decoration: InputDecoration(
                          labelText: "Price",
                          prefixIcon: const Icon(Icons.attach_money),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                        keyboardType: TextInputType.number,
                        validator: (v) => v != null && v.isNotEmpty ? null : "Harga harus diisi",
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _onSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : Text(
                                  tombolSubmit,
                                  style: const TextStyle(fontSize: 18, color: Colors.white),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    Produk produk = Produk(
      kodeProduk: _kodeProdukTextboxController.text.trim(),
      namaProduk: _namaProdukTextboxController.text.trim(),
      hargaProduk: int.tryParse(_hargaProdukTextboxController.text.trim()) ?? 0,
    );

    if (widget.produk == null) {
      try {
        await ProdukBloc.addProduk(produk: produk);
        Navigator.pop(context, true);
      } catch (e) {
        showDialog(context: context, builder: (_) => WarningDialog(description: "Tambah produk gagal"));
      }
    } else {
      produk.id = widget.produk!.id;
      try {
        await ProdukBloc.updateProduk(produk: produk);
        Navigator.pop(context, true);
      } catch (e) {
        showDialog(context: context, builder: (_) => WarningDialog(description: "Ubah produk gagal"));
      }
    }
    setState(() => _isLoading = false);
  }
}
