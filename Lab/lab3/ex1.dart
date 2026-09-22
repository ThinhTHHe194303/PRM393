import 'dart:async';

class Product {
  final String id, name;
  final double price;
  Product(this.id, this.name, this.price);
}

class ProductRepository {
  // broadcast() allows multiple listeners to subscribe to the same stream
  final _controller = StreamController<Product>.broadcast();
  final List<Product> _items = [];

  // Future: returns the current list once
  Future<List<Product>> getAll() async => _items;

  // Stream: emits a new Product every time one is added
  Stream<Product> liveAdded() => _controller.stream;

  void add(Product p) {
    _items.add(p);
    _controller.add(p); // push the new product into the stream
  }
}

void main() async {
  final repo = ProductRepository();

  // Listen to the stream — this prints immediately every time add() is called
  repo.liveAdded().listen((p) => print('New product: ${p.name}'));

  repo.add(Product('1', 'T-Shirt', 150000));
  repo.add(Product('2', 'Jeans', 350000));

  final all = await repo.getAll(); // await because getAll() returns a Future
  print('Total products: ${all.length}');
}