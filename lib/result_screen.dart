import 'package:flutter/material.dart';

import 'utils/hepler.dart';

class ResultScreen extends StatelessWidget {
  final String text;

  const ResultScreen({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Extracted information
    Map<String, dynamic> extractedData = extractInformation(text);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Result'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display the entire text
              Text(
                text,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20), // Add some spacing
              const Text("-----------------------"),
              const SizedBox(height: 16),
              // Display Số HD
              Text(
                'SỐ HD: ${extractedData['SoHD']}',
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 10),
              const Text("-----------------------"),
              const SizedBox(height: 16),
              // Display Tổng thanh toán
              const Text(
                'Tổng thanh toán:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                extractedData['TongThanhToan'] ?? [],
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 10),
              const Text("-----------------------"),
              const SizedBox(height: 16),
              // Display Ghi Chú
              Text(
                'Ghi Chú: ${extractedData['GhiChu']}',
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> extractInformation(String input) {
    Map<String, dynamic> result = {};

    // Extract Số HD
    result['SoHD'] = Helper().extractSoHD(input);
    debugPrint(result['SoHD']);

    // Extract Tổng thanh toán
    List<String> extractedNumbers = Helper().extractNumbers(input);
    List<String> uniqueNumbers = Helper().removeDuplicates(extractedNumbers);
    List<String> filteredNumbers = Helper().filterNumbers(uniqueNumbers, 1000);

    String dataInsideParentheses = Helper().extractDataInsideParentheses(input);

    debugPrint(dataInsideParentheses);

    result['TongThanhToan'] = Helper().processDataInsideParentheses(dataInsideParentheses, filteredNumbers);

    // Extract Ghi chú
    result['GhiChu'] = Helper().extractGhiChu(input);
    debugPrint(result['GhiChu']);

    return result;
  }
}
