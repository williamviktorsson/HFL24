import 'dart:ui';

import 'package:admin_app/bloc/auth/auth_bloc.dart';
import 'package:admin_app/bloc/items/items_bloc.dart';
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

  runApp(
    MultiRepositoryProvider(
        providers: [
          RepositoryProvider<ItemRepository>(
              create: (context) => ItemRepository()),
          RepositoryProvider<AuthRepository>(
              create: (context) => AuthRepository()),
          RepositoryProvider<UserRepository>(
              create: (context) => UserRepository()),
        ],
        child: BlocProvider(
            create: (context) => AuthBloc(
                authRepository: context.read<AuthRepository>(),
                userRepository: context.read<UserRepository>())
              ..add(AuthUserSubscriptionRequested()),
            child: const MyApp())),
  );
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
          child: const AuthViewSwitcher()),
    );
  }
}

class AuthViewSwitcher extends StatelessWidget {
  const AuthViewSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;

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
            child: switch (authState) {
              AuthInitial() => Container(),
              Authenticated() => NavRailView(),
              AuthenticatedNoUser(:final authId, :final email) ||
              AuthenticatedNoUserPending(:final authId, :final email) =>
                FinalizeRegistrationWidget(email: email, authId: authId),
              _ => const UnAuthView(),
            }));
  }
}

class FinalizeRegistrationWidget extends StatelessWidget {
  FinalizeRegistrationWidget({
    super.key,
    required this.email,
    required this.authId,
  });

  final String email;
  final String authId;

  final TextEditingController _usernameController = TextEditingController();
  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    bool pending =
        context.watch<AuthBloc>().state is AuthenticatedNoUserPending;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(child: Text('Please finalize registration')),
          const SizedBox(
            height: 16,
          ),
          Form(
            key: _key,
            child: Center(
              child: SizedBox(
                width: 400,
                child: TextFormField(
                  enabled: !pending,
                  controller: _usernameController,
                  decoration: const InputDecoration(labelText: 'Username'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter a username'
                      : null,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          ElevatedButton(
              onPressed: pending
                  ? null
                  : () {
                      if (_key.currentState!.validate()) {
                        context.read<AuthBloc>().add(FinalizeRegistration(
                            email: email,
                            authId: authId,
                            username: _usernameController.text));
                      }
                    },
              child: pending
                  ? const CircularProgressIndicator()
                  : const Text('Finalize Registration'))
        ],
      ),
    );
  }
}

class UnAuthView extends StatelessWidget {
  const UnAuthView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) => current is AuthFail,
      listener: (context, state) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text((state as AuthFail).message)));
      },
      child: DefaultTabController(
          length: 2,
          child: Column(children: [
            Expanded(
              child: TabBarView(children: [LoginView(), RegisterView()]),
            ),
            const TabBar(
              tabs: [
                Tab(text: 'Login'),
                Tab(text: 'Register'),
              ],
            ),
          ])),
    );
  }
}

class LoginView extends StatelessWidget {
  LoginView({
    super.key,
  });

  final _key = GlobalKey<FormState>();

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  save(BuildContext context) {
    if (_key.currentState!.validate()) {
      context.read<AuthBloc>().add(Login(
          email: _emailController.text, password: _passwordController.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    final authStatus = context.watch<AuthBloc>().state;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _emailFocus.requestFocus();
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
              controller: _emailController,
              focusNode: _emailFocus,
              enabled: authStatus is! AuthPending,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (value) => value == null || value.isEmpty
                  ? 'Please enter a username'
                  : null,
              onFieldSubmitted: (_) => _passwordFocus.requestFocus(),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              focusNode: _passwordFocus,
              obscureText: true,
              enabled: authStatus is! AuthPending,
              decoration: const InputDecoration(labelText: 'Password'),
              validator: (value) => value == null || value.isEmpty
                  ? 'Please enter a password'
                  : null,
              onFieldSubmitted: (_) => save(context),
            ),
            const SizedBox(height: 16),
            authStatus is AuthPending
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

class RegisterView extends StatelessWidget {
  RegisterView({
    super.key,
  });

  final _key = GlobalKey<FormState>();

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  save(BuildContext context) {
    if (_key.currentState!.validate()) {
      context.read<AuthBloc>().add(Register(
          email: _emailController.text, password: _passwordController.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    final authStatus = context.watch<AuthBloc>().state;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _emailFocus.requestFocus();
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
              controller: _emailController,
              focusNode: _emailFocus,
              enabled: authStatus is! AuthPending,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (value) => value == null || value.isEmpty
                  ? 'Please enter a username'
                  : null,
              onFieldSubmitted: (_) => _passwordFocus.requestFocus(),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              focusNode: _passwordFocus,
              obscureText: true,
              enabled: authStatus is! AuthPending,
              decoration: const InputDecoration(labelText: 'Password'),
              validator: (value) => value == null || value.isEmpty
                  ? 'Please enter a password'
                  : null,
              onFieldSubmitted: (_) => save(context),
            ),
            const SizedBox(height: 16),
            authStatus is AuthPending
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () => save(context),
                    child: const Text('Register'),
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
            create: (context) => ItemsBloc(repository: ItemRepository())
              ..add(SubscribeToUserItems(
                  userId: (context.read<AuthBloc>().state as Authenticated)
                      .user
                      .id))),
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
                        onPressed: () => context.read<AuthBloc>().add(Logout()),
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
              child: Column(
                children: [
                  Text(
                      "Welcome ${(context.read<AuthBloc>().state as Authenticated).user.username}"),
                  Expanded(
                    child: IndexedStack(
                      key: const GlobalObjectKey("indexedStack"),
                      index: _selectedIndex.value,
                      children: views,
                    ),
                  ),
                ],
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