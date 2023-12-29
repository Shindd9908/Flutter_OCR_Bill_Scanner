import 'package:flutter/foundation.dart';
import 'package:number_to_vietnamese_words/number_to_vietnamese_words.dart';

class Helper {
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
  /// ---------------------------------------
  List<String> extractNumbers(String input) {
    RegExp numberRegex = RegExp(r'\b\d{1,3}(,\d{3})*\b');
    return numberRegex.allMatches(input).map((match) => match.group(0)!).toList();
  }

  List<String> removeDuplicates(List<String> numbers) {
    return numbers.toSet().toList();
  }

  List<String> filterNumbers(List<String> numbers, int minValue) {
    return numbers.where((number) {
      int? numericValue = int.tryParse(number.replaceAll(',', ''));
      return numericValue != null && numericValue >= minValue;
    }).toList();
  }

  String extractDataInsideParentheses(String input) {
    RegExp parenthesesRegex = RegExp(r'\(([^)]+)\)');
    Match? match = parenthesesRegex.firstMatch(input);
    return match?.group(1)?.replaceAll('\n', '') ?? '';
  }

  String processDataInsideParentheses(String dataInsideParentheses, List<String> filteredNumbers) {
    String closestMatch = "";
    List<String> keywords = ["ty", "tỷ", "ti", "tỉ", "triu", "trịu", "trieu", "triêu", "triệu", "nghin", "nghìn"];

    int value = 0;
    String currentKeyword = "";

    debugPrint("input: $dataInsideParentheses");

    for (String keyword in keywords) {
      if (dataInsideParentheses.contains(keyword)) {
        currentKeyword = keyword;
        break;
      }
    }

    // Xử lý giá trị tương ứng với keyword đã tìm thấy
    if (currentKeyword == "ty" || currentKeyword == "tỷ" || currentKeyword == "ti" || currentKeyword == "tỉ") {
      value = 1000000000; // 1 tỷ
    } else if (currentKeyword == "triu" || currentKeyword == "trịu" || currentKeyword == "trieu" || currentKeyword == "triêu" || currentKeyword == "triệu") {
      value = 1000000; // 1 triệu
    } else if (currentKeyword == "nghin" || currentKeyword == "nghìn") {
      value = 1000; // Giữ nguyên nếu gặp từ "nghin" đầu tiên
    }

    // Lọc giá trị từ danh sách đã có và thêm vào danh sách lọc
    List<String> numbers = filteredNumbers.where((number) {
      int? numericValue = int.tryParse(number.replaceAll(',', ''));
      return (numericValue ?? 0) >= value;
    }).toList();

    int index = dataInsideParentheses.indexOf(currentKeyword);
    if (index > 0) {
      // Lấy chuỗi trước currentKeyword
      String substringBeforeKeyword = dataInsideParentheses.substring(0, index);

      // Lọc giá trị từ chuỗi trước currentKeyword và thêm vào danh sách lọc
      String newSubstring = '';
      switch (substringBeforeKeyword[0].toLowerCase()) {
        case 'm':
          newSubstring = filteredNumbers.where((number) => number.startsWith('1')).join(', ');
          break;
        case 'h':
          newSubstring = filteredNumbers.where((number) => number.startsWith('2')).join(', ');
          break;
        case 'b':
          newSubstring = filteredNumbers.where((number) {
            if (substringBeforeKeyword.length - 1 == 2) {
              return number.startsWith('3');
            } else if (substringBeforeKeyword.length - 1 == 3) {
              String lastChar = substringBeforeKeyword.isNotEmpty ? substringBeforeKeyword.substring(substringBeforeKeyword.length - 2) : '';
              if (lastChar == 'n ') {
                return number.startsWith('4');
              } else if (lastChar == 'y ') {
                return number.startsWith('7');
              }
            }
            return false; // Hoặc return true/false tùy thuộc vào trường hợp mặc định của bạn
          }).join(', ');
          break;
        case 'n':
          newSubstring = filteredNumbers.where((number) => number.startsWith('5')).join(', ');
          break;
        case 't':
          newSubstring = filteredNumbers.where((number) => number.startsWith('8')).join(', ');
          break;
        case 'c':
          newSubstring = filteredNumbers.where((number) => number.startsWith('9')).join(', ');
          break;
      // Thêm các case khác tương ứng với quy tắc của bạn
      }

      Map<String, int> lengthsMap = {};
      List<String> formattedNumbers = extractNumbers(newSubstring).map((number) => (int.tryParse(number.replaceAll(',', '')) ?? 0).toString()).toList();

      for (var number in formattedNumbers) {
        String formattedNumber = number.replaceAll(',', '');
        int length = "${int.parse(formattedNumber).toVietnameseWords()} đồng chẵn".length;
        lengthsMap[formattedNumber] = length;
      }

      int targetLength = dataInsideParentheses.length;

      int minDifference = double.infinity.isFinite ? double.infinity.toInt() : 2147483647; // Đối với Dart 2.14.0 trở lên

      lengthsMap.forEach((dataInsideParentheses, length) {
        int difference = (targetLength - length).abs();
        if (difference < minDifference) {
          minDifference = difference;
          closestMatch = dataInsideParentheses;
        }
      });

      debugPrint("closestMatch: $closestMatch");
    }

    return closestMatch;
  }
}