import 'dart:ui';

import 'package:admin_app/bloc/items_bloc.dart';
import 'package:admin_app/christmas_theme.dart';
import 'package:admin_app/cubit/selected_item_cubit.dart';
import 'package:admin_app/firebase_options.dart';
import 'package:admin_app/views/example_view.dart';
import 'package:admin_app/views/items_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_repositories/firebase_repositories.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

enum AuthStatus {
  unauthenticated,
  authenticating,
  authenticated,
}

class AuthCubit extends HydratedCubit<AuthStatus> {
  AuthCubit() : super(AuthStatus.unauthenticated);

  login() async {
    emit(AuthStatus.authenticating);

    try {
      // Simulate API call
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
    return switch (json["authenticated"]) {
      // TODO: Handle this case.
      true => AuthStatus.authenticated,
      // TODO: Handle this case.
      _ => AuthStatus.unauthenticated,
    };
  }

  @override
  Map<String, dynamic>? toJson(AuthStatus state) {
    return {
      "authenticated": switch (state) {
        AuthStatus.unauthenticated || AuthStatus.authenticating => false,
        AuthStatus.authenticated => true,
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

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
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
          behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse}),
          child: AuthViewSwitcher()),
    );
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
            duration: Duration(milliseconds: 500),
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
            child: isLoggedIn ? NavRailView() : LoginView()));
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

class NavRailView extends StatelessWidget {
  NavRailView({super.key});

  final ValueNotifier<int> _selectedIndex = ValueNotifier(0);

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

  final views = [
    ItemsView(),
    const ExampleView(
      index: 1,
    ),
    const ExampleView(
      index: 2,
    )
  ];

  @override
  Widget build(BuildContext context) {
    // TODO #5: Implement responsive navigation
    // - Add LayoutBuilder to switch between NavigationRail and NavigationBar
    // - Handle different layouts for <600px, >600px, >800px

    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) =>
                ItemsBloc(repository: ItemRepository())..add(LoadItems())),
        BlocProvider(create: (context) => SelectedItemCubit())
      ],
      child: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return Column(
            children: [
              Expanded(
                child: ValueListenableBuilder(
                    valueListenable: _selectedIndex,
                    builder: (context, index, _) {
                      return IndexedStack(
                        key: const GlobalObjectKey("indexedStack"),
                        index: index,
                        children: views,
                      );
                    }),
              ),
              NavigationBar(
                selectedIndex: _selectedIndex.value,
                onDestinationSelected: (index) {
                  _selectedIndex.value = index;
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
              selectedIndex: _selectedIndex.value,
              onDestinationSelected: (index) {
                _selectedIndex.value = index;
              },
              trailing: Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Material(
                      child: IconButton(
                        icon: const Icon(Icons.logout),
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
                key: GlobalObjectKey("indexedStack"),
                index: _selectedIndex.value,
                children: views,
              ),
            ),
          ],
        );
      }),
    );
  }
}

















































/* 

import 'package:admin_app/christmas_theme.dart';
import 'package:admin_app/views/example_view.dart';
import 'package:admin_app/views/items_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthService(),
      child: const MyApp(),
    ),
  );
}

enum AuthStatus {
  unauthenticated,
  authenticating,
  authenticated,
}

class AuthService extends ChangeNotifier {
  AuthStatus _status = AuthStatus.unauthenticated;
  AuthStatus get status => _status;

  Future<void> login() async {
    _status = AuthStatus.authenticating;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      _status = AuthStatus.authenticated;
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      // You could add error handling here
    }
    notifyListeners();
  }

  void logout() {
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Items Managing App',
         theme: ChristmasTheme.theme,
      home: const AuthViewSwitcher(),
    );
  }
}

class AuthViewSwitcher extends StatelessWidget {
  const AuthViewSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final authStatus = context.watch<AuthService>().status;

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeOutCubic,
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        child: authStatus == AuthStatus.authenticated
            ? const ResponsiveNavigationView()
            : const LoginView(),
      ),
    );
  }
}

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final usernameFocus = FocusNode();
    final passwordFocus = FocusNode();
    final authService = context.watch<AuthService>();

    // Request focus only when not authenticating
    if (authService.status == AuthStatus.unauthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        usernameFocus.requestFocus();
      });
    }

    return Center(
      child: Form(
        key: formKey,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome Back',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 32),
              TextFormField(
                focusNode: usernameFocus,
                enabled: authService.status != AuthStatus.authenticating,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter a username' : null,
                onFieldSubmitted: (_) => passwordFocus.requestFocus(),
              ),
              const SizedBox(height: 16),
              TextFormField(
                focusNode: passwordFocus,
                obscureText: true,
                enabled: authService.status != AuthStatus.authenticating,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter a password' : null,
                onFieldSubmitted: (_) {
                  if (formKey.currentState!.validate()) {
                    context.read<AuthService>().login();
                  }
                },
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: authService.status == AuthStatus.authenticating
                    ? const Center(child: CircularProgressIndicator())
                    : FilledButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            context.read<AuthService>().login();
                          }
                        },
                        child: const Text('Login'),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ResponsiveNavigationView extends StatefulWidget {
  const ResponsiveNavigationView({super.key});

  @override
  State<ResponsiveNavigationView> createState() =>
      _ResponsiveNavigationViewState();
}

class _ResponsiveNavigationViewState extends State<ResponsiveNavigationView> {
  int _selectedIndex = 0;

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

  final views = const [
    ItemsView(),
    ExampleView(index: 1),
    ExampleView(index: 2),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            return Column(
              children: [
                Expanded(
                  child: IndexedStack(
                    key: const GlobalObjectKey('IndexedStack'),
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
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: IconButton(
                        icon: const Icon(Icons.logout),
                        onPressed: () => context.read<AuthService>().logout(),
                      ),
                    ),
                  ),
                ),
                destinations: destinations
                    .map(NavigationRailDestinationFactory
                        .fromNavigationDestination)
                    .toList(),
              ),
              Expanded(
                child: IndexedStack(
                  key: const GlobalObjectKey('IndexedStack'),
                  index: _selectedIndex,
                  children: views,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class NavigationRailDestinationFactory {
  static NavigationRailDestination fromNavigationDestination(
    NavigationDestination destination,
  ) {
    return NavigationRailDestination(
      icon: destination.icon,
      selectedIcon: destination.selectedIcon,
      label: Text(destination.label),
    );
  }
}


 */