void main() {
  //Int list
  List<int> numbers = [10, 20, 30, 40, 50];

  print("Original list: $numbers");

  //Access an element using index
  print("First number: ${numbers[0]}");

  //Add element
  numbers.add(60);
  print("After add: $numbers");

  //Remove element
  numbers.remove(20);
  print("After remove: $numbers");

  //Arithmetic operators
  int a = numbers[1];
  int b = numbers[0];

  print("a + b = ${a + b}");
  print("a - b = ${a - b}");
  print("a * b = ${a * b}");
  print("a / b = ${a / b}");

  //Comparison operators
  print("a > b: ${a > b}");
  print("a == b: ${a == b}");

  //Logical AND operator
  bool result = a > 20 && b < 10;
  print("Logical result: $result");

  //Ternary operator
  String message = a > b ? "a is greater" : "b is greater";
  print(message);

  //Set
  Set<int> uniqueNum = {10, 20, 20, 30, 30};
  print("Set: $uniqueNum");

  //Map
  Map<String, int> scores = {"Math": 80, "Programming": 90};

  print("Math score: ${scores["Math"]}");
  print("Programming score: ${scores["Programming"]}");
}
