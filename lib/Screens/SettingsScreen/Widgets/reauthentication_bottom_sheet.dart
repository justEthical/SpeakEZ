import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Constants/app_assets.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:speak_ez/Services/auth_service.dart';
import 'package:speak_ez/Utils/custom_dialogs.dart';
import 'package:speak_ez/Utils/custom_loader.dart';

class ReauthenticationBottomSheet extends StatefulWidget {
  const ReauthenticationBottomSheet({super.key});

  @override
  State<ReauthenticationBottomSheet> createState() =>
      _ReauthenticationBottomSheetState();
}

class _ReauthenticationBottomSheetState
    extends State<ReauthenticationBottomSheet> {
  var isObscure = true;
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final providerID = user!.providerData[0].providerId;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Spacer(),
            InkWell(
              onTap: () async {
                Get.back();
              },
              child: Container(
                margin: EdgeInsets.all(15),
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.grey.shade300,
                ),
                child: Icon(Icons.close, color: Theme.of(context).textTheme.bodyMedium?.color, size: 18),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Text(
            "Please reauthentication to proceed further.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontFamily: AppStrings.poppinsFont,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 20, width: Get.width),
        providerID == 'google.com'
            ? ElevatedButton(
              onPressed: () async {
                CustomLoader.showLoader();
                final result = await AuthService.reAuthenticateGoogleLogin();
                CustomLoader.hideLoader();
                if (result) {
                  Get.back();
                  Get.dialog(CustomDialogs.deleteConfirmationDialog(Get.context!));
                }
              },
              style: ElevatedButton.styleFrom(
                fixedSize: Size(Get.width - 40, 50),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(width: 0.56, color: Colors.black),
                ),
                backgroundColor: Colors.black,
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SvgPicture.asset(AppAssets.google),
                    ),
                   Text(
                      "Login with Google",
                      style: TextStyle(
                        fontSize: 16,
                        // fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            )
            : Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextField(
                      controller: passwordController,
                      obscureText: isObscure,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        prefixIcon: Container(
                          padding: const EdgeInsets.all(15),
                          width: 10,
                          height: 10,
                          child: SvgPicture.asset(
                            AppAssets.lockIcon,
                            fit: BoxFit.contain,
                          ),
                        ),
                        suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              isObscure = !isObscure;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            width: 10,
                            height: 10,
                            child: SvgPicture.asset(
                              isObscure
                                  ? AppAssets.eyeClosed
                                  : AppAssets.eyeIcon,
                              fit: BoxFit.contain,
                              color: Theme.of(context).textTheme.bodyMedium?.color,
                            ),
                          ),
                        ),
                        isDense: true,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (passwordController.text.isNotEmpty) {
                        FocusScope.of(context).unfocus();
                        CustomLoader.showLoader();
                        final result =
                            await AuthService.reAuthenticateWithEmail(
                              email: globalController.userProfile.value.email,
                              password: passwordController.text,
                            );
                        CustomLoader.hideLoader();
                        if (result) {
                          Get.back();
                          Get.dialog(CustomDialogs.deleteConfirmationDialog(Get.context!));
                        }
                      } else {
                        globalController.showSnackbarWithGetX(
                          "Error",
                          "Please enter password.",
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(Get.width - 40, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side:  BorderSide(
                          width: 0.56,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      backgroundColor: Colors.white,
                    ),
                    child: Center(
                      child: Text(
                        "Reauthenticate",
                        style:  TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        SizedBox(height: 20),
      ],
    );
  }
}
