import 'dart:convert';
import 'dart:io';

import 'package:perceptron/perceptron.dart';

void predictNumbers() {
  final data = [
    TrainingData([0,0,0,0,0],[0]),  //1
    TrainingData([0,0,0,0,1],[0]),  //2
    TrainingData([0,0,0,1,0],[0]),  //3
    TrainingData([0,0,0,1,1],[0]),  //4
    TrainingData([0,0,1,0,0],[0]),  //5
    TrainingData([0,0,1,0,1],[0]),  //6
    TrainingData([0,0,1,1,0],[0]),  //7
    TrainingData([0,0,1,1,1],[1]),  //8
    TrainingData([0,1,0,0,0],[0]),  //9
    TrainingData([0,1,0,0,1],[0]),  //10
    TrainingData([0,1,0,1,0],[0]),  //11
    TrainingData([0,1,0,1,1],[1]),  //12
    TrainingData([0,1,1,0,0],[0]),  //13
    TrainingData([0,1,1,0,1],[1]),  //14
    TrainingData([0,1,1,1,0],[1]),  //15
    TrainingData([0,1,1,1,1],[1]),  //16
    TrainingData([1,0,0,0,0],[0]),  //17
    TrainingData([1,0,0,0,1],[0]),  //18
    TrainingData([1,0,0,1,0],[0]),  //19
    TrainingData([1,0,0,1,1],[1]),  //20
    TrainingData([1,0,1,0,0],[0]),  //21
    TrainingData([1,0,1,0,1],[1]),  //22
    TrainingData([1,0,1,1,0],[1]),  //23
    TrainingData([1,0,1,1,1],[1]),  //24
    TrainingData([1,1,0,0,0],[0]),  //25
    TrainingData([1,1,0,0,1],[1]),  //26
    TrainingData([1,1,0,1,0],[1]),  //27
    TrainingData([1,1,0,1,1],[1]),  //28
    TrainingData([1,1,1,0,0],[1]),  //29
    TrainingData([1,1,1,0,1],[1]),  //30
    TrainingData([1,1,1,1,0],[1]),  //31
    TrainingData([1,1,1,1,1],[1]),  //32
  ];

  final perceptron = Perceptron([5, 4, 1], 1);
  for (var i=0; i<1000; i++) {
    perceptron.train(data);
  }
  print('network trained');
  while (true) {
    print('enter input data:');
    var line = stdin.readLineSync(encoding: Encoding.getByName('utf-8'));
    if (line == '\n') {
      break;
    }
    var input = line.split(' ').map((n) => double.parse(n)).toList();
    final result = perceptron.process(input);
    final output = result.first < 0.1? '0 > 1' : result.first > 0.9? '1 > 0' : ' == ';
    print('Array $input: prediction: $output (calculated value: $result)');
  }
}