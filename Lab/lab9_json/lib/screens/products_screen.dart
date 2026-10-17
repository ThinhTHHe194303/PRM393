
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  bool isLoading = true;
  String? error;
  List<dynamic> products = [];

  @override
  void initState() {
    super.initState();
    loadProducts();
  }


  Future<void> loadProducts() async {
    try {
      // Load the JSON file from the assets folder.
      final jsonString = await rootBundle.loadString(
        'assets/data/products.json',
      );

      // Decode the JSON string into a Dart list.
      final List<dynamic> data = jsonDecode(jsonString);

      if (!mounted) return;

      setState(() {
        products = data;
        isLoading = false;
        error = null;
      });
    } catch (e) {
      // Handle errors that occur while loading or decoding JSON.
      if (!mounted) return;

      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 9.1 - Products'),
      ),

      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : error != null
          ? Center(
        child: Text('Error: $error'),
      )
          : products.isEmpty
          ? const Center(
        child: Text('No products found'),
      )
          : ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];

          return Card(
            margin: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            child: ListTile(
              leading: CircleAvatar(
                child: Text(
                  '${product['id']}',
                ),
              ),
              title: Text(
                product['name'].toString(),
              ),
              subtitle: Text(
                'Price: ${product['price']} VND',
              ),
            ),
          );
        },
      ),
    );
  }
}
