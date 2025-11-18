import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tambur_create/core/di/setup_locator.dart';
import 'package:tambur_create/core/ui/dialog_utils.dart';
import 'package:tambur_create/features/login/domain/use_cases/login_user_use_case.dart';
import 'package:tambur_create/features/login/presentation/manager/login_bloc.dart';

// Custom phone number formatter
class _PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // If the new value is empty, return +998
    if (newValue.text.isEmpty) {
      return const TextEditingValue(
        text: '+998',
        selection: TextSelection.collapsed(offset: 4),
      );
    }

    // If the new value is shorter than the old value, it means deletion
    if (newValue.text.length < oldValue.text.length) {
      // If user is trying to delete the prefix, prevent it
      if (newValue.text.length < 4) {
        return const TextEditingValue(
          text: '+998',
          selection: TextSelection.collapsed(offset: 4),
        );
      }

      // If user is deleting digits after the prefix, allow it
      if (newValue.text.startsWith('+998')) {
        return newValue;
      }
    }

    // If the new value doesn't start with +998, ensure it does
    if (!newValue.text.startsWith('+998')) {
      // Extract only digits
      final digits = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
      final formattedText = '+998$digits';

      return TextEditingValue(
        text: formattedText,
        selection: TextSelection.collapsed(offset: formattedText.length),
      );
    }

    // If it already starts with +998, just filter out non-digits after the prefix
    const prefix = '+998';
    final afterPrefix = newValue.text
        .substring(4)
        .replaceAll(RegExp(r'[^\d]'), '');
    final formattedText = '$prefix$afterPrefix';

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late final LoginBloc _loginBloc;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _loginBloc = LoginBloc(loginUserUseCase: locator<LoginUserUseCase>());
    usernameController.text = "+998";
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    _loginBloc.close();
    super.dispose();
  }

  // Helper method to build section headers like in OtkFormPage
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: CupertinoColors.systemGrey,
        ),
      ),
    );
  }

  // Helper method to build text fields like in OtkFormPage
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
    String? Function(String?)? validator,
    Widget? prefixIcon,
    bool isPhoneNumber = false,
  }) {
    final bool isPassword = obscureText;
    return Container(
      height: 45.h,
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      alignment: Alignment.center,
      child: TextFormField(
        controller: controller,
        obscureText: isPassword ? _obscurePassword : false,
        textAlign: TextAlign.start,
        style: TextStyle(fontSize: 14.sp),
        keyboardType: isPhoneNumber ? TextInputType.phone : TextInputType.text,
        inputFormatters: isPhoneNumber
            ? [_PhoneNumberFormatter(), LengthLimitingTextInputFormatter(13)]
            : null,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          prefixIcon: prefixIcon,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 12.w,
            vertical: 12.h,
          ),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? CupertinoIcons.eye_slash_fill
                        : CupertinoIcons.eye_fill,
                    color: CupertinoColors.systemGrey,
                    size: 20.r,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                )
              : null,
          hintStyle: TextStyle(
            fontSize: 14.sp,
            color: CupertinoColors.systemGrey,
          ),
        ),
        validator:
            validator ??
            (value) {
              if (isPhoneNumber) {
                if (value == null || value.isEmpty) {
                  return 'Telefon raqami bo\'sh bo\'lmasligi kerak';
                }
                if (value.length < 13) {
                  return 'Telefon raqami to\'liq emas (+998XXXXXXXXX)';
                }
                if (!value.startsWith('+998')) {
                  return 'Telefon raqami +998 bilan boshlanishi kerak';
                }
              } else {
                // Password field is optional, so no validation needed
                return null;
              }
              return null;
            },
      ),
    );
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      DialogUtils.showLoading(message: 'Kirish amalga oshirilmoqda...');

      _loginBloc.add(
        LoginButtonPressed(
          phoneNumber: usernameController.text,
          password: passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: CupertinoColors.systemGroupedBackground,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: CupertinoColors.systemGroupedBackground,
          title: Image(
            image: const AssetImage("assets/image/profpack_logo.png"),
            width: 130.w,
          ),
        ),
        body: SafeArea(
          child: BlocProvider(
            create: (context) => _loginBloc,
            child: Column(
              children: [
                // Login Form
                Expanded(
                  child: BlocConsumer<LoginBloc, LoginState>(
                    listener: (context, state) {
                      if (state is LoginSuccess) {
                        DialogUtils.dismissLoading();
                        DialogUtils.showSuccessToast('Muvaffaqiyatli kirildi');
                        context.goNamed("home");
                      } else if (state is LoginFailure) {
                        DialogUtils.dismissLoading();
                        DialogUtils.showErrorToast('Xatolik: ${state.error}');
                      }
                    },
                    builder: (context, state) {
                      if (state is LoginLoading) {
                        return const Center(
                          child: CupertinoActivityIndicator(),
                        );
                      }

                      return Form(
                        key: _formKey,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 30.h),
                              // Welcome section with icon
                              const Spacer(flex: 2),

                              SizedBox(height: 40.h),

                              // Login field
                              _buildSectionHeader('Telefon raqami'),
                              _buildTextField(
                                controller: usernameController,
                                hintText: 'Telefon raqamini kiriting',
                                prefixIcon: Icon(
                                  CupertinoIcons.phone,
                                  color: CupertinoColors.systemGrey,
                                  size: 20.r,
                                ),
                                isPhoneNumber: true,
                              ),
                              SizedBox(height: 16.h),

                              // Password field
                              _buildSectionHeader('Parol'),
                              _buildTextField(
                                controller: passwordController,
                                hintText: 'Parolni kiriting',
                                obscureText: true,
                                prefixIcon: Icon(
                                  CupertinoIcons.lock,
                                  color: CupertinoColors.systemGrey,
                                  size: 20.r,
                                ),
                              ),
                              const Spacer(flex: 3),

                              // Login button
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: CupertinoColors.activeBlue
                                          .withOpacity(0.3),
                                      offset: const Offset(0, 4),
                                      blurRadius: 12,
                                    ),
                                  ],
                                ),
                                child: CupertinoButton(
                                  padding: EdgeInsets.symmetric(vertical: 14.h),
                                  color: const Color(0xff12237f),
                                  borderRadius: BorderRadius.circular(8.r),
                                  onPressed: _login,
                                  child: Text(
                                    'Kirish',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).padding.bottom + 5.h,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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
