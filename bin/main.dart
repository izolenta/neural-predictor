import 'dart:io';
import 'dart:math';

import 'package:hex/hex.dart';
import 'package:image/image.dart';
import 'package:perceptron/perceptron.dart';

//final data = [
//  TrainingData([1,1,1,1],[0,0,0,0]),
//  TrainingData([1,0,0,1],[0,1,1,0]),
//  TrainingData([0,1,1,1],[1,0,0,0]),
//  TrainingData([0,0,0,0],[1,1,1,1]),
//  TrainingData([1,1,0,0],[0,0,1,1]),
//  TrainingData([1,0,0,0],[0,1,1,1]),
//  TrainingData([0,1,1,0],[1,0,0,1]),
//  TrainingData([0,0,0,1],[1,1,1,0]),
//  TrainingData([1,1,0,1],[0,0,1,0]),
//  TrainingData([0,1,0,1],[1,0,1,0]),
//  TrainingData([0,0,1,1],[1,1,0,0]),
//];

//final data = [
//  TrainingData([0], [0, 0]),
//  TrainingData([1], [1/10000000, 0]),
//  TrainingData([2], [1/10000000, 0]),
//  TrainingData([3], [3/10000000, 0]),
//  TrainingData([4], [4/10000000, 0]),
//  TrainingData([5], [7/10000000, 0]),
//  TrainingData([6], [7/10000000, 0]),
//  TrainingData([7], [6/10000000, 0]),
//  TrainingData([8], [6/10000000, 0]),
//  TrainingData([9], [25/10000000, 0]),
//  TrainingData([10], [31/10000000, 0]),
//  TrainingData([11], [22/10000000, 0]),
//  TrainingData([12], [25/10000000, 0]),
//  TrainingData([13], [48/10000000, 0]),
//  TrainingData([14], [104/10000000, 0]),
//  TrainingData([15], [51/10000000, 0]),
//  TrainingData([16], [90/10000000, 0]),
//  TrainingData([17], [88/10000000, 0]),
//  TrainingData([18], [172/10000000, 0]),
//  TrainingData([19], [139/10000000, 0]),
//  TrainingData([20], [162/10000000, 0]),
//  TrainingData([21], [125/10000000, 1/10000000]),
//  TrainingData([22], [116/10000000, 0]),
//  TrainingData([23], [158/10000000, 2/10000000]),
//  TrainingData([24], [260/10000000, 3/10000000]),
//  TrainingData([25], [271/10000000, 3/10000000]),
//  TrainingData([26], [354/10000000, 0]),
//  TrainingData([27], [352/10000000, 2/10000000]),
//  TrainingData([28], [186/10000000, 5/10000000]),
//  TrainingData([29], [184/10000000, 7/10000000]),
//  TrainingData([31], [281/10000000, 8/10000000]),
//  TrainingData([32], [269/10000000, 5/10000000]),
//  TrainingData([33], [332/10000000, 9/10000000]),
//  TrainingData([34], [282/10000000, 6/10000000]),
//  TrainingData([35], [115/10000000, 8/10000000]),
//  TrainingData([36], [235/10000000, 11/10000000]),
//  TrainingData([37], [195/10000000, 10/10000000]),
//  TrainingData([38], [295/10000000, 11/10000000]),
//  TrainingData([39], [257/10000000, 13/10000000]),
//  TrainingData([40], [163/10000000, 7/10000000]),
//];
void main1(List<String> arguments) {
//  final perceptron = Perceptron.fromFile('test_neural.json');
  final origImageFile = File('original.png').readAsBytesSync();
  final origImage = grayscale(decodeImage(origImageFile));
  final targetImageFile = File('transformed.png').readAsBytesSync();
  final targetImage = decodeImage(targetImageFile);
  final perceptron = Perceptron([16, 20, 16]);
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

  perceptron.saveToFile('img_filter3.json');
}

void main(List<String> arguments) {
  final zero = int.parse('FF000000', radix: 16);
  final one = int.parse('FFFFFFFF', radix: 16);
  final perceptron = Perceptron.fromFile('img_filter3.json');
  print(perceptron.toJson());
  final origImageFile = File('testimg.jpg').readAsBytesSync();
  final loadedImage = grayscale(decodeImage(origImageFile));
  var origImage;
  if (loadedImage.width <= 1024) {
    origImage = loadedImage;
  }
  else {
    final scaleFactor = 1024/loadedImage.width;
    origImage =
        copyResize(loadedImage, width: (loadedImage.width * scaleFactor).round(), height: (loadedImage.height * scaleFactor).round());
  }
  final targetImage = Image(origImage.width, origImage.height);
  print('${targetImage.width}, ${targetImage.height}');
  var y = 0;
  while (y < targetImage.height - 4) {
    var x = 0;
    print('x: $x, y: $y');
    while (x < targetImage.width - 4) {
      final block = <double>[];
      for (var j=0; j<4; j++) {
        for (var k=0; k<4; k++) {
          final origPixel = HEX.decode(origImage.getPixel(x+k, y+j).toRadixString(16).substring(2));
          block.addAll([origPixel[0].toDouble()/256 - 0.5]);
        }
      }
      //print(block);
      final result = perceptron.process(block);
      //print(result);
      for (var j=0; j<4; j++) {
        for (var k=0; k<4; k++) {
          final pixel = (result[k + j * 4] < 0.5? zero : one);
          targetImage.setPixel(x+k, y+j, pixel);
        }
      }
      x+=4;
      if (x > targetImage.width - 4) {
        x = targetImage.width - 4;
      }
    }
    y+=4;
    if (y > targetImage.height - 4) {
      y = targetImage.height - 4;
    }
  }
  File('processed.png').writeAsBytesSync(encodePng(targetImage));
  print('OK');
}
