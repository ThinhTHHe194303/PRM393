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

void main() {
  //Normal constructor object
  Car car1 = Car("Honda");
  car1.drive();

  //Named constructor object
  Car car2 = Car.defaultCar();
  car2.drive();

  //Electric car object
  ElectricCar car3 = ElectricCar("Tesla", 90);
  car3.drive();
}