abstract class Employee {
  String name;

  Employee(this.name);

  void work();
}

// TODO 1: Khai báo mixin CheckInAbility giới hạn cho Employee
mixin CheckInAbility on Employee {
  void checkIn() {
    print("$name đã điểm danh");
  }
}

// TODO 2: Tích hợp mixin CheckInAbility vào class Developer
class Developer extends Employee with CheckInAbility {
  Developer(String name) : super(name);

  @override
  void work() => print("$name đang viết code.");
}

void main() {
  List<Developer> teamA = [
    Developer("An"),
    Developer("Bình")
  ];

  List<Developer> teamB = [
    Developer("Cường")
  ];

  // TODO 3: Dùng Spread Operator (...) để gộp teamA và teamB
  List<Developer> allStaff = [
    ...teamA,
    ...teamB
  ];

  // TODO 4: Gọi checkIn() cho tất cả nhân sự
  for (Developer employee in allStaff) {
    employee.checkIn();
  }
}