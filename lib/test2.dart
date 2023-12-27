import 'package:number_to_vietnamese_words/number_to_vietnamese_words.dart';

void main() {
  String input = """
2/25/23, 4:43 PM
Địa chi:- -
Đơn giá
Khách hàng: Khách lẻ
SDT:
Chi nhánh tru.
H88 Từ Son
Địa chỉ: -
Điện thoai: +84971021196
HÓA ĐƠN BẮN HÀNG
SỐ HD: HDO00057
Ngày 25 tháng 12 năm 2023
Bàn Mỹ nghệ
123,456,789
Ghi chủ:
SL
---.. 123,456,789
Tổng tièn hàng:
Chiết khấu :
Tổng thanh toán:
Thành tiên
Cảm on và hẹn gåp lại!
Pawered by KIOTVIET.
123,456,789
(Một trăm hai mươi ba triệu bón trăm năm mưoi s
áu nghin bảy träm tám muoi chín dỏng chẳn)
123,456,789
  """;

  List<String> extractedNumbers = extractNumbers(input);
  List<String> uniqueNumbers = removeDuplicates(extractedNumbers);
  List<String> filteredNumbers = filterNumbers(uniqueNumbers, 1000);

  String dataInsideParentheses = extractDataInsideParentheses(input);

  processDataInsideParentheses(dataInsideParentheses, filteredNumbers);
}

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

void processDataInsideParentheses(String dataInsideParentheses, List<String> filteredNumbers) {
  List<String> keywords = ["ty", "tỷ", "ti", "tỉ", "triu", "trịu", "trieu", "triêu", "triệu", "nghin", "nghìn"];

  int value = 0;
  String currentKeyword = "";

  print("input: $dataInsideParentheses");
  print("input2: $filteredNumbers");

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
    String closestMatch = "";

    int minDifference = double.infinity.isFinite ? double.infinity.toInt() : 2147483647; // Đối với Dart 2.14.0 trở lên

    lengthsMap.forEach((dataInsideParentheses, length) {
      int difference = (targetLength - length).abs();
      if (difference < minDifference) {
        minDifference = difference;
        closestMatch = dataInsideParentheses;
      }
    });

    print("closestMatch: $closestMatch");
  }
}
