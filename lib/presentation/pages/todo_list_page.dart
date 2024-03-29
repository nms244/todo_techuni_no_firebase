import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_techuni_no_firebase/presentation/widgets/dialog/confirm_dialog.dart';
import 'package:todo_techuni_no_firebase/presentation/widgets/dialog/text_field_dialig.dart';
import 'package:todo_techuni_no_firebase/use_case/todo/notifier/todo_notifier.dart';

class TodoListPage extends HookConsumerWidget {
  const TodoListPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(todoNotifierProvider);
    final notifier = ref.read(todoNotifierProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tech.Uni'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.add,
            ),
            onPressed: () async {
              final String value = await showTextFieldDialog(context: context);
              await notifier.addTodo(description: value);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                      onLongPress: () async {
                        final bool isDeleted =
                            await showConfirmDialog(context: context);
                        isDeleted == true
                            ? await notifier.deleteTodo(
                                data: state.todoList[index],
                              )
                            : null;
                      },
                      child: Card(
                        child: Padding(
                          child: Text(
                            state.todoList[index].description,
                            style: const TextStyle(fontSize: 22.0),
                          ),
                          padding: const EdgeInsets.all(20.0),
                        ),
                      ));
                },
                itemCount: state.todoList.length,
              ),
            )
          ],
        ),
      ),
    );
  }
}
