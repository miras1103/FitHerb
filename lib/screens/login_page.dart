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
      backgroundColor: const Color(0xFFF1F8E9), // Светло-зеленый фон
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 350),
            child: LoginForm(
              onLogIn: onLogIn,
              onSignUp: onSignUp,
            ),
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

class _LoginFormState extends State<LoginForm> with TickerProviderStateMixin {
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
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Image.asset(
          'assets/yummy_logo.png',
          height: 180,
          width: 180,
        ),
        const SizedBox(height: 40),
        _buildTextField(
          controller: _emailController,
          hint: 'Email',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _passwordController,
          hint: 'Password',
          icon: Icons.lock_outline,
          obscureText: true,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _handleLogin(),
        ),
        const SizedBox(height: 32),
        // Использование анимированной кнопки
        ScaleAnimatedButton(
          text: 'Login',
          onPressed: _handleLogin,
          isPrimary: true,
        ),
        const SizedBox(height: 12),
        ScaleAnimatedButton(
          text: 'Sign Up',
          onPressed: () => widget.onSignUp(
            Credentials(_emailController.text, _passwordController.text),
          ),
          isPrimary: false,
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    Function(String)? onSubmitted,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.green.shade400, size: 22),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(color: Colors.green.shade50),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(color: Colors.green.shade300, width: 1.5),
        ),
        hintStyle: TextStyle(color: Colors.grey.shade400),
      ),
    );
  }
}

// Новый виджет для анимации масштабирования при нажатии
class ScaleAnimatedButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;

  const ScaleAnimatedButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.isPrimary,
  });

  @override
  State<ScaleAnimatedButton> createState() => _ScaleAnimatedButtonState();
}

class _ScaleAnimatedButtonState extends State<ScaleAnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onPressed();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: ElevatedButton(
          onPressed: null, // Отключаем стандартный обработчик, так как используем GestureDetector
          style: ElevatedButton.styleFrom(
            disabledBackgroundColor: widget.isPrimary ? Colors.green.shade600 : Colors.white,
            disabledForegroundColor: widget.isPrimary ? Colors.white : Colors.green.shade700,
            padding: const EdgeInsets.symmetric(vertical: 16),
            elevation: widget.isPrimary ? 2 : 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
              side: widget.isPrimary ? BorderSide.none : BorderSide(color: Colors.green.shade100),
            ),
          ),
          child: Text(
            widget.text,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
