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
  int day = 3;

  switch (day) {
    case 1:
      print("Monday");
      break;
    case 2:
      print("Tuesday");
      break;
    case 3:
      print("Wednesday");
      break;
    case 4:
      print("Thursday");
      break;
    case 5:
      print("Friday");
      break;
    case 6:
      print("Saturday");
      break;
    case 7:
      print("Sunday");
      break;
    default:
      print("Invalid day");
  }

  List<String> names = ["Alice", "Bob", "Charlie"];

// For loop
  print("For loop: ");
  for (int i = 0; i < names.length; i++) {
    print(names[i]);
  }

// For-in loop
  print("For-in loop: ");
  for (String name in names) {
    print(name);
  }

// For each
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
