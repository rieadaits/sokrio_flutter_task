import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sokrio_flutter_task/src/presentation/bloc/bloc/user_bloc.dart';
import 'package:sokrio_flutter_task/src/presentation/pages/helpers/ui_helpers.dart';
import 'package:sokrio_flutter_task/src/presentation/pages/home_page/user_details_page.dart';
import 'package:sokrio_flutter_task/src/presentation/pages/home_page/widgets/users_list_item.dart';
import 'package:sokrio_flutter_task/src/presentation/pages/home_page/widgets/shimmer_loading_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _loadRepositories();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _loadRepositories() {
    context.read<UserBloc>().add(const FetchUsers());
  }

  void _onSearchChanged(String query) {
    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) {
      // Clear search and load default Flutter repositories
      context.read<UserBloc>().add(const ClearSearch());
    } else {
      // Search for the specified query
      context.read<UserBloc>().add(SearchUsers(trimmedQuery));
    }
  }

  void _clearSearch() {
    _searchController.clear();
    context.read<UserBloc>().add(const ClearSearch());
  }

  void _loadMoreRepositories() {
    if (!_isLoadingMore) {
      _isLoadingMore = true;
      // Check the actual search field text, not just the state
      if (_searchController.text.trim().isNotEmpty) {
        context.read<UserBloc>().add(const LoadMoreUsers());
      } else {
        context.read<UserBloc>().add(const LoadMoreUsers());
      }
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreRepositories();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sokrio Users'), centerTitle: false),
      body: Column(
        children: [
          // Search Field
          Container(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search by user name...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: _clearSearch,
                      )
                    : null,
              ),
            ),
          ),
          // Content
          Expanded(
            child: BlocConsumer<UserBloc, UserState>(
              listener: (context, state) {
                if (state is UserLoaded) {
                  _isLoadingMore = state.isLoadingMore;
                } else if (state is UserError) {
                  UiHelpers.showToast(message: state.message);
                  _isLoadingMore = false;
                }
              },
              builder: (context, state) {
                if (state is UserLoading) {
                  return const ShimmerListUI();
                } else if (state is UserLoaded) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      if (_searchController.text.trim().isNotEmpty) {
                        context.read<UserBloc>().add(
                          SearchUsers(_searchController.text.trim()),
                        );
                      } else {
                        context.read<UserBloc>().add(FetchUsers());
                      }
                    },
                    child: state.users.isEmpty && state.serarchedUsers.isEmpty
                        ? _buildEmptyState(state.isSearching)
                        : ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: state.isSearching
                                ? state.serarchedUsers.length
                                : state.users.length + 1,
                            itemBuilder: (context, index) {
                              if (index == state.users.length) {
                                return _buildLoadingFooter(state);
                              }

                              final user = state.isSearching
                                  ? state.serarchedUsers[index]
                                  : state.users[index];
                              return UserListItem(
                                user: user,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    _createSlideRoute(
                                      UserDetailsPage(userEntity: user),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                  );
                } else if (state is UserError) {
                  return _buildErrorState(state.message);
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isSearching) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSearching ? Icons.search_off : Icons.inbox_outlined,
              size: 80,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              isSearching ? 'No users found' : 'No users available',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              isSearching
                  ? 'Try searching with different keywords'
                  : 'Pull to refresh or try again later',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingFooter(UserLoaded state) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: state.isLoadingMore
            ? const CircularProgressIndicator()
            : state.hasReachedMax
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'No more users to load',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 80, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadRepositories,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Route _createSlideRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
