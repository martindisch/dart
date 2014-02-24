import 'dart:html';

InputElement toDoInput;
UListElement toDoList;
ButtonElement deleteAll;

void main() {
  toDoInput = querySelector('#to-do-input');
  toDoList = querySelector('#to-do-list');
  deleteAll = querySelector("#delete-all");
  deleteAll.onClick.listen((e) => toDoList.children.clear());
  toDoInput.onChange.listen(addToDoItem);
  fillList();
}

void addToDoItem(Event e) {
  LIElement newToDo = new LIElement();
  newToDo
    ..text = toDoInput.value
    ..onClick.listen(removeToDoItem);
  toDoInput.value = '';
  toDoList.children.add(newToDo);
}

void removeToDoItem(Event e) {
  LIElement current = e.target;
  current.remove();
}

void fillList() {
  List<String> tasks = [ "Code", "Test", "Publish", "Drink", "Eat", "Watch TV", "Learn", "Repeat" ];
  LIElement newElement;
  for (int i = 0; i < tasks.length; i++) {
    newElement = new LIElement();
    newElement
      ..text = tasks[i]
      ..onClick.listen(removeToDoItem);
    toDoList.children.add(newElement);
  }
}
