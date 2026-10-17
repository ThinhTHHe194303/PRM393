
import 'package:flutter/material.dart';

import '../services/storage_service.dart';

class StorageScreen extends StatefulWidget {
  const StorageScreen({super.key});

  @override
  State<StorageScreen> createState() => _StorageScreenState();
}

class _StorageScreenState extends State<StorageScreen> {
  final StorageService storage = StorageService();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  List<dynamic> products = [];
  bool isLoading = true;
  bool isSaving = false;
  String? error;

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    try {
      final data = await storage.loadData();

      if (!mounted) return;

      setState(() {
        products = data;
        isLoading = false;
        error = null;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  void addProduct() {
    final name = nameController.text.trim();
    final price = double.tryParse(priceController.text.trim());

    if (name.isEmpty || price == null || price < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter a valid product name and price.'),
        ),
      );
      return;
    }

    // Generate a new ID based on the largest existing ID.
    final ids = products
        .map((product) => (product['id'] as num).toInt())
        .toList();

    final nextId = ids.isEmpty
        ? 1
        : ids.reduce((a, b) => a > b ? a : b) + 1;

    setState(() {
      products.add({
        'id': nextId,
        'name': name,
        'price': price,
      });

      nameController.clear();
      priceController.clear();
    });
  }

  Future<void> saveProducts() async {
    setState(() {
      isSaving = true;
    });

    try {
      // Save the current product list to the local JSON file.
      await storage.saveData(products);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Products saved successfully!'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save products: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 9.2 - Local Storage'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
          ? Center(child: Text('Error: $error'))
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Product name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: priceController,
                  keyboardType:
                  const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Product price',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: addProduct,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Product'),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: isSaving ? null : saveProducts,
                    icon: isSaving
                        ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                        : const Icon(Icons.save),
                    label: Text(
                      isSaving ? 'Saving...' : 'Save Data',
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: products.isEmpty
                ? const Center(
              child: Text('No products yet.'),
            )
                : ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];

                return ListTile(
                  leading: CircleAvatar(
                    child: Text('${product['id']}'),
                  ),
                  title: Text(
                    product['name'].toString(),
                  ),
                  subtitle: Text(
                    'Price: ${product['price']} VND',
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
