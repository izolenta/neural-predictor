import 'package:perceptron/perceptron.dart';

void predictNumbers() {
  final data = [
    TrainingData([0,0,0,0,0],[0]),
    TrainingData([0,0,0,0,1],[0]),
    TrainingData([0,0,0,1,0],[0]),
    TrainingData([0,0,0,1,1],[0]),
    TrainingData([0,0,1,0,0],[0]),
    TrainingData([0,0,1,0,1],[0]),
    TrainingData([0,0,1,1,0],[0]),
    TrainingData([0,0,1,1,1],[1]),
    TrainingData([0,1,0,0,0],[0]),
    TrainingData([0,1,0,0,1],[0]),
    TrainingData([0,1,0,1,0],[0]),
    TrainingData([0,1,0,1,1],[1]),
//    TrainingData([0,1,1,0,0],[0]),
    TrainingData([0,1,1,0,1],[1]),
    TrainingData([0,1,1,1,0],[1]),
    TrainingData([0,1,1,1,1],[1]),
    TrainingData([1,0,0,0,0],[0]),
    TrainingData([1,0,0,0,1],[0]),
//    TrainingData([1,0,0,1,0],[0]),
    TrainingData([1,0,0,1,1],[1]),
    TrainingData([1,0,1,0,0],[0]),
//    TrainingData([1,0,1,0,1],[1]),
    TrainingData([1,0,1,1,0],[1]),
    TrainingData([1,0,1,1,1],[1]),
//    TrainingData([1,1,0,0,0],[0]),
    TrainingData([1,1,0,0,1],[1]),
    TrainingData([1,1,0,1,0],[1]),
    TrainingData([1,1,0,1,1],[1]),
    TrainingData([1,1,1,0,0],[1]),
    TrainingData([1,1,1,0,1],[1]),
    TrainingData([1,1,1,1,0],[1]),
    TrainingData([1,1,1,1,1],[1]),
  ];

  final perceptron = Perceptron([5, 4, 1], 1);
  for (var i=0; i<1000; i++) {
    perceptron.train(data);
  }
  print('network trained');
  var input = <double>[1,0,1,0,1];
  print('Array $input: prediction: ${perceptron.process(input)}');
  input = <double>[0,1,1,0,0];
  print('Array $input: prediction: ${perceptron.process(input)}');
}