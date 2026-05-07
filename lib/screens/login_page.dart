import 'package:flutter/material.dart';

class Credentials {
  Credentials(this.username, this.password);
  final String username;
  final String password;
}

class LoginPage extends StatelessWidget {
  const LoginPage({
    required this.onLogIn,
    required this.onSignUp,
    super.key,
  });

  final ValueChanged<Credentials> onLogIn;
  final ValueChanged<Credentials> onSignUp;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8E9), // Светло-зеленый фон (Material Green 50)
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: LoginForm(
            onLogIn: onLogIn,
            onSignUp: onSignUp,
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({
    required this.onLogIn,
    required this.onSignUp,
    super.key,
  });

  final ValueChanged<Credentials> onLogIn;
  final ValueChanged<Credentials> onSignUp;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _handleLogin() {
    widget.onLogIn(
      Credentials(_emailController.text, _passwordController.text),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/yummy_logo.png',
          height: 200,
          width: 200,
        ),
        const SizedBox(height: 30),
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next, // Переход к следующему полю
          decoration: InputDecoration(
            hintText: 'Email',
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide(color: Colors.green.shade100),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide(color: Colors.green.shade100),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide(color: Colors.green.shade300, width: 2),
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _passwordController,
          obscureText: true,
          textInputAction: TextInputAction.done, // Завершение ввода
          onSubmitted: (_) => _handleLogin(), // Вход по Enter
          decoration: InputDecoration(
            hintText: 'Password',
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide(color: Colors.green.shade100),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide(color: Colors.green.shade100),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide(color: Colors.green.shade300, width: 2),
            ),
          ),
        ),
        const SizedBox(height: 30),
        _buildCompactButton(
          text: 'Login',
          onPressed: _handleLogin,
        ),
        const SizedBox(height: 12),
        _buildCompactButton(
          text: 'Sign Up',
          onPressed: () => widget.onSignUp(
            Credentials(_emailController.text, _passwordController.text),
          ),
        ),
      ],
    );
  }

  Widget _buildCompactButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 180,
      height: 45,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFC8E6C9),
          foregroundColor: const Color(0xFF1B5E20),
          elevation: 0,
          shape: const StadiumBorder(),
          side: BorderSide(color: Colors.green.shade200),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
