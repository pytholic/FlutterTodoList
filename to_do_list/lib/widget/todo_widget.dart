import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/model/todo.dart';
import 'package:to_do_list/provider/todos.dart';
import 'package:to_do_list/utils.dart';
import 'package:to_do_list/page/edit_todo_page.dart';
import 'dart:math';
import 'dart:ui' as ui;

final todoColors = [
  Colors.amber.shade100,
  Colors.lightGreen.shade100,
  Colors.lightBlue.shade100,
  Colors.indigo.shade100,
  Colors.red.shade100,
  Colors.teal.shade100,
  Colors.brown.shade100
];

final titleColors = [
  Colors.amber.shade800,
  Colors.lightGreen.shade800,
  Colors.lightBlue.shade700,
  Colors.indigo.shade700,
  Colors.red.shade700,
  Colors.teal.shade700,
  Colors.brown.shade700
];

// Random random = new Random();
// int index = random.nextInt(6);

class TodoWidget extends StatelessWidget {
  final Todo todo;

  const TodoWidget({
    required this.todo,
    required this.index,
    Key? key,
  }) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Slidable(
          actionPane: SlidableDrawerActionPane(),
          key: Key(todo.id),
          actions: [
            IconSlideAction(
              color: Colors.green.withOpacity(0.8),
              onTap: () => editTodo(context, todo),
              caption: 'Edit',
              icon: Icons.edit,
            )
          ],
          secondaryActions: [
            IconSlideAction(
              color: Colors.red.withOpacity(0.8),
              caption: 'Delete',
              onTap: () => deleteTodo(context, todo),
              icon: Icons.delete,
            )
          ],
          child: buildTodo(context),
        ),
      );

  Widget buildTodo(BuildContext context) {
    final color = todoColors[index % todoColors.length];
    final color_title = titleColors[index % titleColors.length];
    return GestureDetector(
      onTap: () => editTodo(context, todo),
      child: Container(
        color: color,
        //color: //Colors.primaries[Random().nextInt(Colors.primaries.length)],
        //todoColors[index],
        //color: todoColors[], // Todo box background color
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            Checkbox(
              activeColor:
                  color_title, //Colors.teal[300], //.of(context).primaryColor,
              checkColor: Colors.white,
              value: todo.isDone,
              onChanged: (_) {
                final provider =
                    Provider.of<TodosProvider>(context, listen: false);
                final isDone = provider.toggleTodoStatus(todo);

                Utils.showSnackBar(
                  context,
                  isDone ? 'Task completed' : 'Task marked incomplete',
                );
              },
            ),
            const SizedBox(width: 20),
            //Container(width: 20, color: Colors.amber[100]),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    todo.title,
                    style: TextStyle(
                      // foreground: Paint()
                      //   ..shader = ui.Gradient.linear(
                      //     const Offset(0, 20),
                      //     const Offset(150, 20),
                      //     <Color>[
                      //       color_title,
                      //       Colors.yellow,
                      //     ],
                      //   ),
                      fontWeight: FontWeight.bold,
                      color: color_title,
                      fontSize: 24,
                    ),
                  ),
                  if (todo.description.isNotEmpty)
                    Container(
                      margin: EdgeInsets.only(top: 4),
                      child: Text(
                        todo.description,
                        style: TextStyle(fontSize: 20, height: 1.5),
                      ),
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void deleteTodo(BuildContext context, Todo todo) {
    final provider = Provider.of<TodosProvider>(context, listen: false);
    provider.removeTodo(todo);
    Utils.showSnackBar(context, 'Deleted the task');
  }

  void editTodo(BuildContext context, Todo todo) => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => EditTodoPage(todo: todo),
        ),
      );
}
