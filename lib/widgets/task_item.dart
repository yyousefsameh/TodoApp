import 'package:flutter/material.dart';
import 'package:todo_app/cubits/home_cubit/home_cubit.dart';

class TaskItem extends StatelessWidget {
  const TaskItem({super.key, required this.taskModel});

  final Map taskModel;
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(
        taskModel["id"].toString(),
      ),
      background: Container(
        color: Colors.red,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.only(
                right: 20.0,
              ),
              child: Text(
                "delete",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
            ),
          ],
        ),
      ),
      onDismissed: (direction) {
        HomeCubit.get(context).deleteFromDataBase(
          id: taskModel["id"],
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue,
              radius: 40.0,
              child: Text(
                taskModel["time"],
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 10.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  taskModel["title"],
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  taskModel["date"],
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(
                Icons.check_box_outlined,
                color: Colors.green,
                size: 28.0,
              ),
              onPressed: () {
                HomeCubit.get(context).updateDataToDatabase(
                  status: "Done",
                  id: taskModel["id"],
                );
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.archive_outlined,
                color: Colors.blue,
                size: 28.0,
              ),
              onPressed: () {
                HomeCubit.get(context).updateDataToDatabase(
                  status: "Archived",
                  id: taskModel["id"],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
