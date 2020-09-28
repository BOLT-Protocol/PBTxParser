part of 'notification_cubit.dart';

enum NotificationType {
  loading,
  empty,
}

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationStatus extends NotificationState {
  final NotificationType type;

  NotificationStatus({this.type});

  NotificationStatus copywith({NotificationType type}) {
    return NotificationStatus(type: type ?? this.type);
  }

  @override
  List<Object> get props => [type];
}
