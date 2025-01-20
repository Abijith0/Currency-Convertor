import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _fromCurrency = 'USD';
  String _toCurrency = 'INR';
  String _conversionResult = '';

  Future<void> _fetchExchangeRate(String amount) async {
    final url = 'https://api.exchangerate-api.com/v4/latest/$_fromCurrency';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final rate = data['rates'][_toCurrency];
        setState(() {
          double convertedAmount = double.tryParse(amount)! * rate;
          _conversionResult =
              '$amount $_fromCurrency = ${convertedAmount.toStringAsFixed(2)} $_toCurrency';
        });
      }
    } catch (e) {
      setState(() {
        _conversionResult = 'Error fetching exchange rate!';
      });
    }
  }

  void _swapCurrencies() {
    setState(() {
      final temp = _fromCurrency;
      _fromCurrency = _toCurrency;
      _toCurrency = temp;
    });
  }

  void _showBottomSheet(BuildContext context) {
    final TextEditingController _amountController = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter bottomSheetSetState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'Enter amount',
                      filled: true,
                      fillColor: Color(0xFFF4F4F6),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8942FE),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      if (_amountController.text.isNotEmpty) {
                        _fetchExchangeRate(_amountController.text).then((_) {
                          bottomSheetSetState(() {}); // Refresh bottom sheet UI
                        });
                      }
                    },
                    child: const Text(
                      'Convert',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _conversionResult.isNotEmpty
                        ? _conversionResult
                        : 'Conversion result will appear here',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Color(0xFF212529),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFED728),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _conversionResult = ''; // Clear result on close
                      });
                      Navigator.pop(context);
                    },
                    child: const Text('Close'),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      // Clear the result when bottom sheet is dismissed
      setState(() {
        _conversionResult = '';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF8942FE), Color(0xFFFED728)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(50),
            child: Column(
              children: [
                const Text(
                  'CURRENCY CONVERTER',
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 500, // Width of dropdown
                      child: DropdownButtonFormField<String>(
                        value: _fromCurrency,
                        dropdownColor: const Color(0xFFFED728),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 16),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _fromCurrency = value!;
                          });
                        },
                        items: [
                          'USD',
                          'EUR',
                          'INR',
                          'GBP',
                          'CAD',
                          'JPY',
                          'CNY',
                          'RUB',
                          'AUD',
                          'SGD'
                        ]
                            .map(
                              (e) => DropdownMenuItem(
                                child: Text(e),
                                value: e,
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    IconButton(
                      onPressed: _swapCurrencies,
                      icon: const Icon(Icons.swap_horiz, color: Colors.white),
                    ),
                    SizedBox(
                      width: 500, // Width of dropdown
                      child: DropdownButtonFormField<String>(
                        value: _toCurrency,
                        dropdownColor: const Color(0xFFFED728),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 16),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _toCurrency = value!;
                          });
                        },
                        items: [
                          'USD',
                          'EUR',
                          'INR',
                          'GBP',
                          'CAD',
                          'JPY',
                          'CNY',
                          'RUB',
                          'AUD',
                          'SGD'
                        ]
                            .map(
                              (e) => DropdownMenuItem(
                                child: Text(e),
                                value: e,
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD4CDFF),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => _showBottomSheet(context),
                  child: const Text(
                    'Convert',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
