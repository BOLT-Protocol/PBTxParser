import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/notification/notification_cubit.dart';

import 'loading_style.dart';

class TopLayer extends StatefulWidget {
  @override
  _TopLayerState createState() => _TopLayerState();
}

class _TopLayerState extends State<TopLayer> {
  NotificationCubit _cubit;
  @override
  void didChangeDependencies() {
    _cubit = BlocProvider.of<NotificationCubit>(context);
    // _cubit.notify(type: NotificationType.loading);
    super.didChangeDependencies();
  }

  Widget childWidget;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationCubit, NotificationState>(
      builder: (context, state) {
        if (state is NotificationStatus) {
          switch (state.type) {
            case NotificationType.loading:
              childWidget = Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black26,
                child: LoadingStyleLineupDiamond(
                  color: Colors.white,
                ),
              );
              break;
            case NotificationType.empty:
              childWidget = SizedBox();
              break;
          }
        }
        return Container(
          child: childWidget,
        );
      },
    );
  }
}
