import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(LoanCalculatorApp());
}

class LoanCalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loan Calculator',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoanCalculator(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoanCalculator extends StatefulWidget {
  @override
  _LoanCalculatorState createState() => _LoanCalculatorState();
}

class _LoanCalculatorState extends State<LoanCalculator> {
  final TextEditingController _principalController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  double _monthlyPayment = 0.0;
  double _loanTermYears = 5.0; // Default value for the slider
  String _errorMessage = '';

  void _calculatePayment() {
    setState(() {
      final double principal = double.tryParse(_principalController.text) ?? 0.0;
      final double annualRate = (double.tryParse(_rateController.text) ?? 0.0) / 100;
      final int years = _loanTermYears.toInt();

      if (principal <= 0 || annualRate <= 0 || years <= 0) {
        _errorMessage = 'Please enter valid values for all fields.';
        _monthlyPayment = 0.0;
      } else {
        final double monthlyRate = annualRate / 12;
        final int months = years * 12;
        _monthlyPayment = (principal * monthlyRate) / (1 - pow(1 + monthlyRate, -months));
        _errorMessage = '';
      }
    });
  }

  void _resetFields() {
    setState(() {
      _principalController.clear();
      _rateController.clear();
      _loanTermYears = 5.0;
      _monthlyPayment = 0.0;
      _errorMessage = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Loan Calculator'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField(
              controller: _principalController,
              label: 'Principal Amount',
              hintText: 'Enter principal amount',
              keyboardType: TextInputType.number,
              color: Colors.orangeAccent,
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: _rateController,
              label: 'Annual Interest Rate (%)',
              hintText: 'Enter annual interest rate',
              keyboardType: TextInputType.number,
              color: Colors.lightGreenAccent,
            ),
            SizedBox(height: 16),
            Text(
              'Loan Term: ${_loanTermYears.toInt()} years',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple),
            ),
            Slider(
              value: _loanTermYears,
              min: 1,
              max: 30,
              divisions: 29,
              label: '${_loanTermYears.toInt()} years',
              activeColor: Colors.deepPurple,
              inactiveColor: Colors.deepPurple.withOpacity(0.3),
              onChanged: (value) {
                setState(() {
                  _loanTermYears = value;
                });
              },
            ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.redAccent, fontSize: 16),
                ),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculatePayment,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: EdgeInsets.symmetric(vertical: 15.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Text(
                'Calculate',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _resetFields,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: EdgeInsets.symmetric(vertical: 15.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Text(
                'Reset',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
            AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: _monthlyPayment > 0
                  ? Container(
                key: ValueKey<double>(_monthlyPayment),
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.tealAccent,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text(
                  'Monthly Payment: \$${_monthlyPayment.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              )
                  : SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required TextInputType keyboardType,
    required Color color,
  }) {
    return Card(
      color: color,
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
          ),
          keyboardType: keyboardType,
        ),
      ),
    );
  }
}

