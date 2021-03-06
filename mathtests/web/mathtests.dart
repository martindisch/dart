import 'dart:html';
import 'dart:math';
import 'dart:async';

void main() {
  window.onResize.listen((e) => printresize());
  
  printresize();
  
  InputElement bEancheck = querySelector("#eancheck");
  bEancheck.onClick.listen((e) => eancheck());
  
  InputElement bISBNcheck = querySelector("#isbncheck");
  bISBNcheck.onClick.listen((e) => isbncheck());
  
  InputElement bHammingCalculate = querySelector("#hammingcalculate");
  bHammingCalculate.onClick.listen((e) => calcParity());
  
  InputElement bHammingCorrect = querySelector("#hammingcorrect");
  bHammingCorrect.onClick.listen((e) => correct());
  
  (querySelector("#hammingreset") as InputElement).onClick.listen((e) => cleanup());
  new Timer.periodic(new Duration(milliseconds: 500), (e) => canvas());
}

void printresize() {
  var innerwidth = window.innerWidth;
  var innerheight = window.innerHeight;
  querySelector("#innerwidth").text = "Inner width: $innerwidth";
  querySelector("#innerheight").text = "Inner height: $innerheight";
}

void eancheck() {
  InputElement eaninput = querySelector("#eaninput");
  String inp = eaninput.value;
  
  // Do *1
  int onevalues = 0;
  for (int i = 0; i < inp.length; i += 2) {
    onevalues += int.parse(inp[i], onError: (e) { return 0; });
  }
  
  // Do 3*
  int threevalues = 0;
  for (int i = 1; i < inp.length; i+= 2) {
    threevalues += int.parse(inp[i], onError: (e) { return 0; }) * 3;
  }
  
  int checksum = onevalues + threevalues;
  
  Element val = querySelector("#validity");
  val.replaceWith(valcheck(checksum, 10, "validity", 13, inp));
}

void isbncheck() {
  int numparse(String x) {
    if (x.toUpperCase() == "X") {
      return 10;
    }
    return int.parse(x, onError: (e) { return 0; });
  }
  InputElement isbninput = querySelector("#isbninput");
  String inp = isbninput.value;
  
  int checksum = 0;
  int fact = 10;
  for (int i = 0; i < inp.length; i++) {
    checksum += numparse(inp[i]) * fact;
    fact--;
  }
  
  Element val = querySelector("#isbnvalidity");
  val.replaceWith(valcheck(checksum, 11, "isbnvalidity", 10, inp));
}

Element valcheck(int checksum, int mod, String id, int length, String input) {
  Element ret = new Element.p();
  ret.id = id;
  if (checksum % mod == 0 && input.length == length) {
    ret.text = "Valid";
    ret.style.color = "#669900";
  }
  else {
    ret.text = "Invalid";
    ret.style.color = "#CC0000";
  }
  return ret;
}

void cleanup() {
  (querySelector("#hammingmessage") as InputElement).value = 1011.toString();
  (querySelector("#hammingparity") as InputElement).value = "";
  querySelector("#correctedcode").text = "Corrected code:";
}

final List<List<int>> circles = [ [0, 1, 3],
                                  [0, 2, 3],
                                  [1, 2, 3] ];

void calcParity() {
  String sParities = "";
  String message = (querySelector("#hammingmessage") as InputElement).value;

  void add(List<int> indexes) {
    int total = 0;
    indexes.forEach((E) => total += int.parse(message[E]));
    sParities += (total % 2).toString();
  }
  circles.forEach(add);
  
  (querySelector("#hammingparity") as InputElement).value = sParities;
}

void correct() {
  String message = (querySelector("#hammingmessage") as InputElement).value;
  String parities = (querySelector("#hammingparity") as InputElement).value;
  String correctedcode = getCorrected(message + parities);
  querySelector("#correctedcode").text = "Corrected code: $correctedcode";
}

String getCorrected(String inp) {
  List<int> errors = new List<int>();
  int total;
  String corrected = inp;
  
  int index = 4;
  
  void check(List<int> indexes) {
    total = 0;
    indexes.forEach((E) => total += int.parse(inp[E]));
    if (!(total % 2 == int.parse(inp[index]))) {
      errors.add(index);
    }
    index++;
  }
  
  circles.forEach(check);
  
  switch (errors.length) {
    case 1:
      corrected = inp.substring(0, errors[0]);
      corrected += (1 - int.parse(inp[errors[0]])).toString();
      corrected += inp.substring(errors[0] + 1);
      break;
    case 2:
      switch (errors[0] + errors[1]) {
        case 9:
          corrected = (1 - int.parse(inp[0])).toString();
          corrected += inp.substring(1);
          break;
        case 11:
          corrected = inp.substring(0, 2);
          corrected += (1 - int.parse(inp[2])).toString();
          corrected += inp.substring(3);
          break;
        case 10:
          corrected = inp[0];
          corrected += (1 - int.parse(inp[1])).toString();
          corrected += inp.substring(2);
          break;
      }
      break;
    case 3:
      corrected = inp.substring(0, 3);
      corrected += (1 - int.parse(inp[3])).toString();
      corrected += inp.substring(4);
      break;
  }
  
  return corrected;
}

CanvasRenderingContext2D context = (querySelector("#canvas") as CanvasElement).context2D;

void canvas() {
  context.clearRect(0, 0, context.canvas.width, context.canvas.height);
  context.font = 'normal 15px Verdana';
  List<String> colors = [ "Rd", "Bl", "Br" ];
  List chain = new List();
  List temp = new List();
  final random = new Random();
  for (int i = 0; i < 30; i++) {
    temp = new List();
    for (int z = -1; z < random.nextInt(28); z++) {
      temp.add(colors[random.nextInt(colors.length)]);
    }
    chain.add(temp);
  }
  drawchain(chain);
}

drawchain(List chain) {
  int X = 20;
  int Y = 20;
  for (int i = 0; i < chain.length; i++) {
    doElement(chain[i], X, Y);
    X += 20;
  }
}

void doElement(List element, int x, int y) {
  for (int i = 0; i < element.length; i++) {
    context.fillText(element[i].toString(), x, y);
    y += 20;
  }
}