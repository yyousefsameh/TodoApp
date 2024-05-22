import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubits/home_cubit/home_cubit.dart';
import 'package:todo_app/cubits/home_cubit/home_state.dart';
import 'package:todo_app/widgets/task_item.dart';

class NewTasksBody extends StatelessWidget {
  const NewTasksBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return ConditionalBuilder(
          condition: HomeCubit.get(context).newTasks.isNotEmpty,
          builder: (context) => ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) => TaskItem(
              taskModel: HomeCubit.get(context).newTasks[index],
            ),
            separatorBuilder: (context, index) => Divider(
              indent: 20.0,
              color: Colors.grey[300],
            ),
            itemCount: HomeCubit.get(context).newTasks.length,
          ),
          fallback: (context) => const Center(
            child: Text("No Tasks Yet, Please Add Some Tasks"),
          ),
        );
      },
    );
  }
}
