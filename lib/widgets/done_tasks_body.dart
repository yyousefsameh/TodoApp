import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubits/home_cubit/home_cubit.dart';
import 'package:todo_app/cubits/home_cubit/home_state.dart';
import 'package:todo_app/widgets/task_item.dart';

class DoneTasksBody extends StatelessWidget {
  const DoneTasksBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return ListView.separated(
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) => TaskItem(
            taskModel: HomeCubit.get(context).doneTasks[index],
          ),
          separatorBuilder: (context, index) => Divider(
            indent: 20.0,
            color: Colors.grey[300],
          ),
          itemCount: HomeCubit.get(context).doneTasks.length,
        );
      },
    );
  }
}
