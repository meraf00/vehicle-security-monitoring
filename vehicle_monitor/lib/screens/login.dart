import 'package:flutter/material.dart';
import 'package:vehicle_monitor/theme/app_colors.dart';
import 'package:vehicle_monitor/widgets/custom_textfield.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.blue,
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  AppColors.blue,
                  AppColors.blue100,
                ],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(0.0, 1.0),
                stops: [0.0, 1],
                tileMode: TileMode.clamp),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Login',
                  style: Theme.of(context)
                      .textTheme
                      .displayLarge
                      ?.copyWith(color: AppColors.white),
                ),

                //
                const SizedBox(height: 30),

                //
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      //
                      // Email
                      CustomTextField(
                        controller: emailController,
                        hintText: 'Email',
                        prefixIcon: Icons.email_outlined,
                      ),

                      const SizedBox(height: 10),

                      //
                      // Password
                      CustomTextField(
                        controller: passwordController,
                        hintText: 'Password',
                        prefixIcon: Icons.lock_outline,
                        obscureText: true,
                      ),
                    ],
                  ),
                ),

                //
                // Login Button

                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 50,
                        ),
                      ),
                      child: const Text('Login'),
                    ),
                  ),
                ),

                // Register
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Don\'t have an account?'),
                    const SizedBox(width: 5),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/register');
                      },
                      child: const Text('Register'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
