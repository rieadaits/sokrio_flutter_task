part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final List<UserEntity> users;
  final bool hasReachedMax;
  final bool isLoadingMore;

  const UserLoaded({
    required this.users,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
  });

  UserLoaded copyWith({
    List<UserEntity>? users,
    bool? hasReachedMax,
    bool? isLoadingMore,
  }) {
    return UserLoaded(
      users: users ?? this.users,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [users, hasReachedMax, isLoadingMore];
}

class UserError extends UserState {
  final String message;

  const UserError(this.message);

  @override
  List<Object?> get props => [message];
} 