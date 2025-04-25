import 'package:flutter/material.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Calculator(),
      theme: ThemeData.dark(),
       debugShowCheckedModeBanner: false,
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

  void buttonPressed(String buttonText) {
    if (buttonText == "AC") {
      _output = "0";
      _currentNumber = "";
      _operation = "";
      _num1 = 0;
      _num2 = 0;
    } else if (buttonText == "+" || buttonText == "−" || buttonText == "×" || buttonText == "÷") {
      _num1 = double.parse(_output);
      _operation = buttonText;
      _currentNumber = "";
    } else if (buttonText == "%") {
      _currentNumber = (double.parse(_output) / 100).toString();
      _output = _currentNumber;
    } else if (buttonText == "±") {
      if (_output.startsWith("-")) {
        _output = _output.substring(1);
      } else {
        _output = "-" + _output;
      }
    } else if (buttonText == "=") {
      _num2 = double.parse(_output);
      if (_operation == "+") {
        _currentNumber = (_num1 + _num2).toString();
      }
      if (_operation == "−") {
        _currentNumber = (_num1 - _num2).toString();
      }
      if (_operation == "×") {
        _currentNumber = (_num1 * _num2).toString();
      }
      if (_operation == "÷") {
        _currentNumber = (_num1 / _num2).toString();
      }
      _operation = "";
      _num1 = 0;
      _num2 = 0;
      _output = _currentNumber;
    } else {
      _currentNumber = _currentNumber + buttonText;
      _output = _currentNumber;
    }

    setState(() {
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
            backgroundColor: buttonColor, // Updated 'primary' to 'backgroundColor'
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          Expanded(child: Divider()),
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
                          backgroundColor: Colors.grey[850], // Updated 'primary' to 'backgroundColor'
                          shape: StadiumBorder(),
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
    );
  }
}