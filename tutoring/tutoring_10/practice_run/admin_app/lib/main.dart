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
      home: AuthSwitchingView(),
    );
  }
}

class AuthSwitchingView extends StatelessWidget {
  AuthSwitchingView({super.key});

  final ValueNotifier<bool> _isAuthenticated = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
          valueListenable: _isAuthenticated,
          builder: (context, value, child) {
            return AnimatedSwitcher(
                transitionBuilder: (child, animation) => SlideTransition(
                    position: Tween<Offset>(
                            begin: const Offset(1, 0), end: Offset.zero)
                        .animate(animation),
                    child: child),
                switchInCurve: Curves.easeOutSine,
                switchOutCurve: Curves.easeOutSine,
                duration: const Duration(milliseconds: 500),
                child: value
                    ? NavRailView(
                        onSignOut: () => _isAuthenticated.value = false,
                      )
                    : LoginView(
                        onSignIn: () => _isAuthenticated.value = true,
                      ));
          }),
    );
  }
}

class LoginView extends StatelessWidget {
  LoginView({super.key, required this.onSignIn});

  final Function() onSignIn;

  final ValueNotifier<Future> _signIn = ValueNotifier<Future>(Future.value());

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ValueListenableBuilder(
          valueListenable: _signIn,
          builder: (context, value, snapshot) {
            return FutureBuilder(
                future: value,
                builder: (context, snapshot) {
                  return Form(
                      key: _formKey,
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 400),
                        child: Wrap(
                          runSpacing: 20,
                          alignment: WrapAlignment.center,
                          children: <Widget>[
                            TextFormField(
                              enabled: snapshot.connectionState !=
                                  ConnectionState.waiting,
                              controller: emailController,
                              decoration:
                                  const InputDecoration(labelText: 'Email'),
                              validator: (value) =>
                                  value!.isEmpty ? 'Please enter email' : null,
                            ),
                            TextFormField(
                              enabled: snapshot.connectionState !=
                                  ConnectionState.waiting,
                              controller: passwordController,
                              decoration:
                                  const InputDecoration(labelText: 'Password'),
                              validator: (value) => value!.isEmpty
                                  ? 'Please enter password'
                                  : null,
                            ),
                            snapshot.connectionState != ConnectionState.waiting
                                ? ElevatedButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        _signIn.value = Future.delayed(
                                            const Duration(seconds: 2),
                                            () => onSignIn());
                                      }
                                    },
                                    child: const Text('Sign in'),
                                  )
                                : const CircularProgressIndicator(),
                          ],
                        ),
                      ));
                });
          }),
    );
  }
}

class NavRailView extends StatefulWidget {
  const NavRailView({super.key, required this.onSignOut});

  final Function() onSignOut;

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
            extended: false,
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
                  child: TextButton.icon(
                      icon: const Icon(Icons.logout),
                      label: const Text('Sign out'),
                      onPressed: widget.onSignOut),
                ),
              ),
            ),
            labelType: labelType,
            destinations: destinations),

        const VerticalDivider(thickness: 1, width: 1),
        // This is the main content.
        Expanded(child: views[_selectedIndex])
      ],
    );
  }
}
