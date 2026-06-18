import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tambur_create/core/extensions/widget_extensions.dart';
import 'package:tambur_create/features/common_widgets/text_field_widget.dart';
import 'package:tambur_create/features/common_widgets/w_button.dart';
import 'package:tambur_create/features/login/presentation/manager/login_bloc.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          context.goNamed("home");
        } else if (state is LoginFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login failed: ${state.error}')),
          );
        }
      },
      builder: (BuildContext context, LoginState state) {
        if (state is LoginInitial) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Войдите в приложение",
                  style: TextStyle(fontSize: 24, fontFamily: "Sans"),
                ),
                const SizedBox(height: 28),
                const Text(
                  "Логин",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    fontFamily: "Sans",
                  ),
                ),
                const SizedBox(height: 4),
                TextFieldWidget(
                  controller: phoneController,
                  hintText: 'Введите логин',
                ),
                const SizedBox(height: 12),
                const Text(
                  "Пароль",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    fontFamily: "Sans",
                  ),
                ),
                const SizedBox(height: 4),
                TextFieldWidget(
                  controller: passwordController,
                  hintText: 'Введите пароль',
                ),
                const SizedBox(height: 30),
                const Spacer(),
                AnimationButtonEffect(
                  onTap: () {
                    context.read<LoginBloc>().add(
                      LoginButtonPressed(
                        phoneNumber: phoneController.text,
                        password: passwordController.text,
                      ),
                    );
                    phoneController.clear();
                    passwordController.clear();
                  },
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xffff821a), Color(0xffff3300)],
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        "Войти",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          fontFamily: "Sans",
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ).withPadding(const EdgeInsets.only(bottom: 16)),
              ],
            ),
          );
        } else if (state is LoginLoading || state is LoginSuccess) {
          return const SizedBox(
            height: 500,
            child: Center(child: CircularProgressIndicator()),
          );
        } else {
          return const Center(child: Text("State not found"));
        }
      },
    );
  }
}
