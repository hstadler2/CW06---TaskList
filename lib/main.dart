import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'auth_service.dart';
import 'task_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase with your configuration
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager App',
      // AuthWrapper shows either the login/registration screen or the TaskListScreen
      home: const AuthWrapper(),
    );
  }
}

// Listens to auth state changes.
// If a user is logged in, we show the TaskListScreen; otherwise, we show the AuthenticationScreen.
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const TaskListScreen();
        } else {
          return const AuthenticationScreen();
        }
      },
    );
  }
}

// This screen shows the registration and sign‑in forms.
class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login / Register'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: const [
            RegisterEmailSection(),
            SizedBox(height: 20),
            EmailPasswordForm(),
          ],
        ),
      ),
    );
  }
}

// Registration form widget.
class RegisterEmailSection extends StatefulWidget {
  const RegisterEmailSection({Key? key}) : super(key: key);
  @override
  _RegisterEmailSectionState createState() => _RegisterEmailSectionState();
}

class _RegisterEmailSectionState extends State<RegisterEmailSection> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // Controllers for email and password fields.
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _success = false;
  bool _initialState = true;
  String? _userEmail;

  // Registers a new user using AuthService.
  void _register() async {
    if (_formKey.currentState!.validate()) {
      bool result = await AuthService.registerWithEmail(
          _emailController.text, _passwordController.text);
      setState(() {
        _success = result;
        _userEmail = _emailController.text;
        _initialState = false;
      });
      if (!_success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration failed')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Register', style: TextStyle(fontSize: 20)),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!value.contains('@')) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          Center(
            child: ElevatedButton(
              onPressed: _register,
              child: const Text('Register'),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(
              _initialState
                  ? 'Please Register'
                  : _success
                      ? 'Successfully registered $_userEmail'
                      : 'Registration failed',
              style: TextStyle(color: _success ? Colors.green : Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

// Sign‑in form widget.
class EmailPasswordForm extends StatefulWidget {
  const EmailPasswordForm({Key? key}) : super(key: key);
  @override
  _EmailPasswordFormState createState() => _EmailPasswordFormState();
}

class _EmailPasswordFormState extends State<EmailPasswordForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // Controllers for email and password fields.
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _success = false;
  bool _initialState = true;
  String _userEmail = '';

  // Signs in using AuthService.
  void _signIn() async {
    if (_formKey.currentState!.validate()) {
      bool result = await AuthService.signInWithEmail(
          _emailController.text, _passwordController.text);
      setState(() {
        _success = result;
        _userEmail = _emailController.text;
        _initialState = false;
      });
      if (!_success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sign in failed')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Sign In', style: TextStyle(fontSize: 20)),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!value.contains('@')) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          Center(
            child: ElevatedButton(
              onPressed: _signIn,
              child: const Text('Sign In'),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(
              _initialState
                  ? 'Please sign in'
                  : _success
                      ? 'Successfully signed in $_userEmail'
                      : 'Sign in failed',
              style: TextStyle(color: _success ? Colors.green : Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
