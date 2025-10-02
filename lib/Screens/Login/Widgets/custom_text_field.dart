import 'package:speak_ez/Constants/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Controllers/onboarding_controller.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController textCtrl;
  final String hintText;
  final String leadingIcon;
  final String title;
  final bool isPassword;
  final TextInputType? keyBoardType;
  const CustomTextField({
    super.key,
    required this.textCtrl,
    required this.hintText,
    required this.leadingIcon,
    required this.title,
    required this.isPassword,
    this.keyBoardType,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  var isObscure = false;
  final OnboardingController c = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isObscure = widget.isPassword ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          child: Text(
            widget.title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            // color: Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(30),
          ),
          child: TextFormField(
            obscureText: isObscure,
            controller: widget.textCtrl,
            keyboardType: widget.keyBoardType,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            inputFormatters: [
              LengthLimitingTextInputFormatter(
                widget.hintText == "Phone number" ? 10 : 50,
              ),
            ],
            validator: (val) {
              if (val == "") {
                return "This field cannot be empty";
              }
              if (widget.textCtrl == c.emailController) {
                final bool emailValid = RegExp(
                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                ).hasMatch(val!);
                if (!emailValid) {
                  return "Email format is not valid";
                }
              }

              if (widget.textCtrl == c.passwordController) {
                if (val!.length < 8) {
                  return "Password must be of 8 characters";
                }
                if (!val.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                  return "Password must contain a special Character";
                }
                if (!val.contains(RegExp(r'[0-9]'))) {
                  return "Password must contain a number";
                }
              }

              if (widget.textCtrl == c.confirmPasswordController) {
                if (c.passwordController.text !=
                    c.confirmPasswordController.text) {
                  return "Password does not match";
                }
              }
              return null;
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              prefixIcon: Container(
                padding: const EdgeInsets.all(15),
                width: 10,
                height: 10,
                child: SvgPicture.asset(
                  widget.leadingIcon,
                  fit: BoxFit.contain,
                  colorFilter: ColorFilter.mode(
                    (Theme.of(context).textTheme.bodyMedium?.color)!,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              suffixIcon:
                  widget.isPassword
                      ? InkWell(
                        onTap: () {
                          isObscure = !isObscure;
                          setState(() {});
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          width: 10,
                          height: 10,
                          child: SvgPicture.asset(
                            isObscure ? AppAssets.eyeClosed : AppAssets.eyeIcon,
                            fit: BoxFit.contain,
                            colorFilter: ColorFilter.mode(
                              (Theme.of(context).textTheme.bodyMedium?.color)!,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      )
                      : null,
              isDense: true,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(color: Colors.red),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
