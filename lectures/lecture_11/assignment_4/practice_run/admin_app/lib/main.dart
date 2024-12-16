import 'dart:ui';

import 'package:admin_app/christmas_theme.dart';
import 'package:admin_app/example/view/example_page.dart';
import 'package:admin_app/items/items.dart';
import 'package:client_repositories/async_http_repos.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

enum AuthStatus {
  unauthenticated,
  authenticating,
  authenticated,
}

class AuthCubit extends HydratedCubit<AuthStatus> {
  AuthCubit() : super(AuthStatus.unauthenticated);

  Future<void> login() async {
    try {
      // Simulate API call
      emit(AuthStatus.authenticating);
      await Future.delayed(const Duration(seconds: 2));
      emit(AuthStatus.authenticated);
    } catch (e) {
      emit(AuthStatus.unauthenticated);
      // You could add error handling here
    }
  }

  void logout() {
    emit(AuthStatus.unauthenticated);
  }

  @override
  AuthStatus? fromJson(Map<String, dynamic> json) {
    final status = json['status'] as String?;
    return status == 'authenticated'
        ? AuthStatus.authenticated
        : AuthStatus.unauthenticated;
  }

  @override
  Map<String, dynamic>? toJson(AuthStatus state) {
    return {
      'status': switch (state) {
        AuthStatus.unauthenticated ||
        AuthStatus.authenticating =>
          "unauthenticated",
        AuthStatus.authenticated => "authenticated",
      }
    };
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getApplicationDocumentsDirectory(),
  );
  runApp(BlocProvider(create: (context) => AuthCubit(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Items Managing App',
        theme: ChristmasTheme.theme,
        home: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
          }),
          child: const AuthViewSwitcher(),
        ));
  }
}

class AuthViewSwitcher extends StatelessWidget {
  const AuthViewSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoggedIn =
        context.watch<AuthCubit>().state == AuthStatus.authenticated;

    return Scaffold(
        body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeOut,
            transitionBuilder: (child, animation) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            },
            child: isLoggedIn ? const NavRailView() : LoginView()));
  }
}

class LoginView extends StatelessWidget {
  LoginView({
    super.key,
  });

  final _key = GlobalKey<FormState>();

  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  save(BuildContext context) {
    if (_key.currentState!.validate()) {
      context.read<AuthCubit>().login();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authStatus = context.watch<AuthCubit>().state;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _usernameFocus.requestFocus();
    });
    return Center(
        child: Form(
      key: _key,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              focusNode: _usernameFocus,
              enabled: authStatus != AuthStatus.authenticating,
              decoration: const InputDecoration(labelText: 'Username'),
              validator: (value) => value == null || value.isEmpty
                  ? 'Please enter a username'
                  : null,
              onFieldSubmitted: (_) => _passwordFocus.requestFocus(),
            ),
            const SizedBox(height: 16),
            TextFormField(
              focusNode: _passwordFocus,
              obscureText: true,
              enabled: authStatus != AuthStatus.authenticating,
              decoration: const InputDecoration(labelText: 'Password'),
              validator: (value) => value == null || value.isEmpty
                  ? 'Please enter a password'
                  : null,
              onFieldSubmitted: (_) => save(context),
            ),
            const SizedBox(height: 16),
            authStatus == AuthStatus.authenticating
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () => save(context),
                    child: const Text('Login'),
                  ),
          ],
        ),
      ),
    ));
  }
}

class NavRailView extends StatefulWidget {
  const NavRailView({super.key});

  @override
  State<NavRailView> createState() => _NavRailViewState();
}

class _NavRailViewState extends State<NavRailView> {
  int _selectedIndex = 0;
  NavigationRailLabelType labelType = NavigationRailLabelType.all;

  final List<NavigationDestination> destinations = const [
    NavigationDestination(
      icon: Icon(Icons.favorite_border),
      selectedIcon: Icon(Icons.favorite),
      label: 'Items',
    ),
    NavigationDestination(
      icon: Icon(Icons.bookmark_border),
      selectedIcon: Icon(Icons.book),
      label: 'Example',
    ),
    NavigationDestination(
      icon: Icon(Icons.star_border),
      selectedIcon: Icon(Icons.star),
      label: 'Example',
    ),
  ];

  var views = [
    const ItemsView(),
    const ExampleView(
      index: 1,
    ),
    const ExampleView(
      index: 2,
    )
  ];

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ItemRepository>(
          create: (context) => ItemRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ItemsBloc(
              itemRepository: context.read<ItemRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => SelectionCubit(),
          ),
        ],
        child: LayoutBuilder(builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            return Column(
              children: [
                Expanded(
                  child: IndexedStack(
                    key: const GlobalObjectKey("indexedStack"),
                    index: _selectedIndex,
                    children: views,
                  ),
                ),
                NavigationBar(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (index) {
                    setState(() => _selectedIndex = index);
                  },
                  destinations: destinations,
                ),
              ],
            );
          }
          return Row(
            children: [
              NavigationRail(
                extended: constraints.maxWidth >= 800,
                selectedIndex: _selectedIndex,
                onDestinationSelected: (index) {
                  setState(() => _selectedIndex = index);
                },
                trailing: Expanded(
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Material(
                        child: TextButton(
                          child: const Text('Logout'),
                          onPressed: () => context.read<AuthCubit>().logout(),
                        ),
                      ),
                    ),
                  ),
                ),
                destinations: destinations
                    .map((e) => NavigationRailDestination(
                          icon: e.icon,
                          selectedIcon: e.selectedIcon,
                          label: Text(e.label),
                        ))
                    .toList(),
              ),
              Expanded(
                child: IndexedStack(
                  key: const GlobalObjectKey("indexedStack"),
                  index: _selectedIndex,
                  children: views,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
