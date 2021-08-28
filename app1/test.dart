import 'dart:math';

dynamic generate(int capacity) {
  List<String> randNum = [
    " press the dice button on the botton right of your screen to generate a list of 1000 numbers "
  ];

  randNum = List.generate(capacity, (_) => Random().nextInt(1500).toString());
  return randNum;
}

void main() {
  print(generate(5));
}
