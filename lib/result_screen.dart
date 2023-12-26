import 'package:flutter/material.dart';

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
              // Text(
              //   extractedData['TongThanhToan'] ?? [],
              //   style: const TextStyle(fontSize: 20),
              // ),
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
    result['SoHD'] = extractSoHD(input);
    debugPrint(result['SoHD']);

    // Extract Tổng thanh toán
    // RegExp tongThanhToanRegExp = RegExp(r'T[oòóỏọôồốỗộ]ng thanh to[aáàãạ]n:\n([\d\n,]+)\n');
    // Match? tongThanhToanMatch = tongThanhToanRegExp.firstMatch(input);
    // print(tongThanhToanMatch);
    // if (tongThanhToanMatch != null) {
    //   String totalAmount = tongThanhToanMatch.group(1) ?? '';
    //
    //   // Check if the total amount contains a comma
    //   if (totalAmount.contains(',')) {
    //     result['TongThanhToan'] = totalAmount;
    //   } else {
    //     List<String> amounts = totalAmount.split('\n');
    //     result['TongThanhToan'] = getLargestAmount(amounts);
    //   }
    // } else {
    //   result['TongThanhToan'] = '';
    // }


    // Extract Ghi Chú

    result['TONG DON HANG'] = extractTextInParentheses(input);
    print(result['TONG DON HANG']);

    result['GhiChu'] = extractGhiChu(input);
    debugPrint(result['GhiChu']);

    return result;
  }

  String extractSoHD(String input) {
    RegExp hdRegex = RegExp(r'\bHD(\w+)\b', caseSensitive: false);
    String? soHD = hdRegex.firstMatch(input)?.group(1);

    // Process the numeric part after 'HD'
    if (soHD != null) {
      String formattedNumericPart = soHD.replaceAllMapped(
        RegExp(r'[OoDd]'),
            (match) => '0',
      );
      soHD = 'HD$formattedNumericPart';
    }

    return soHD ?? '';
  }

  String extractGhiChu(String input) {
    String ghiChuPattern = r'GASYDH (\d+)';
    RegExp ghiChuRegExp = RegExp(ghiChuPattern);
    String? ghiChu = ghiChuRegExp.firstMatch(input)?.group(0);

    return ghiChu ?? '';
  }

  String extractTextInParentheses(String input) {
    int openParenthesisIndex = input.indexOf('(');
    int closeParenthesisIndex = input.indexOf(')', openParenthesisIndex);

    if (openParenthesisIndex != -1 && closeParenthesisIndex != -1) {
      String textInParentheses = input.substring(openParenthesisIndex + 1, closeParenthesisIndex);

      // Xử lý trường hợp có xuống dòng
      textInParentheses = textInParentheses.replaceAll('\n', ' ').trim();

      return textInParentheses;
    } else {
      return ''; // Không tìm thấy dấu ngoặc đơn
    }
  }

  String getLargestAmount(List<String> amounts) {
    int largestAmount = 0;

    for (var amount in amounts) {
      int currentAmount = int.tryParse(amount.replaceAll(',', '')) ?? 0;
      if (currentAmount > largestAmount) {
        largestAmount = currentAmount;
      }
    }

    return largestAmount.toString();
  }
}
