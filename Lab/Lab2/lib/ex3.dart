void main() {
  int score = 85;

  //If/else
  if (score >= 80) {
    print("Grade A");
  } else if (score >= 60) {
    print("Grade B");
  } else {
    print("Grade C");
  }

  //Switch
  int gender = 1;
  switch (gender) {
    case 1:
      print("Male");
      break;

    case 2:
      print("Female");
      break;

    default:
      print("Other");
      break;
  }

  List<String> names = ["Alice", "Bob", "Charlie"];

  //For-in loop
  print("For-in loop: ");
  for (String name in names) {
    print(name);
  }

  //For each
  print("For each: ");
  names.forEach((name) {
    print(name);
  });

  //Normal function
  int addNumbers(int a, int b) {
    return a + b;
  }

  print(addNumbers(3, 6));

  //Arrow function
  int multiplyNumbers(int a, int b) => a * b;
  print(multiplyNumbers(6, 9));
}
