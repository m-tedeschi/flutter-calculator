import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart';

void main() {
  runApp(const SimpleCalcApp());
}

class SimpleCalcApp extends StatelessWidget {
  const SimpleCalcApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Calc',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SimpleCalcScreen(),
    );
  }
}

class SimpleCalcScreen extends StatefulWidget {
  const SimpleCalcScreen({super.key});

  @override
  _SimpleCalcScreenState createState() => _SimpleCalcScreenState();
}

class _SimpleCalcScreenState extends State<SimpleCalcScreen> {
  final TextEditingController _inputController = TextEditingController();
  String _output = '';

  void _clearInput() {
    _inputController.clear();
    setState(() {
      _output = '';
    });
  }

  void _calculate() {
    try {
      Expression expression = Expression.parse(_inputController.text.replaceAll(' ', ''));
      const evaluator = ExpressionEvaluator();
      var result = evaluator.eval(expression, {});

      setState(() {
        // Check for division by zero
        if (result.toString() == 'Infinity' || result.toString() == '-Infinity') {
          _output = '${_inputController.text} = Error';
        } else if (result is double && result == result.toInt()) {
          // If the result is a whole number, show it without decimal places
          _output = '${_inputController.text} = ${result.toInt()}';
        } else {
          // Show the result with decimals if necessary
          _output = '${_inputController.text} = $result';
        }
      });
    } catch (e) {
      // In case of any other error, display 'Error'
      setState(() {
        _output = '${_inputController.text} = Error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Calc | Michael Tedeschi'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.grey[300],
              padding: const EdgeInsets.all(8),
              alignment: Alignment.bottomRight,
              child: FittedBox( // Using FittedBox for the accumulator input display to prevent overflow of text
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerRight,
                child: Text(
                  _inputController.text,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.grey[400],
              padding: const EdgeInsets.all(8),
              alignment: Alignment.bottomRight,
              child: FittedBox( // using FittedBox for the output display to prevent overflow of text
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerRight,
                child: Text(
                  _output,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
          ),
          Row(
            children: [
              _buildButton('7'),
              _buildButton('8'),
              _buildButton('9'),
              _buildButton('+'),
            ],
          ),
          Row(
            children: [
              _buildButton('4'),
              _buildButton('5'),
              _buildButton('6'),
              _buildButton('-'),
            ],
          ),
          Row(
            children: [
              _buildButton('1'),
              _buildButton('2'),
              _buildButton('3'),
              _buildButton('*'),
            ],
          ),
          Row(
            children: [
              _buildButton('0'),
              _buildButton('C'),
              _buildButton('='),
              _buildButton('/'),
            ],
          ),
        ],
      ),
    );
  }

  String _formatExpression(String expression) {
    return expression.replaceAllMapped(RegExp(r'(\d)([+\-*/])|([+\-*/])(\d)'), (match) {
      if (match[1] != null) {
        return '${match[1]} ${match[2]} '; // Space after number and operator
      } else if (match[3] != null) {
        return ' ${match[3]} ${match[4]}'; // Space around the operator
      }
      return match[0]!;
    });
  }

  Widget _buildButton(String text) {
    return Expanded(
      child: TextButton(
        onPressed: () {
          if (text == '=') {
            _calculate();
          } else if (text == 'C') {
            _clearInput();
          } else {
            _inputController.text += text;
            _inputController.text = _formatExpression(_inputController.text);
            setState(() {});
          }
        },
        child: Text(
          text,
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
