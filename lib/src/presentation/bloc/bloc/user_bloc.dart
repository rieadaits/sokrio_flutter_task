import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sokrio_flutter_task/src/domain/entities/user_entity.dart';
import 'package:sokrio_flutter_task/src/domain/use_cases/get_users_use_case.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUsersUseCase getUsersUseCase;
  int _currentPage = 1;
  static const int _itemsPerPage = 10;

  UserBloc({required this.getUsersUseCase}) : super(UserInitial()) {
    on<FetchUsers>(_loadUsers);
    on<LoadMoreUsers>(_loadMoreUsers);
  }

  Future<void> _loadUsers(FetchUsers event, Emitter<UserState> emit) async {
    emit(UserLoading());
    _currentPage = 1;
    final result = await getUsersUseCase.call(
      GetUsersParams(pageNumber: _currentPage, perPageItems: _itemsPerPage),
    );
    result.fold(
      (failure) => emit(UserError(failure.message)),
      (users) => emit(
        UserLoaded(
          users: users,
          hasReachedMax: users.length < _itemsPerPage,
        ),
      ),
    );
  }

    Future<void> _loadMoreUsers(
    LoadMoreUsers event,
    Emitter<UserState> emit,
  ) async {
    if (state is UserLoaded) {
      final currentState = state as UserLoaded;
      if (!currentState.hasReachedMax) {
        emit(currentState.copyWith(isLoadingMore: true));
        _currentPage++;

        final result = await getUsersUseCase.call(
          GetUsersParams(pageNumber: _currentPage, perPageItems: _itemsPerPage),
        );
        result.fold(
          (failure) => emit(UserError(failure.message)),
          (newUsers) {
            if (newUsers.isEmpty) {
              emit(currentState.copyWith(
                hasReachedMax: true,
                isLoadingMore: false,
              ));
            } else {
              emit(UserLoaded(
                users: [...currentState.users, ...newUsers],
                hasReachedMax: newUsers.length < _itemsPerPage,
                isLoadingMore: false,
              ));
            }
          },
        );
      }
    }
  }
}

