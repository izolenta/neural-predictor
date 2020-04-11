import 'package:perceptron/perceptron.dart';

void main(List<String> arguments) {
//  final perceptron = Perceptron.fromFile('test_neural.json');
  final perceptron = Perceptron([3, 5, 4]);
  perceptron.saveToFile('test_neural.json');
  final result = perceptron.process([1, 1, 1]);
  print(result.join(', '));
}
