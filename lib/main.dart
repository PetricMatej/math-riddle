import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import 'package:math_riddle/assets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class Fruit {
  final String icon;
  final int value;
  Fruit({
    required this.icon,
    required this.value,
  });
}

class Operation {
  final String icon;
  final String value;

  Operation({
    required this.icon,
    required this.value,
  });
}

class MyHomePage extends StatefulWidget {
  const MyHomePage();

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController textEditingController = TextEditingController();
  String? result;
  int level = 1;

  @override
  Widget build(BuildContext context) {
    List<Fruit> fruits = fruitIconsList.map(
      (fruit) {
        return Fruit(
          icon: fruit,
          value: Random().nextInt(5),
        );
      },
    ).toList();
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Level: $level',
              style: GoogleFonts.play(
                textStyle: const TextStyle(
                  fontSize: 46,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              'Can you solve this riddle ?',
              style: GoogleFonts.play(
                textStyle: const TextStyle(
                  fontSize: 46,
                  fontWeight: FontWeight.w800,
                  color: Colors.green,
                ),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
                child: Column(
                  children: [
                    _buildRow(
                      fruitValues: fruits..shuffle(),
                      operations: asignOperationValues(),
                      isQuestion: false,
                    ),
                    _buildRow(
                      fruitValues: fruits..shuffle(),
                      operations: asignOperationValues(),
                      isQuestion: false,
                    ),
                    _buildRow(
                      fruitValues: fruits..shuffle(),
                      operations: asignOperationValues(),
                      isQuestion: false,
                    ),
                    _buildRow(
                      fruitValues: fruits..shuffle(),
                      operations: asignOperationValues(),
                      isQuestion: false,
                    ),
                    _buildRow(
                      fruitValues: fruits..shuffle(),
                      operations: asignOperationValues(),
                      isQuestion: true,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            _buildResultInput()
          ],
        ),
      ),
    );
  }

  Widget _buildRow({
    required List<Fruit> fruitValues,
    required List<Operation> operations,
    bool? isQuestion = false,
  }) {
    Fruit leadFruit = fruitValues[0];
    Fruit midFruit = fruitValues[1];
    Fruit sufixFruit = fruitValues[2];
    Operation leadOperation = operations[0];
    Operation sufixOperation = operations[1];
    if (isQuestion!) {
      result = findResult(
        leadOperation,
        sufixOperation,
        leadFruit,
        midFruit,
        sufixFruit,
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SvgPicture.asset(
          leadFruit.icon,
          height: 45,
        ),
        SvgPicture.asset(
          leadOperation.icon,
          height: 25,
        ),
        SvgPicture.asset(
          midFruit.icon,
          height: 45,
        ),
        SvgPicture.asset(
          sufixOperation.icon,
          height: 25,
        ),
        SvgPicture.asset(
          sufixFruit.icon,
          height: 45,
        ),
        SvgPicture.asset(
          operationIconsList[2],
          height: 25,
        ),
        Text(
          isQuestion
              ? 'X'
              : findResult(
                  leadOperation,
                  sufixOperation,
                  leadFruit,
                  midFruit,
                  sufixFruit,
                ),
          style: GoogleFonts.play(
              textStyle: const TextStyle(
            fontSize: 46,
            fontWeight: FontWeight.w800,
            color: Colors.green,
          )),
        ),
      ],
    );
  }

  Widget _buildResultInput() {
    return Column(
      children: [
        Text(
          'Guess X:',
          style: GoogleFonts.play(
              textStyle: const TextStyle(
            fontSize: 46,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          )),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: textEditingController,
          onChanged: (String value) {
            if (value == result) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      actionsAlignment: MainAxisAlignment.center,
                      content: Image.asset('assets/gifs/completed.gif'),
                      actions: <Widget>[
                        ElevatedButton(
                          child: Text('Start level ${level + 1}'),
                          onPressed: () {
                            textEditingController.clear();
                            setState(() {
                              level++;
                            });

                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  });
            }
          },
          cursorColor: Colors.green,
          decoration: const InputDecoration(
            fillColor: Colors.white,
            filled: true,
            contentPadding: EdgeInsets.all(12),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.green),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.green),
            ),
          ),
          keyboardType: TextInputType.number,
          style: GoogleFonts.play(
              textStyle: const TextStyle(
            fontSize: 46,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          )),
          textAlign: TextAlign.center,
        )
      ],
    );
  }

  List<Operation> asignOperationValues() {
    List<Operation> operations = [
      Operation(icon: operationIconsList[0], value: '+'),
      Operation(icon: operationIconsList[1], value: '-'),
    ]..shuffle();

    return operations.map(
      (operation) {
        return Operation(
          icon: operation.icon,
          value: operation.value,
        );
      },
    ).toList();
  }

  String findResult(
    Operation leadOperation,
    Operation sufixOperation,
    Fruit leadFruit,
    Fruit midFruit,
    Fruit sufixFruit,
  ) {
    {
      if (leadOperation.value == '+' && sufixOperation.value == '+') {
        return (leadFruit.value + midFruit.value + sufixFruit.value).toString();
      } else if (leadOperation.value == '+' && sufixOperation.value == '-') {
        return (leadFruit.value + midFruit.value - sufixFruit.value).toString();
      } else if (leadOperation.value == '-' && sufixOperation.value == '+') {
        return (leadFruit.value - midFruit.value + sufixFruit.value).toString();
      } else {
        return (leadFruit.value - midFruit.value - sufixFruit.value).toString();
      }
    }
  }
}
