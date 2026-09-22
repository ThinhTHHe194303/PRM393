// TODO 1: Định nghĩa class Vehicle
class Vehicle {
  String brand;
  int year;

  // Default constructor
  Vehicle(this.brand, this.year);

  // Hàm startEngine()
  void startEngine() {
    print("Khởi động phương tiện...");
  }
}

// TODO 2: Định nghĩa class Car kế thừa Vehicle
class Car extends Vehicle {
  bool isElectric;

  // TODO 3: Constructor mặc định
  Car(String brand, int year, bool isElectric)
    : isElectric = isElectric,
      super(brand, year);

  // Named Constructor
  Car.tesla(int year) : isElectric = true, super("Tesla", year);

  // TODO 4: Ghi đè hàm startEngine()
  @override
  void startEngine() {
    if (isElectric) {
      print("$brand ($year): Động cơ điện khởi động êm ái...");
    } else {
      print("$brand ($year): Động cơ xăng khởi động...");
    }
  }
}

void main() {
  // TODO 5: Khởi tạo xe Car bình thường
  Car car1 = Car("Toyota", 2022, false);
  car1.startEngine();

  // TODO 6: Khởi tạo bằng Named Constructor
  Car car2 = Car.tesla(2025);
  car2.startEngine();
}
