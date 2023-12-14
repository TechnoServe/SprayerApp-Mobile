// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:sprayer_app/entities/profile.dart';
import 'package:sprayer_app/helpers/utils.dart';
import 'package:sprayer_app/models/location_model.dart';
import 'package:sprayer_app/models/user_model.dart';
import 'package:sprayer_app/views/signin_page.dart';
import 'package:sprayer_app/views/widgets/button_widget.dart';
import 'package:sprayer_app/views/widgets/dropdown_widget.dart';
import 'package:sprayer_app/views/widgets/text_form_field_widget.dart';
import 'package:sprayer_app/views/widgets/top_elippsed_effect_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RecoverPasswordPage extends StatefulWidget {
  const RecoverPasswordPage({Key? key}) : super(key: key);

  @override
  State<RecoverPasswordPage> createState() => _RecoverPasswordPageState();
}

class _RecoverPasswordPageState extends State<RecoverPasswordPage> {
  bool isObscureText = true;
  bool isObscureText2 = true;

  TextEditingController password = TextEditingController();
  TextEditingController repeatPassword = TextEditingController();
  TextEditingController securityAnswer = TextEditingController();

  final _formKey = GlobalKey<FormBuilderState>();

  String province = "";
  String district = "";
  String administrativePost = "";
  String profile = "";
  List<String> provinces = [], districts = [], administrativePosts = [];
  List<Profile> profiles = [];
  String securityQuestion = "";
  List<String> securityQuestions = [
    "Como se chama sua aldeia?",
    "Qual e sua cor favorita?",
    "Qual e seu sobrenome?"
  ];

  @override
  void initState() {
    provinces = LocationModel.getProvinces();
    super.initState();
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
                const TopElippsedEffect(),
                Container(
                  padding: const EdgeInsets.only(
                    left: 15.0,
                    right: 15.0,
                    bottom: 15.0,
                  ),
                  child: Column(
                    children: [
                      Text(
                        language.recover_password_title,
                        style: const TextStyle(
                          fontSize: 22.0,
                          color: Color(0xff00C013),
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Utils.mHeight,
                      TextFormFieldWidget(
                        name: "mobileNumber",
                        hintText: language.form_field_mobile_number_placeholder,
                      ),
                      Utils.mHeight,
                      DropdownWidget(
                        initialValue: securityQuestion,
                        validator: (value) => (value == null)
                            ? language.form_field_mandatory_validation_message
                            : null,
                        name: "securityQuestion",
                        items: securityQuestions,
                        hintText: language.recover_safety_question_placeholder,
                      ),
                      Utils.mHeight,
                      TextFormFieldWidget(
                        controller: securityAnswer,
                        validator: (value) => (value == null || value.isEmpty)
                            ? language.form_field_mandatory_validation_message
                            : null,
                        name: "securityAnswer",
                        hintText: language.recover_safety_answer_placeholder,
                      ),
                      Utils.mHeight,
                      TextFormFieldWidget(
                        controller: password,
                        suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              isObscureText = !isObscureText;
                            });
                          },
                          child: Icon(
                            isObscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                        obscureText: isObscureText,
                        name: "password",
                        validator: (value) => (value == null || value.isEmpty)
                            ? language.form_field_mandatory_validation_message
                            : null,
                        hintText: language.recover_new_password_placeholder,
                      ),
                      Utils.mHeight,
                      TextFormFieldWidget(
                        controller: repeatPassword,
                        suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              isObscureText2 = !isObscureText2;
                            });
                          },
                          child: Icon(
                            isObscureText2
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                        obscureText: isObscureText2,
                        name: "repeat_password",
                        validator: (value) => (value == null || value.isEmpty)
                            ? language.form_field_mandatory_validation_message
                            : (password.text != repeatPassword.text) ? language.recover_dont_match_password_placeholder : null,
                        hintText: language.recover_repeat_new_password_placeholder,
                      ),
                      Utils.mHeight,
                      ButtonWidget(
                        title: language.recover_password_title,
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            Utils.modalProgress(context);

                            Map<dynamic, dynamic> data =
                                _formKey.currentState!.value;

                            UserModel()
                                .recoverUserWithSecurityQuestion(
                              mobileNumber: data["mobileNumber"],
                              securityQuestion: data["securityQuestion"],
                              securityAnswer: data["securityAnswer"]
                                  .toString()
                                  .toLowerCase(),
                              password: data["password"],
                            )
                                .then((value) {
                              if (value > 0) {
                                Navigator.pop(context);
                                Utils.snackbar(
                                  context,
                                  "Senha recuperada e redifinida com sucesso",
                                );

                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Signin(),
                                  ),
                                  (route) => false,
                                );
                              } else {
                                Navigator.pop(context);
                                Utils.snackbar(
                                  context,
                                  "Resposta de segurança errada.",
                                );
                              }
                            });
                          }
                        },
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
