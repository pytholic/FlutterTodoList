import 'package:flutter/material.dart';

class TodoFormWidget extends StatelessWidget {
  final String title;
  final String description;
  final ValueChanged<String> onChangedTitle;
  final ValueChanged<String> onChangedDescription;
  final VoidCallback onSavedTodo;

  const TodoFormWidget({
    Key? key,
    this.title = '',
    this.description = '',
    required this.onChangedTitle,
    required this.onChangedDescription,
    required this.onSavedTodo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        //color: Colors.black,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildTitle(),
              SizedBox(height: 8),
              buildDescription(),
              SizedBox(height: 32),
              buildButton(),
            ],
          ),
        ),
      );

  Widget buildTitle() => TextFormField(
        maxLines: 1,
        initialValue: title,
        onChanged: onChangedTitle,
        validator: (title) {
          if (title!.isEmpty) {
            return 'The title cannot be empty';
          }
          return null;
        },
        decoration: InputDecoration(
          border: UnderlineInputBorder(),
          labelText: 'Title',
          //fillColor: Colors.black,
          //filled: true,
        ),
      );

  Widget buildDescription() => TextFormField(
        maxLines: 3,
        initialValue: description,
        onChanged: onChangedDescription,
        decoration: InputDecoration(
            border: UnderlineInputBorder(), labelText: 'Description'),
      );

  Widget buildButton() => SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(Colors.orangeAccent[200]),
          ),
          onPressed: onSavedTodo,
          child: Text(
            'Save',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      );
}
