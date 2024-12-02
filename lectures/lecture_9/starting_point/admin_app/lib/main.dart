import 'package:admin_app/views/example_view.dart';
import 'package:admin_app/views/items_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Items Managing App',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 122, 197, 125)),
        useMaterial3: true,
      ),
      home: AuthViewSwitcher(),
    );
  }
}

class AuthViewSwitcher extends StatelessWidget {
  AuthViewSwitcher({super.key});

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
        const VerticalDivider(thickness: 1, width: 1),
        // This is the main content.
        Expanded(child: views[_selectedIndex])
      ],
    );
  }
}
