void main() {
  String input = "Hai trăm mưới lam nghin đông ch an";

  List<String> extractedNumbers = extractNumbers(input);
  List<String> filteredNumbers = filterNumbersByUnit(extractedNumbers, input);

  print(filteredNumbers);
}

Map<String, dynamic> convertWordsToValues(String input) {
  Map<String, dynamic> wordToValue = {
    'mot': 1,
    'hai': 2,
    'ba': 3,
    'bon': 4,
    'nam': 5,
    'sau': 6,
    'bay': 7,
    'tam': 8,
    'chin': 9,
    'muoi': 10,
    'trăm': 100,
    'nghin': 1000,
    'trieu': 1000000,
    'ty': 1000000000,
    'dong': 'VND',
    'chan': 0,
  };

  List<String> words = input.split(' ');

  Map<String, dynamic> convertedValues = {};

  for (String word in words) {
    String lowercaseWord = word.toLowerCase();

    if (wordToValue.containsKey(lowercaseWord)) {
      // Nếu từ có trong từ điển, thêm vào kết quả
      convertedValues[word] = wordToValue[lowercaseWord];
    } else if (lowercaseWord == 'muoi') {
      // Xử lý trường hợp đặc biệt cho "muoi"
      if (!convertedValues.containsKey('muoi')) {
        // Nếu chưa có "muoi" trong kết quả, thêm vào với giá trị là 10
        convertedValues['muoi'] = 10;
      }
    } else {
      // Điều này được thực hiện nếu từ không nằm trong từ điển và không phải là "muoi"
      print("Không tìm thấy giá trị cho từ: $word");
    }
  }

  return convertedValues;
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

List<String> filterNumbersByUnit(List<String> numbers, String input) {
  Map<String, dynamic> convertedValues = convertWordsToValues(input);

  List<String> filteredList = numbers.where((number) {
    int numericValue = int.tryParse(number.replaceAll(',', '')) ?? 0;

    // Kiểm tra trường hợp sai sót và thiếu ký tự
    if (input.contains('ty')) {
      if (convertedValues.containsKey('ty') && numericValue >= 1000000000) {
        return true;
      }
    } else if (input.contains('trieu')) {
      if (convertedValues.containsKey('trieu') && numericValue >= 1000000) {
        return true;
      }
    } else if (input.contains('nghin')) {
      if (convertedValues.containsKey('nghin') && numericValue >= 1000) {
        return true;
      }
    }

    return false;
  }).toList();

  return filteredList;
}
