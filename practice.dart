class Person {
  String? name;
  int? age;
  String? sex;

  Person({String? name, int? age, String? sex}) {
    this.name = name;
    this.age = age;
    this.sex = sex;
  }
}

addNumber(int num1, int num2) {
  return num1 + num2;
}

void main() {
  Person hyeonmin = Person(name: "hyeonmin", age: 26, sex: "male");

  print(hyeonmin.age);
}
