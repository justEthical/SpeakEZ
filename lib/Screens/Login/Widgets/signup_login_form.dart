import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Controllers/onboarding_controller.dart';

class SignupLoginForm extends StatefulWidget {
  const SignupLoginForm({super.key});

  @override
  State<SignupLoginForm> createState() => _SignupLoginFormState();
}

class _SignupLoginFormState extends State<SignupLoginForm> {
  final c = Get.find<OnboardingController>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: c.loginFormKey,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  c.isloginForm.value = true;
                },
                child: Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),

              InkWell(
                onTap: () {
                  c.isloginForm.value = false;
                },
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 100,
                  height: 2,
                  color:
                      c.isloginForm.value ? Colors.black : Colors.transparent,
                ),
                Container(
                  width: 100,
                  height: 2,
                  color:
                      c.isloginForm.value ? Colors.transparent : Colors.black,
                ),
              ],
            ),
          ),
          Obx(
            () => Column(
              children: [
                SizedBox(height: 20),
                c.isloginForm.value
                    ? SizedBox()
                    : TextFormField(
                      controller: c.nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "Name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                c.isloginForm.value ? SizedBox() : SizedBox(height: 10),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    } else if (c.isValidEmail(value) == false) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                  controller: c.emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: "Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    } else if (c.isValidPassword(value) == false) {
                      return 'Password must be at least 8 characters long, contain at least one uppercase letter, one lowercase letter, one number, and one special character.';
                    }
                    return null;
                  },
                  controller: c.passwordController,
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    hintText: "Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (c.loginFormKey.currentState!.validate()) {
                      if (c.isloginForm.value) {
                        c.emailLogin(
                          c.emailController.text.trim(),
                          c.passwordController.text.trim(),
                        );
                      } else {
                        c.emailSignUp(
                          c.emailController.text.trim(),
                          c.passwordController.text.trim(),
                          c.nameController.text.trim(),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    fixedSize: Size(Get.width - 40, 50),
                  ),
                  child: Obx(
                    () => Text(
                      c.isloginForm.value ? "Login" : "Sign Up",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(child: Divider(thickness: 1)),
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: Colors.black, width: 1.2),
                      ),
                      child: Center(child: Text("Or")),
                    ),
                    Expanded(child: Divider(thickness: 1)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
