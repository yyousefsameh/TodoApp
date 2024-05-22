import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/cubits/home_cubit/home_cubit.dart';
import 'package:todo_app/cubits/home_cubit/home_state.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});
  final TextEditingController? taskTitleController = TextEditingController();
  final TextEditingController? taskTimeController = TextEditingController();
  final TextEditingController? taskDateController = TextEditingController();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state is HomeInsertToDatabaseState) {
          Navigator.pop(context);
          taskTitleController!.clear();
          taskDateController!.clear();
          taskTimeController!.clear();
        }
      },
      builder: (context, state) {
        return ConditionalBuilder(
          fallback: (context) => HomeCubit.get(context).newTasks.isNotEmpty
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.blue,
                  ),
                )
              : Container(),
          condition: state is! HomeGetDatabaseLoadingState,
          builder: (context) => Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.blue,
              title: Text(
                HomeCubit.get(context).viewTitles[
                    HomeCubit.get(context).currentNavigationBarIndex],
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            body: HomeCubit.get(context)
                .viewBodies[HomeCubit.get(context).currentNavigationBarIndex],
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.blue,
              child: HomeCubit.get(context).floatingActionBottomIcon,
              onPressed: () {
                if (HomeCubit.get(context).isBottomSheetShown) {
                  if (formKey.currentState!.validate()) {
                    HomeCubit.get(context).insertToDatabase(
                      taskTitle: taskTitleController!.text,
                      taskDate: taskDateController!.text,
                      taskTime: taskTimeController!.text,
                      taskStatus: 'new',
                    );
                  }
                } else {
                  scaffoldKey.currentState!
                      .showBottomSheet(
                        elevation: 15.0,
                        (context) => Container(
                          padding: const EdgeInsets.all(8.0),
                          color: Colors.white,
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormField(
                                  cursorColor: Colors.blue,
                                  controller: taskTitleController,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      borderSide: const BorderSide(
                                        color: Colors.blue,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      borderSide: const BorderSide(
                                        color: Colors.blue,
                                      ),
                                    ),
                                    labelText: 'Task Title',
                                    labelStyle: const TextStyle(
                                      color: Colors.blue,
                                    ),
                                    prefixIcon: const Icon(
                                      Icons.title_outlined,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  validator: (taskTitleData) {
                                    if (taskTitleData!.isEmpty) {
                                      return 'Please enter task title';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  cursorColor: Colors.blue,
                                  controller: taskTimeController,
                                  keyboardType: TextInputType.datetime,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      borderSide: const BorderSide(
                                        color: Colors.blue,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      borderSide: const BorderSide(
                                        color: Colors.blue,
                                      ),
                                    ),
                                    labelText: 'Task Time',
                                    labelStyle: const TextStyle(
                                      color: Colors.blue,
                                    ),
                                    prefixIcon: const Icon(
                                      Icons.timer_outlined,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  validator: (taskTitleData) {
                                    if (taskTitleData!.isEmpty) {
                                      return 'Please enter task time';
                                    }
                                    return null;
                                  },
                                  onTap: () async {
                                    TimeOfDay? pickedTime =
                                        await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    );
                                    if (pickedTime != null) {
                                      taskTimeController?.text =
                                          pickedTime.format(context).toString();
                                    }
                                  },
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  cursorColor: Colors.blue,
                                  controller: taskDateController,
                                  keyboardType: TextInputType.datetime,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      borderSide: const BorderSide(
                                        color: Colors.blue,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      borderSide: const BorderSide(
                                        color: Colors.blue,
                                      ),
                                    ),
                                    labelText: 'Task Date',
                                    labelStyle: const TextStyle(
                                      color: Colors.blue,
                                    ),
                                    prefixIcon: const Icon(
                                      Icons.calendar_today_outlined,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  validator: (taskTitleData) {
                                    if (taskTitleData!.isEmpty) {
                                      return 'Please enter task Date';
                                    }
                                    return null;
                                  },
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.parse('2100-12-31'),
                                    );

                                    if (pickedDate != null) {
                                      taskDateController?.text =
                                          DateFormat.yMd().format(pickedDate);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .closed
                      .then(
                    (value) {
                      HomeCubit.get(context).changeBottomSheetState(
                        isShown: false,
                        icon: const Icon(
                          Icons.edit_outlined,
                          color: Colors.white,
                        ),
                      );
                    },
                  );
                  HomeCubit.get(context).changeBottomSheetState(
                    isShown: true,
                    icon: const Icon(
                      Icons.add_outlined,
                      color: Colors.white,
                    ),
                  );
                }
              },
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: HomeCubit.get(context).currentNavigationBarIndex,
              showSelectedLabels: true,
              selectedItemColor: Colors.blue,
              unselectedItemColor: Colors.grey,
              onTap: (index) {
                HomeCubit.get(context).changeBottomNavigationBarIndex(index);
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu_outlined),
                  label: 'Tasks',
                  activeIcon: Icon(Icons.menu),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle_outline),
                  label: 'Done',
                  activeIcon: Icon(Icons.check_circle),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive_outlined),
                  label: 'Archived',
                  activeIcon: Icon(Icons.archive),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
