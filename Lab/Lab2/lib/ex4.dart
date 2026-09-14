class Car {
  String brand;

  Car(this.brand);

  //Named constructor
  Car.defaultCar() : brand = "Toyota";

  void drive() {
    print("$brand is driving");
  }
}

class ElectricCar extends Car {
  int battery;

  ElectricCar(super.brand, this.battery);

  @override
  void drive() {
    print("$brand electric car ís driving with $battery% battery");
  }
}
