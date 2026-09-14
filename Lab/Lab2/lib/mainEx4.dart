import 'ex4.dart';

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