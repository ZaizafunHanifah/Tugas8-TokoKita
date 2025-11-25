// lib/ui/registrasi_page.dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/warning_dialog.dart';
import '../model/registrasi.dart';

class RegistrasiPage extends StatefulWidget {
  const RegistrasiPage({Key? key}) : super(key: key);

  @override
  _RegistrasiPageState createState() => _RegistrasiPageState();
}

class _RegistrasiPageState extends State<RegistrasiPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final _namaTextboxController = TextEditingController();
  final _emailTextboxController = TextEditingController();
  final _passwordTextboxController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registrasi ZAZA"),
        leading: const Icon(Icons.person_add),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _namaTextboxController,
                  decoration: const InputDecoration(labelText: "Nama"),
                  validator: (v) => v != null && v.length >= 3 ? null : "Nama minimal 3 karakter",
                ),
                TextFormField(
                  controller: _emailTextboxController,
                  decoration: const InputDecoration(labelText: "Email"),
                  validator: (v) => v != null && v.contains('@') ? null : "Email tidak valid",
                ),
                TextFormField(
                  controller: _passwordTextboxController,
                  decoration: const InputDecoration(labelText: "Password"),
                  obscureText: true,
                  validator: (v) => v != null && v.length >= 6 ? null : "Password minimal 6 karakter",
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _isLoading ? null : _onRegistrasi,
                  child: _isLoading ? const CircularProgressIndicator() : const Text("Registrasi ZAZA"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onRegistrasi() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final res = await ApiService.registrasi(
      _namaTextboxController.text.trim(),
      _emailTextboxController.text.trim(),
      _passwordTextboxController.text.trim(),
    );

    setState(() => _isLoading = false);
    if (res.status == true) {
      // sukses
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Sukses"),
          content: Text(res.data ?? "Registrasi berhasil"),
          actions: [
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context); // kembali
              },
              child: const Text("OK"),
            )
          ],
        ),
      );
    } else {
      showDialog(context: context, builder: (_) => WarningDialog(description: res.data ?? "Registrasi gagal"));
    }
  }
}
