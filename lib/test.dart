void main() {
  //Một trăm hai mưrơi ba triu bồn trăm năm mưoi s áu nghin bảy träm tám muoi chín dồng chắn
  //Hai trăm mưới lam nghin đông ch an
  List<String> words = ["mui", "nghin", "đồng", "chãn"];

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
    'tram': 100,
    'nghin': 1000,
    'trieu': 1000000,
    'ty': 1000000000,
    'dong': 'VND',
    'chan': 0,
  };

  List<dynamic> convertedValues = convertWordsToValues(words, wordToValue);

  print(convertedValues);
}

List<dynamic> convertWordsToValues(List<String> words, Map<String, dynamic> wordToValue) {
  List<dynamic> convertedValues = [];

  for (String word in words) {
    // Chuyển đổi từ thành chữ thường trước khi kiểm tra
    String lowercaseWord = word.toLowerCase();

    // Kiểm tra xem từ có trong từ điển hay không
    if (wordToValue.containsKey(lowercaseWord)) {
      convertedValues.add(wordToValue[lowercaseWord]);
    } else if (lowercaseWord == 'moi') {
      // Xử lý trường hợp đặc biệt với từ 'moi'
      convertedValues.add(wordToValue['muoi']);
    } else {
      // Điều này được thực hiện nếu từ không nằm trong từ điển và không phải là 'moi'
      print("Không tìm thấy giá trị cho từ: $word");
    }
  }

  return convertedValues;
}
