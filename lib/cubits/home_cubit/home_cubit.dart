import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/cubits/home_cubit/home_state.dart';
import 'package:todo_app/widgets/archived_tasks_body.dart';
import 'package:todo_app/widgets/done_tasks_body.dart';
import 'package:todo_app/widgets/new_tasks_body.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  static HomeCubit get(context) => BlocProvider.of(context);

  int currentNavigationBarIndex = 0;
  final List<Widget> viewBodies = [
    const NewTasksBody(),
    const DoneTasksBody(),
    const ArchivedTasksBody(),
  ];
  final List<String> viewTitles = [
    'Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  void changeBottomNavigationBarIndex(int index) {
    currentNavigationBarIndex = index;
    emit(HomeChangeBottomNavigationBarIndex());
  }

  late final Database database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  void createDatabase() async {
    try {
      database = await openDatabase(
        'TodoApp.db',
        version: 1,
        onCreate: (database, version) async {
          await database.execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date Text, time Text, status Text)');
        },
        onOpen: (database) async {
          try {
            getDataFromDatabase(database: database);

            emit(HomeGetDataFromDatabaseState());
          } on Exception catch (e) {
            throw Exception(e.toString());
          }
        },
      );

      emit(HomeCreateDatabaseState());
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  insertToDatabase({
    required String taskTitle,
    required String taskDate,
    required String taskTime,
    required String taskStatus,
  }) async {
    try {
      await database.transaction(
        (txn) => txn.rawInsert(
          'INSERT INTO tasks(title, date, time, status) VALUES("$taskTitle", "$taskDate","$taskTime","$taskStatus")',
        ),
      );
      getDataFromDatabase(database: database);
      emit(HomeInsertToDatabaseState());
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  getDataFromDatabase({
    required Database database,
  }) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    emit(HomeGetDatabaseLoadingState());
    database.rawQuery('SELECT * FROM tasks').then(
          (value) => {
            value.forEach(
              (element) {
                if (element["status"] == "new") {
                  newTasks.add(element);
                } else if (element["status"] == "Done") {
                  doneTasks.add(element);
                } else if (element["status"] == "Archived") {
                  archivedTasks.add(element);
                }
              },
            ),
          },
        );
  }

  void updateDataToDatabase({
    required String status,
    required int id,
  }) async {
    try {
      await database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        [status, id],
      );

      getDataFromDatabase(database: database);
      emit(HomeUpdateDataToDatabaseState());
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Icon floatingActionBottomIcon = const Icon(
    Icons.edit_outlined,
    color: Colors.white,
  );
  bool isBottomSheetShown = false;

  void changeBottomSheetState({
    required bool isShown,
    required Icon icon,
  }) {
    isBottomSheetShown = isShown;
    floatingActionBottomIcon = icon;

    emit(HomeChangeBottomSheetState());
  }

  void deleteFromDataBase({
    required int id,
  }) async {
    try {
      await database.rawDelete(
        'DELETE FROM tasks WHERE id = ?',
        [id],
      );

      getDataFromDatabase(database: database);
      emit(HomeDeleteFromDataBaseState());
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }
}
