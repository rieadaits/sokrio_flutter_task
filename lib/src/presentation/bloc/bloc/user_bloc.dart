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
    on<SearchUsers>(_searchUsers);
    on<ClearSearch>(_onClearSearch);
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
        UserLoaded(users: users, hasReachedMax: users.length < _itemsPerPage),
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
        result.fold((failure) => emit(UserError(failure.message)), (newUsers) {
          if (newUsers.isEmpty) {
            emit(
              currentState.copyWith(hasReachedMax: true, isLoadingMore: false),
            );
          } else {
            emit(
              UserLoaded(
                users: [...currentState.users, ...newUsers],
                hasReachedMax: newUsers.length < _itemsPerPage,
                isLoadingMore: false,
              ),
            );
          }
        });
      }
    }
  }

  Future<void> _searchUsers(SearchUsers event, Emitter<UserState> emit) async {
    final currentState = state as UserLoaded;
    final searchQuery = event.query;
    if (searchQuery.isEmpty) {
      emit(currentState.copyWith(isSearching: false, searchQuery: ''));
      return;
    } else {
      final localUsers = currentState.users.toList();
     final searchedUsers = localUsers.where((user) {
        final fullName = '${user.firstName} ${user.lastName}';
        return fullName.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
      emit(
        currentState.copyWith(
          serarchedUsers: searchedUsers,
          isSearching: true,
          searchQuery: searchQuery,
        ),
      );
    }
  }

  Future<void> _onClearSearch(
    ClearSearch event,
    Emitter<UserState> emit,
  ) async {
    if (state is UserLoaded) {
      emit((state as UserLoaded).copyWith(isSearching: false, searchQuery: ''));
    }
  }
}
