// lib/ui/login_page.dart
import 'package:flutter/material.dart';
import 'package:tokokita/ui/registrasi_page.dart';
import '../services/api_service.dart';
import '../widgets/warning_dialog.dart';
import '../model/login.dart';
import 'produk_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final _emailTextboxController = TextEditingController();
  final _passwordTextboxController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login ZAZA'),
        leading: const Icon(Icons.login),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _emailTextboxController,
                  decoration: const InputDecoration(labelText: "Email"),
                  validator: (v) => v != null && v.contains('@') ? null : "Email tidak valid",
                ),
                TextFormField(
                  controller: _passwordTextboxController,
                  decoration: const InputDecoration(labelText: "Password"),
                  obscureText: true,
                  validator: (v) => v != null && v.isNotEmpty ? null : "Password harus diisi",
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _isLoading ? null : _onLogin,
                  child: _isLoading ? const CircularProgressIndicator() : const Text("Login ZAZA"),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const RegistrasiPage()));
                  },
                  child: const Text("Registrasi ZAZA"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final login = await ApiService.login(_emailTextboxController.text.trim(), _passwordTextboxController.text.trim());
    setState(() => _isLoading = false);

    if (login.status == true && login.code == 200) {
      // lanjut ke produk list
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ProdukPage()));
    } else {
      showDialog(context: context, builder: (_) => WarningDialog(description: "Login gagal"));
    }
  }
}
