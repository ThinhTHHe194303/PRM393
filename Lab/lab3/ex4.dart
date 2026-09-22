void main() {
  Stream.fromIterable([1, 2, 3, 4, 5])
      .map((n) => n * n) // square each number: 1, 4, 9, 16, 25
      .where((n) => n % 2 == 0) // keep only even numbers: 4, 16
      .listen((n) => print('Result: $n'));
}