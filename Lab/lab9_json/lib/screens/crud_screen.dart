
import 'package:flutter/material.dart';

import '../services/storage_service.dart';

class CrudScreen extends StatefulWidget {
  const CrudScreen({super.key});

  @override
  State<CrudScreen> createState() => _CrudScreenState();
}

class _CrudScreenState extends State<CrudScreen> {
  final StorageService storage = StorageService();

  List<dynamic> products = [];
  bool isLoading = true;
  bool isSaving = false;
  String? error;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();

    // Load saved products when the screen starts.
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

  // Filter products by name.
  List<dynamic> get filteredProducts {
    if (searchQuery.trim().isEmpty) {
      return products;
    }

    return products.where((product) {
      final name = product['name'].toString().toLowerCase();
      return name.contains(searchQuery.trim().toLowerCase());
    }).toList();
  }

  // Save the current product list to local JSON storage.
  Future<void> saveProducts() async {
    if (isSaving) return;

    setState(() {
      isSaving = true;
    });

    try {
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

  // Show a dialog for creating a new product.
  Future<void> addProduct() async {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final newProduct = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Add Product'),
          content: SingleChildScrollView(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Product name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a product name.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: priceController,
                  keyboardType:
                  const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Product price',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    final price = double.tryParse(
                      value?.trim() ?? '',
                    );

                    if (price == null || price < 0) {
                      return 'Enter a valid non-negative price.';
                    }

                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (!formKey.currentState!.validate()) {
                  return;
                }

                Navigator.pop(dialogContext, {
                  'name': nameController.text.trim(),
                  'price': double.parse(
                    priceController.text.trim(),
                  ),
                });
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );

    // Dispose the temporary form controllers.
    nameController.dispose();
    priceController.dispose();

    if (newProduct == null || !mounted) return;

    // Generate an ID greater than the existing product IDs.
    final ids = products.map(
          (product) => (product['id'] as num).toInt(),
    );

    final nextId = ids.isEmpty
        ? 1
        : ids.reduce((a, b) => a > b ? a : b) + 1;

    setState(() {
      products.add({
        'id': nextId,
        'name': newProduct['name'],
        'price': newProduct['price'],
      });
    });

    // Automatically save the updated list.
    await saveProducts();
  }


  // Show a dialog for editing an existing product.
  Future<void> editProduct(Map<String, dynamic> product) async {
    final updatedProduct = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (dialogContext) {
        return EditProductDialog(product: product);
      },
    );

    if (updatedProduct == null || !mounted) return;

    // Update the selected product.
    final index = products.indexWhere(
          (item) => item['id'] == product['id'],
    );

    if (index == -1) return;

    setState(() {
      products[index] = updatedProduct;
    });

    // Save the updated list to local JSON storage.
    await saveProducts();
  }

  // Delete a product after user confirmation.
  Future<void> deleteProduct(Map<String, dynamic> product) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Product'),
          content: Text(
            'Are you sure you want to delete '
                '"${product['name']}"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    // Stop if the user cancels the operation.
    if (confirmed != true || !mounted) return;

    // Remove the selected product.
    setState(() {
      products.removeWhere(
            (item) => item['id'] == product['id'],
      );
    });

    // Automatically save the updated list.
    await saveProducts();
  }


  @override
  Widget build(BuildContext context) {
    final displayedProducts = filteredProducts;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 9.3 - CRUD Database'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: isLoading || error != null || isSaving
            ? null
            : addProduct,
        tooltip: 'Add Product',
        child: const Icon(Icons.add),
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : error != null
          ? Center(
        child: Text('Error: $error'),
      )
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search products',
                hintText: 'Enter a product name',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      searchQuery = '';
                    });
                  },
                )
                    : null,
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: displayedProducts.isEmpty
                ? Center(
              child: Text(
                searchQuery.isEmpty
                    ? 'No products found.'
                    : 'No matching products found.',
              ),
            )
                : ListView.builder(
              itemCount: displayedProducts.length,
              itemBuilder: (context, index) {
                final product =
                displayedProducts[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),

                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text('${product['id']}'),
                    ),
                    title: Text(product['name'].toString()),
                    subtitle: Text('Price: ${product['price']} VND'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          tooltip: 'Edit Product',
                          onPressed: isSaving
                              ? null
                              : () => editProduct(
                            Map<String, dynamic>.from(product),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          tooltip: 'Delete Product',
                          onPressed: isSaving
                              ? null
                              : () => deleteProduct(
                            Map<String, dynamic>.from(product),
                          ),
                        ),
                      ],
                    ),
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
class EditProductDialog extends StatefulWidget {
  final Map<String, dynamic> product;

  const EditProductDialog({
    super.key,
    required this.product,
  });

  @override
  State<EditProductDialog> createState() =>
      _EditProductDialogState();
}

class _EditProductDialogState extends State<EditProductDialog> {
  late final TextEditingController nameController;
  late final TextEditingController priceController;

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(
      text: widget.product['name'].toString(),
    );

    priceController = TextEditingController(
      text: widget.product['price'].toString(),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Product'),
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Product Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter product name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: priceController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final price = double.tryParse(value?.trim() ?? '');

                  if (price == null || price < 0) {
                    return 'Enter a valid price';
                  }

                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (!formKey.currentState!.validate()) return;

            final updatedProduct = Map<String, dynamic>.from(
              widget.product,
            );

            updatedProduct['name'] = nameController.text.trim();
            updatedProduct['price'] =
                double.parse(priceController.text.trim());

            Navigator.pop(context, updatedProduct);
          },
          child: const Text('Update'),
        ),
      ],
    );
  }
}
