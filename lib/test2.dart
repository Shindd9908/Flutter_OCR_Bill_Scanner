
import 'package:number_to_vietnamese_words/number_to_vietnamese_words.dart';

void main() {
  String input = """
  12/25/23, 4:37 PM
SDT:
Dịa chỉ: --
Khách hàng: Khách lẻ
Đơn giá
10,000
H88 Từ Sơn
Dịa chỉ:--
Điện thoai: +84971021196
HÓA ĐƠN BÁN HÀNG
SỐ HD: HDO00056
Hộp phở bò phố cổ
Ghi chú
Chi nhánh tru...
Ngày 25 tháng 12 nåm 2023
(Muoi nghin dồng chẳn)
SL
Tồng tiền hàng:
Chiết khấu:
Tổng thanh toán:
Cảm ơn và hẹn gập lại!
Powered by KIOTVIET
Thành tiền
10,000
10,000
10,000
15,000
11,000
12,000
13,000
14,000
  """;

  List<String> extractedNumbers = extractNumbers(input);
  List<String> uniqueNumbers = removeDuplicates(extractedNumbers);
  List<String> filteredNumbers = filterNumbers(uniqueNumbers, 1000);

  String dataInsideParentheses = extractDataInsideParentheses(input);

  processDataInsideParentheses(dataInsideParentheses, filteredNumbers);
}

List<String> extractNumbers(String input) {
  RegExp numberRegex = RegExp(r'\b\d{1,3}(,\d{3})*\b');
  Iterable<Match> matches = numberRegex.allMatches(input);

  List<String> extractedNumbers = [];

  for (Match match in matches) {
    extractedNumbers.add(match.group(0)!);
  }

  return extractedNumbers;
}

List<String> removeDuplicates(List<String> numbers) {
  Set<String> uniqueSet = Set<String>.from(numbers);
  List<String> uniqueList = List<String>.from(uniqueSet);

  return uniqueList;
}

List<String> filterNumbers(List<String> numbers, int minValue) {
  // Lọc ra các số từ danh sách có giá trị tối thiểu là minValue
  List<String> filteredList = numbers.where((number) {
    int numericValue = int.tryParse(number.replaceAll(',', '')) ?? 0;
    return numericValue >= minValue;
  }).toList();

  return filteredList;
}

String extractDataInsideParentheses(String input) {
  RegExp parenthesesRegex = RegExp(r'\((.*?)\)');

  Match? match = parenthesesRegex.firstMatch(input);
  if (match != null) {
    String insideParentheses = match.group(1)!;
    // Loại bỏ xuống dòng nếu có
    insideParentheses = insideParentheses.replaceAll('\n', '');
    return insideParentheses;
  } else {
    return ''; // Trả về chuỗi rỗng nếu không tìm thấy
  }
}

void processDataInsideParentheses(String dataInsideParentheses, List<String> filteredNumbers) {
  List<String> keywords = ["ty", "tỷ", "ti", "tỉ", "triu", "trịu", "trieu", "triêu", "triệu", "nghin", "nghìn"];

  int value = 0;
  String currentKeyword = "";

  print("input: $dataInsideParentheses");

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
  List<String> numbers = filteredNumbers.where((number) => (int.tryParse(number.replaceAll(',', '')) ?? 0) >= value).toList();
  print(numbers);

  int index = dataInsideParentheses.indexOf(currentKeyword);
  if (index > 0) {
    // Lấy chuỗi trước currentKeyword
    String substringBeforeKeyword = dataInsideParentheses.substring(0, index);

    // Lọc giá trị từ chuỗi trước currentKeyword và thêm vào danh sách lọc
    print(substringBeforeKeyword);

    String newSubstring = '';
    switch (substringBeforeKeyword[0].toLowerCase()) {
      case 'm':
        newSubstring = filteredNumbers.where((number) => number.startsWith('1')).join(', ');
        break;
      case 'h':
        newSubstring = filteredNumbers.where((number) => number.startsWith('2')).join(', ');
        break;
      case 'b':
        newSubstring = filteredNumbers.where((number) => number.endsWith('a')).join(', ');
        newSubstring += filteredNumbers.where((number) => number.endsWith('y')).join(', ');
        newSubstring += filteredNumbers.where((number) => number.endsWith('n')).join(', ');
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

    print(newSubstring);
    Map<String, int> lengthsMap = {};
    List<String> formattedNumbers = extractNumbers(newSubstring)
        .map((number) => (int.tryParse(number.replaceAll(',', '')) ?? 0).toString())
        .toList();
    print(formattedNumbers.join(', '));

    for (var number in formattedNumbers) {
      String formattedNumber = number.replaceAll(',', '');
      print("$formattedNumber : ${int.parse(formattedNumber).toVietnameseWords()}");

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


