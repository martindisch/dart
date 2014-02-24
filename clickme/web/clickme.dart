import 'dart:html';

void main() {
  querySelector("#sample_text_id")
    ..text = "Click me!"
    ..onClick.listen(reverseText);
}

void reverseText(MouseEvent event) {
  var text = querySelector("#sample_text_id").text;
  var buffer = new StringBuffer();
  for (int i = text.length - 1; i >= 0; i--) {
    //buffer.write(text[i] + getAddition(text, i));
    buffer.write(text[i] + getAdditionShort());
  }
  querySelector("#sample_text_id").text = buffer.toString();
}

String getAddition(String text, int i) {
  if (i == 0) {
    return "done";
  }
  return text[i - 1];
}

String getAdditionShort() => "h";
