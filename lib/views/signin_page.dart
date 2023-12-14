// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:sprayer_app/entities/user.dart';
import 'package:sprayer_app/helpers/utils.dart';
import 'package:sprayer_app/models/user_model.dart';
import 'package:sprayer_app/views/recover_password_page.dart';
import 'package:sprayer_app/views/signup_page.dart';
import 'package:sprayer_app/views/widgets/action_call_link.dart';
import 'package:sprayer_app/views/widgets/button_widget.dart';
import 'package:sprayer_app/views/widgets/language_picker_widget.dart';
import 'package:sprayer_app/views/widgets/text_form_field_widget.dart';
import 'package:sprayer_app/views/widgets/top_elippsed_effect_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Signin extends StatefulWidget {
  const Signin({Key? key}) : super(key: key);

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool isObscureText = true;

  @override
  void initState() {
    super.initState();
  }

  loginLocally({
    required BuildContext context,
    required String username,
    required String password,
    required String successMessage,
    required String errorMessage,
  }) {
    UserModel()
        .authanticateLocally(
      username: username,
      password: password,
    )
        .then(
      (value) {
        if (value.isNotEmpty) {
          Utils.navigateToHomePageAfterSigninAndSignup(
            context: context,
            user: value.first,
            notification: successMessage,
          );
        } else {
          Navigator.pop(context);
          Utils.snackbar(
            context,
            errorMessage,
          );
        }
      },
    ).catchError(
      (e) {
        Navigator.pop(context);
        Utils.snackbar(context, e.toString());

        print(e.toString());
      },
    ).whenComplete(
      () => null,
    );
  }

  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Center(
          child: FormBuilder(
            key: _formKey,
            child: Column(
              children: [
                Stack(
                  children: [
                    const TopElippsedEffect(),
                    Positioned(
                      top: 50.0,
                      right: 20.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            language.choose_your_language,
                            style: const TextStyle(
                              fontSize: 15.0,
                              color: Color(0xff00C013),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const LanguagePickerWidget(),
                        ],
                      ),
                    )
                  ],
                ),
                Container(
                  padding: const EdgeInsets.only(
                    left: 15.0,
                    right: 15.0,
                    bottom: 15.0,
                  ),
                  child: Column(
                    children: [
                      Utils.svgHeader("undraw_authentication_re_svpt.svg"),
                      Text(
                        language.login_title,
                        style: const TextStyle(
                          fontSize: 22.0,
                          color: Color(0xff00C013),
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Utils.mHeight,
                      TextFormFieldWidget(
                        validator: (value) => (value == null || value.isEmpty)
                            ? language.form_field_mandatory_validation_message
                            : null,
                        name: "username",
                        hintText: language.login_username_placeholder,
                      ),
                      Utils.mHeight,
                      TextFormFieldWidget(
                        suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              isObscureText = !isObscureText;
                            });
                          },
                          child: Icon(isObscureText
                              ? Icons.visibility_off
                              : Icons.visibility),
                        ),
                        obscureText: isObscureText,
                        validator: (value) => (value == null || value.isEmpty)
                            ? language.form_field_mandatory_validation_message
                            : null,
                        name: "password",
                        hintText: language.login_password_placeholder,
                      ),
                      Utils.mHeight,
                      ButtonWidget(
                        title: language.login_button,
                        onPressed: () async {
                          _formKey.currentState!.save();
                          if (_formKey.currentState!.validate()) {
                            Utils.modalProgress(context);

                            var data = _formKey.currentState!.value;

                            Future<List<User>> loggedUser =
                                UserModel().authanticateOnServer(
                              username: data["username"],
                              password: data["password"],
                            );

                            loggedUser
                                .onError((error, stackTrace) => loginLocally(
                                      context: context,
                                      username: data["username"],
                                      password: data["password"],
                                      successMessage: language.login_successful,
                                      errorMessage:
                                          language.login_unsuccessful_error,
                                    ));

                            loggedUser.then((value) {
                              if (value.isNotEmpty) {
                                int hasMobileAccess = int.tryParse(
                                        value.first.mobileAccess.toString()) ??
                                    0;

                                if (hasMobileAccess == 0) {
                                  Navigator.pop(context);

                                  Utils.snackbar(
                                    context,
                                    language.access_denied_validation_message,
                                  );
                                } else {
                                  Utils.navigateToHomePageAfterSigninAndSignup(
                                    context: context,
                                    user: value.first,
                                    notification:
                                        language.login_successful,
                                  );
                                }
                              } else {
                                loginLocally(
                                  context: context,
                                  username: data["username"],
                                  password: data["password"],
                                  successMessage: language.login_successful,
                                  errorMessage:
                                      language.login_unsuccessful_error,
                                );
                              }
                            });
                          } else {
                            Utils.snackbar(
                              context,
                              language
                                  .form_field_check_all_mandatory_fields_validation_message,
                            );
                          }
                        },
                      ),
                      ActionCallLink(
                        stack: true,
                        actionText: language
                            .signin_recover_password_call_to_action_text,
                        callText: language.signin_recover_password_text,
                        pageRoute: const RecoverPasswordPage(),
                      ),
                      ActionCallLink(
                        actionText: language.signup_call_to_action,
                        callText: language.signup_button_text,
                        pageRoute: const Signup(),
                      ),
                    ],
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
