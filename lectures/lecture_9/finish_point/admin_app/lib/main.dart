import 'package:admin_app/christmas_theme.dart';
import 'package:admin_app/views/example_view.dart';
import 'package:admin_app/views/items_view.dart';
import 'package:flutter/material.dart';

void main() {
  // TODO #3: Set up Provider pattern
  // - Create AuthService class with AuthStatus enum
  // - Wrap MyApp with ChangeNotifierProvider

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Items Managing App',
      theme: ChristmasTheme.theme,
      home: AuthViewSwitcher(),
    );
  }
}

class AuthViewSwitcher extends StatelessWidget {
  AuthViewSwitcher({super.key});

  // TODO #4: Replace ValueNotifier with Provider

  final _isLoggedIn = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<bool>(
          valueListenable: _isLoggedIn,
          builder: (context, isLoggedIn, child) {
            return AnimatedSwitcher(
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
                child: isLoggedIn
                    ? NavRailView(
                        onLogout: () => _isLoggedIn.value = false,
                      )
                    : LoginView(
                        onLogin: () => _isLoggedIn.value = true,
                      ));
          }),
    );
  }
}

class LoginView extends StatelessWidget {
  LoginView({super.key, required this.onLogin});

  final Function() onLogin;

  final _key = GlobalKey<FormState>();

  final ValueNotifier<Future> _loginFuture = ValueNotifier(Future.value(null));

  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  save() {
    if (_key.currentState!.validate()) {
      _loginFuture.value = Future.delayed(const Duration(seconds: 2));
      _loginFuture.value.whenComplete(() {
        onLogin();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: _loginFuture,
        builder: (context, value, _) {
          return FutureBuilder(
              future: value,
              builder: (context, snapshot) {
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
                          enabled: snapshot.connectionState !=
                              ConnectionState.waiting,
                          decoration:
                              const InputDecoration(labelText: 'Username'),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Please enter a username'
                              : null,
                          onFieldSubmitted: (_) =>
                              _passwordFocus.requestFocus(),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          focusNode: _passwordFocus,
                          obscureText: true,
                          enabled: snapshot.connectionState !=
                              ConnectionState.waiting,
                          decoration:
                              const InputDecoration(labelText: 'Password'),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Please enter a password'
                              : null,
                          onFieldSubmitted: (_) => save(),
                        ),
                        const SizedBox(height: 16),
                        snapshot.connectionState == ConnectionState.waiting
                            ? const CircularProgressIndicator()
                            : ElevatedButton(
                                onPressed: () => save(),
                                child: const Text('Login'),
                              ),
                      ],
                    ),
                  ),
                ));
              });
        });
  }
}

class NavRailView extends StatefulWidget {
  const NavRailView({super.key, required this.onLogout});

  final Function() onLogout;

  @override
  State<NavRailView> createState() => _NavRailViewState();
}

class _NavRailViewState extends State<NavRailView> {
  int _selectedIndex = 0;
  NavigationRailLabelType labelType = NavigationRailLabelType.all;

  var destinations = const <NavigationRailDestination>[
    NavigationRailDestination(
      icon: Icon(Icons.favorite_border),
      selectedIcon: Icon(Icons.favorite),
      label: Text('Items'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.bookmark_border),
      selectedIcon: Icon(Icons.book),
      label: Text('Example'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.star_border),
      selectedIcon: Icon(Icons.star),
      label: Text('Example'),
    ),
  ];

  var views = [
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
    return Row(
      children: <Widget>[
        NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            trailing: Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: widget.onLogout,
                  ),
                ),
              ),
            ),
            labelType: NavigationRailLabelType.all,
            destinations: destinations),
        // TODO #1: Replace direct view rendering with IndexedStack for state preservation
        // TODO #6: Add a GlobalObjectKey to avoid rebuilds on widget relocation in the tree
        Expanded(child: views[_selectedIndex])
      ],
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