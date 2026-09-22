Future<void> main() async {
  // Simulate loading data for 2 seconds
  String data = await Future.delayed(
    Duration(seconds: 2),
    () => "Data loaded successfully",
  );

  print(data);

  //null safety
  String? username;

  //Default value
  String displayName = username ?? "Guest";

  print("Displayed name:$displayName");

  //Assign value
  username ="Thinh";
  //! means username is not null
  print("Username: ${username!}");

  //Stream of int
  Stream<int> numberStream = Stream.fromIterable([1,2,3,4,5]);
  
  print("Stream values: ");
  await for (int number in numberStream){
    print(number);
  }

  print("Finished");
}
