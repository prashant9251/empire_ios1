import 'package:empire_ios/screen/TaskList/TaskListCubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskList extends StatefulWidget {
  const TaskList({Key? key}) : super(key: key);

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  late TaskListCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<TaskListCubit>(context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    cubit.isDisposed = true;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskListCubit, TaskListState>(
      builder: (context, state) {
        if (state is TaskListStateLoadData) {
          return state.widget;
        }
        return SizedBox.shrink();
      },
    );
  }
}
