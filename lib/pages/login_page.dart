import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../utils/logger.dart';
import 'export_page.dart';
import '../providers/export_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static const routeId = '/login-page';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _emailCtr;
  late final TextEditingController _passwordCtr;
  late final LoginProvider loginProvider;
  late final AuthenticationProvider authenticationProvider;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final FocusNode _emailFocus;
  late final FocusNode _passFocus;
  bool _isAsyncCall = false;

  @override
  void initState() {
    super.initState();
    _emailFocus = FocusNode();
    _passFocus = FocusNode();
    _emailCtr = TextEditingController();
    _passwordCtr = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      loginProvider = context.read<LoginProvider>();
      loginProvider.addListener(_onListenLoginProvider);
      authenticationProvider = context.read<AuthenticationProvider>();
      authenticationProvider.addListener(_onListenAuthenticationProvider);
    });
  }

  @override
  void dispose() {
    _emailCtr.dispose();
    _passwordCtr.dispose();
    loginProvider.removeListener(_onListenLoginProvider);
    authenticationProvider.removeListener(_onListenAuthenticationProvider);
    _emailFocus.dispose();
    _passFocus.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    if (_formKey.currentState!.validate()) {
      await loginProvider.onLogin(
        email: _emailCtr.text,
        password: _passwordCtr.text,
      );
    }
  }

  // on listen login provider
  void _onListenLoginProvider() {
    if (loginProvider.isLoading) {
      setState(() {
        _isAsyncCall = true;
      });
    }

    if (loginProvider.isLoading == false) {
      setState(() {
        _isAsyncCall = false;
      });
    }

    if (loginProvider.errorMsg.isNotEmpty) {
      var errMsg = loginProvider.errorMsg.toLowerCase();
      'errMsg::[$errMsg]'.log();

      String displayErrMsg = errMsg;

      if (errMsg.contains('_message:')) {
        displayErrMsg = errMsg.substring(errMsg.indexOf('_message:') + 9, errMsg.indexOf('}')).trim();
      }

      if (errMsg.contains('invalid credentials') || errMsg.contains('check your credentials')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid email or password. Please check again.'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(displayErrMsg),
          ),
        );
      }
    }

    if (loginProvider.loginResModel != null) {
      authenticationProvider.updateLoginStatus(context, true);
    } else {
      authenticationProvider.updateLoginStatus(context, false);
    }
  }

  void _onListenAuthenticationProvider() {
    if (authenticationProvider.isAuthenticated) {
      Navigator.of(context).pushNamedAndRemoveUntil(MainPage.routeId, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: _isAsyncCall,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    textAlign: TextAlign.center,
                    'Please Sign In',
                    style: TextStyle(
                      fontSize: 26.0,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                  child: TextFormField(
                    focusNode: _emailFocus,
                    onTapOutside: (event) {
                      if (_emailFocus.hasFocus) {
                        _emailFocus.unfocus();
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter your email',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                      ),
                    ),
                    textInputAction: TextInputAction.next,
                    autocorrect: false,
                    autofocus: false,
                    enableSuggestions: false,
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailCtr,
                    onChanged: (value) {},
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      value = value?.trim();
                      if (value == null || value.isEmpty) {
                        return 'Email is required';
                      } else if (value.contains('@') == false) {
                        return 'Invalid email.';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                  child: TextFormField(
                    focusNode: _passFocus,
                    onTapOutside: (event) {
                      if (_passFocus.hasFocus) {
                        _passFocus.unfocus();
                      }
                    },
                    onFieldSubmitted: (event) async {
                      await _onLogin();
                    },
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      hintText: 'Enter your password',
                      prefixIcon: Icon(Icons.lock_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                      ),
                    ),
                    autocorrect: false,
                    autofocus: false,
                    enableSuggestions: false,
                    obscureText: true,
                    controller: _passwordCtr,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: (value) {},
                    validator: (value) {
                      value = value?.trim();
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      } else if (value.length < 3) {
                        return 'Password is too short.';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                    ),
                    onPressed: () async => await _onLogin(),
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
