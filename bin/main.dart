import 'dart:io';
import 'dart:math';

import 'package:hex/hex.dart';
import 'package:image/image.dart';
import 'package:perceptron/perceptron.dart';

import 'number_predictor.dart';

void main(List<String> arguments) {
  predictNumbers();
}

void main1(List<String> arguments) {
//  final perceptron = Perceptron.fromFile('test_neural.json');
  final origImageFile = File('original.png').readAsBytesSync();
  final origImage = grayscale(decodeImage(origImageFile));
  final targetImageFile = File('transformed.png').readAsBytesSync();
  final targetImage = decodeImage(targetImageFile);
  final perceptron = Perceptron([16, 20, 16], 1);
  final rand = Random();
  final trainData = <TrainingData>[];
  for (var i=0; i<30000; i++) {
    final x = rand.nextInt(origImage.width-4);
    final y = rand.nextInt(origImage.height-4);
    final input = <double>[];
    final output = <double>[];
    for (var j=0; j<4; j++) {
      for (var k=0; k<4; k++) {
        final origPixel = HEX.decode(origImage.getPixel(x+k, y+j).toRadixString(16).substring(2));
        final destPixel = targetImage.getPixel(x+k, y+j).toRadixString(16).substring(2).toLowerCase() == 'ffffff'? 1 : 0;
        input.addAll([origPixel[0].toDouble()/256 - 0.5]);
        output.addAll([destPixel.toDouble()]);
      }
    }
    trainData.add(TrainingData(input, output));
  }
  print('trainData collected');
  perceptron.train(trainData);
  print('network trained');

//  perceptron.saveToFile('img_filter3.json');
}

//void main2(List<String> arguments) {
//  final zero = int.parse('FF000000', radix: 16);
//  final one = int.parse('FFFFFFFF', radix: 16);
//  final perceptron = Perceptron.fromFile('img_filter3.json');
//  print(perceptron.toJson());
//  final origImageFile = File('testimg.jpg').readAsBytesSync();
//  final loadedImage = grayscale(decodeImage(origImageFile));
//  var origImage;
//  if (loadedImage.width <= 1024) {
//    origImage = loadedImage;
//  }
//  else {
//    final scaleFactor = 1024/loadedImage.width;
//    origImage =
//        copyResize(loadedImage, width: (loadedImage.width * scaleFactor).round(), height: (loadedImage.height * scaleFactor).round());
//  }
//  final targetImage = Image(origImage.width, origImage.height);
//  print('${targetImage.width}, ${targetImage.height}');
//  var y = 0;
//  while (y < targetImage.height - 4) {
//    var x = 0;
//    print('x: $x, y: $y');
//    while (x < targetImage.width - 4) {
//      final block = <double>[];
//      for (var j=0; j<4; j++) {
//        for (var k=0; k<4; k++) {
//          final origPixel = HEX.decode(origImage.getPixel(x+k, y+j).toRadixString(16).substring(2));
//          block.addAll([origPixel[0].toDouble()/256 - 0.5]);
//        }
//      }
//      //print(block);
//      final result = perceptron.process(block);
//      //print(result);
//      for (var j=0; j<4; j++) {
//        for (var k=0; k<4; k++) {
//          final pixel = (result[k + j * 4] < 0.5? zero : one);
//          targetImage.setPixel(x+k, y+j, pixel);
//        }
//      }
//      x+=4;
//      if (x > targetImage.width - 4) {
//        x = targetImage.width - 4;
//      }
//    }
//    y+=4;
//    if (y > targetImage.height - 4) {
//      y = targetImage.height - 4;
//    }
//  }
//  File('processed.png').writeAsBytesSync(encodePng(targetImage));
//  print('OK');
//}
