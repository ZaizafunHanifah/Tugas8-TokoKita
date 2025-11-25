// lib/ui/produk_page.dart
import 'package:flutter/material.dart';
import '../model/produk.dart';
import '../services/api_service.dart';
import 'produk_detail.dart';
import 'produk_form.dart';

class ProdukPage extends StatefulWidget {
  const ProdukPage({Key? key}) : super(key: key);

  @override
  _ProdukPageState createState() => _ProdukPageState();
}

class _ProdukPageState extends State<ProdukPage> {
  List<Produk> items = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchProduk();
  }

  Future<void> fetchProduk() async {
    setState(() => loading = true);
    final list = await ApiService.listProduk();
    setState(() {
      items = list;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Produk ZAZA'),
        leading: const Icon(Icons.store),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              child: const Icon(Icons.add, size: 26.0),
              onTap: () async {
                final created = await Navigator.push(context, MaterialPageRoute(builder: (context) => ProdukForm()));
                if (created == true) {
                  fetchProduk();
                } else {
                  // always refetch in mock too to see updates
                  fetchProduk();
                }
              },
            ),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: fetchProduk,
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, idx) {
                  final p = items[idx];
                  return GestureDetector(
                    onTap: () async {
                      await Navigator.push(context, MaterialPageRoute(builder: (context) => ProdukDetail(produk: p)));
                      fetchProduk();
                    },
                    child: Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.shopping_bag, color: Colors.purple),
                        title: Text(p.namaProduk ?? "-", style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text("Rp ${p.hargaProduk ?? 0}", style: const TextStyle(color: Colors.green)),
                        trailing: const Icon(Icons.arrow_forward_ios),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
