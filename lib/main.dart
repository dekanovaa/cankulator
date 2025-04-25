import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Calculator(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
    );
  }
}

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String _output = "0";
  String _currentNumber = "";
  String _operation = "";
  double _num1 = 0;
  double _num2 = 0;
  bool _shouldReset = false;
  List<String> _history = [];

  final FocusNode _focusNode = FocusNode();

  void buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "AC") {
        _output = "0";
        _currentNumber = "";
        _operation = "";
        _num1 = 0;
        _num2 = 0;
        _shouldReset = false;
        _history.clear(); // <-- Bu yerda tarix ham o'chiriladi
      } else if (["+", "−", "×", "÷"].contains(buttonText)) {
        _num1 = double.tryParse(_output) ?? 0;
        _operation = buttonText;
        _shouldReset = true;
      } else if (buttonText == "%") {
        _currentNumber = (double.tryParse(_output)! / 100).toString();
        _output = _currentNumber;
      } else if (buttonText == "±") {
        if (_output.startsWith("-")) {
          _output = _output.substring(1);
        } else {
          _output = "-" + _output;
        }
        _currentNumber = _output;
      } else if (buttonText == "=") {
        _num2 = double.tryParse(_output) ?? 0;
        double result = 0;
        switch (_operation) {
          case "+":
            result = _num1 + _num2;
            break;
          case "−":
            result = _num1 - _num2;
            break;
          case "×":
            result = _num1 * _num2;
            break;
          case "÷":
            if (_num2 != 0) result = _num1 / _num2;
            break;
        }
        String fullOperation =
            "${_num1.toString().replaceAll(RegExp(r'\.0$'), '')} $_operation ${_num2.toString().replaceAll(RegExp(r'\.0$'), '')} = ${result.toString().replaceAll(RegExp(r'\.0$'), '')}";
        _history.insert(0, fullOperation);

        _output = result.toString();
        _currentNumber = _output;
        _operation = "";
        _shouldReset = true;
      } else {
        if (_shouldReset) {
          _currentNumber = "";
          _shouldReset = false;
        }

        if (buttonText == "." && _currentNumber.isEmpty) {
          _currentNumber = "0.";
        } else if (buttonText == "." && _currentNumber.contains(".")) {
          return;
        } else {
          _currentNumber += buttonText;
        }

        _output = _currentNumber;
      }

      if (_output.endsWith(".0")) {
        _output = _output.substring(0, _output.length - 2);
      }
    });
  }

  Widget buildButton(String buttonText, Color buttonColor, Color textColor) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            shape: CircleBorder(),
            padding: EdgeInsets.all(20),
          ),
          child: Text(
            buttonText,
            style: TextStyle(fontSize: 30, color: textColor),
          ),
          onPressed: () => buttonPressed(buttonText),
        ),
      ),
    );
  }

  void _handleKey(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      final key = event.logicalKey.keyLabel;
      switch (key) {
        case "0":
        case "1":
        case "2":
        case "3":
        case "4":
        case "5":
        case "6":
        case "7":
        case "8":
        case "9":
        case ".":
          buttonPressed(key);
          break;
        case "+":
          buttonPressed("+");
          break;
        case "-":
          buttonPressed("−");
          break;
        case "*":
          buttonPressed("×");
          break;
        case "/":
          buttonPressed("÷");
          break;
        case "=":
        case "Enter":
          buttonPressed("=");
          break;
        case "Backspace":
          if (_currentNumber.isNotEmpty) {
            setState(() {
              _currentNumber = _currentNumber.substring(
                0,
                _currentNumber.length - 1,
              );
              _output = _currentNumber.isEmpty ? "0" : _currentNumber;
            });
          }
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: _focusNode..requestFocus(),
      onKey: _handleKey,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(vertical: 24, horizontal: 12),
              child: Text(
                _output,
                style: TextStyle(
                  fontSize: 80,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Divider(color: Colors.grey),
            Expanded(
              child: ListView(
                children:
                    _history
                        .map(
                          (e) => Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            child: Text(
                              e,
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 18,
                              ),
                            ),
                          ),
                        )
                        .toList(),
              ),
            ),
            Column(
              children: [
                Row(
                  children: [
                    buildButton("AC", Colors.grey, Colors.black),
                    buildButton("±", Colors.grey, Colors.black),
                    buildButton("%", Colors.grey, Colors.black),
                    buildButton("÷", Colors.orange, Colors.white),
                  ],
                ),
                Row(
                  children: [
                    buildButton("7", Colors.grey[850]!, Colors.white),
                    buildButton("8", Colors.grey[850]!, Colors.white),
                    buildButton("9", Colors.grey[850]!, Colors.white),
                    buildButton("×", Colors.orange, Colors.white),
                  ],
                ),
                Row(
                  children: [
                    buildButton("4", Colors.grey[850]!, Colors.white),
                    buildButton("5", Colors.grey[850]!, Colors.white),
                    buildButton("6", Colors.grey[850]!, Colors.white),
                    buildButton("−", Colors.orange, Colors.white),
                  ],
                ),
                Row(
                  children: [
                    buildButton("1", Colors.grey[850]!, Colors.white),
                    buildButton("2", Colors.grey[850]!, Colors.white),
                    buildButton("3", Colors.grey[850]!, Colors.white),
                    buildButton("+", Colors.orange, Colors.white),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[850],
                            shape: StadiumBorder(),
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 20,
                            ),
                          ),
                          child: Text(
                            "0",
                            style: TextStyle(fontSize: 30, color: Colors.white),
                          ),
                          onPressed: () => buttonPressed("0"),
                        ),
                      ),
                    ),
                    buildButton(".", Colors.grey[850]!, Colors.white),
                    buildButton("=", Colors.orange, Colors.white),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
