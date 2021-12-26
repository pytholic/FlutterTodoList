import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:to_do_list/model/todo.dart';
import 'package:to_do_list/utils.dart';

class FirebaseApi {
  static Future<String> createTodo(Todo todo) async {
    final docTodo = FirebaseFirestore.instance.collection("todo_haseeb").doc();

    todo.id = docTodo.id;
    await docTodo.set(todo.toJson());

    return docTodo.id;
  }

  static Stream<List<Todo>> readTodos() => FirebaseFirestore.instance
      .collection("todo_haseeb")
      .orderBy(TodoField.createdTime, descending: true)
      .snapshots()
      .transform(Utils.transformer(Todo.fromJson));

  static Future updateTodo(Todo todo) async {
    final docTodo =
        FirebaseFirestore.instance.collection("todo_haseeb").doc(todo.id);

    await docTodo.update(todo.toJson());
  }

  static Future deleteTodo(Todo todo) async {
    final docTodo =
        FirebaseFirestore.instance.collection("todo_haseeb").doc(todo.id);

    await docTodo.delete();
  }
}
