import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Simple Calculator',
      theme: ThemeData.dark(),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Automatically navigate to the Calculator screen after 3 seconds
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const CalculatorScreen()),
      );
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display gold "M" as the logo
            const Text(
              'M',
              style: TextStyle(
                color: Colors.amber, // Gold color
                fontSize: 100,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Simple Calculator',
              style: TextStyle(
                color: Colors.amber,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = '0';
  String _previousValue = '';
  String _operator = '';
  bool _isOperatorPressed = false;
  bool _isError = false;
  String _expression = '';

  void _onDigitPress(String digit) {
    if (_isError) {
      _clearAll();
    }
    if (_display.length >= 8 && !_isOperatorPressed) {
      setState(() {
        _display = 'OVERFLOW';
        _isError = true;
      });
      return;
    }
    setState(() {
      if (_isOperatorPressed || _display == '0') {
        _display = digit;
        _isOperatorPressed = false;
      } else {
        _display += digit;
      }
    });
  }

  void _onOperatorPress(String operator) {
    if (_isError) return;
    setState(() {
      if (_previousValue.isEmpty) {
        _previousValue = _display;
        _operator = operator;
        _isOperatorPressed = true;
        _display = '$_display $operator';
      } else if (_isOperatorPressed) {
        _operator = operator;
        _display = '$_previousValue $operator';
      } else {
        _calculate();
        _previousValue = _display;
        _operator = operator;
        _isOperatorPressed = true;
        _display = '$_previousValue $operator';
      }
    });
  }

  void _calculate() {
    if (_isError || _previousValue.isEmpty || _operator.isEmpty) return;

    double num1 = double.parse(_previousValue.replaceAll(RegExp(r'[^\d.]'), ''));
    double num2 = double.tryParse(_display.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0;
    double result;

    try {
      switch (_operator) {
        case '+':
          result = num1 + num2;
          break;
        case '-':
          result = num1 - num2;
          break;
        case '*':
          result = num1 * num2;
          break;
        case '/':
          if (num2 == 0) {
            throw Exception('Divide by zero');
          }
          result = num1 / num2;
          break;
        default:
          return;
      }
      setState(() {
        _expression = '$_previousValue $_operator $num2 = ${result.toStringAsFixed(2).replaceAll(RegExp(r'\.00$'), '')}';
        _display = result.toStringAsFixed(2).replaceAll(RegExp(r'\.00$'), '');
        _previousValue = '';
        _operator = '';
        _isOperatorPressed = false;
      });
    } catch (e) {
      setState(() {
        _display = 'ERROR';
        _isError = true;
      });
    }
  }

  void _clearAll() {
    setState(() {
      _display = '0';
      _previousValue = '';
      _operator = '';
      _isOperatorPressed = false;
      _isError = false;
      _expression = '';
    });
  }

  void _clearEntry() {
    if (_isError) {
      _clearAll();
    } else {
      setState(() {
        _display = '0';
      });
    }
  }

  Widget _buildButton(String text, {Color? color, Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: color ?? Colors.grey[800],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Display for expression
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.all(4.0),
            child: Text(
              _expression,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 24,
                color: Colors.grey,
              ),
            ),
          ),
          // Display for current value
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              _display,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 48,
                color: Colors.amber,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Buttons
          Expanded(
            child: GridView.count(
              crossAxisCount: 4,
              padding: const EdgeInsets.all(8.0),
              children: [
                _buildButton('7', onTap: () => _onDigitPress('7')),
                _buildButton('8', onTap: () => _onDigitPress('8')),
                _buildButton('9', onTap: () => _onDigitPress('9')),
                _buildButton('+', color: Colors.amber, onTap: () => _onOperatorPress('+')),
                _buildButton('4', onTap: () => _onDigitPress('4')),
                _buildButton('5', onTap: () => _onDigitPress('5')),
                _buildButton('6', onTap: () => _onDigitPress('6')),
                _buildButton('-', color: Colors.amber, onTap: () => _onOperatorPress('-')),
                _buildButton('1', onTap: () => _onDigitPress('1')),
                _buildButton('2', onTap: () => _onDigitPress('2')),
                _buildButton('3', onTap: () => _onDigitPress('3')),
                _buildButton('*', color: Colors.amber, onTap: () => _onOperatorPress('*')),
                _buildButton('CE', color: Colors.red, onTap: _clearEntry),
                _buildButton('0', onTap: () => _onDigitPress('0')),
                _buildButton('=', color: Colors.green, onTap: _calculate),
                _buildButton('/', color: Colors.amber, onTap: () => _onOperatorPress('/')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
