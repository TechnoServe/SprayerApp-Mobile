// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:sprayer_app/entities/profile.dart';
import 'package:sprayer_app/entities/user.dart';
import 'package:sprayer_app/helpers/utils.dart';
import 'package:sprayer_app/models/location_model.dart';
import 'package:sprayer_app/models/profile_model.dart';
import 'package:sprayer_app/models/user_model.dart';
import 'package:sprayer_app/views/signin_page.dart';
import 'package:sprayer_app/views/widgets/action_call_link.dart';
import 'package:sprayer_app/views/widgets/button_widget.dart';
import 'package:sprayer_app/views/widgets/dropdown_widget.dart';
import 'package:sprayer_app/views/widgets/text_form_field_widget.dart';
import 'package:sprayer_app/views/widgets/top_elippsed_effect_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool isObscureText = true;

  TextEditingController password = TextEditingController();
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
                        language.signup_title,
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
                        name: "firstName",
                        hintText: language.form_field_firstname_placeholder,
                      ),
                      Utils.mHeight,
                      TextFormFieldWidget(
                        name: "lastName",
                        hintText: language.form_field_lastname_placeholder,
                      ),
                      Utils.mHeight,
                      TextFormFieldWidget(
                        keyBoard: TextInputType.phone,
                        validator: (value) => (value == null || value.isEmpty)
                            ? language.form_field_mandatory_validation_message
                            : null,
                        name: "mobileNumber",
                        hintText: language.form_field_mobile_number_placeholder,
                      ),
                      Utils.mHeight,
                      TextFormFieldWidget(
                        name: "email",
                        hintText: language.form_field_email_placeholder,
                      ),
                      Utils.mHeight,
                      DropdownWidget(
                        name: "province",
                        initialValue: province,
                        validator: (value) => (value == null || value == "")
                            ? language.form_field_mandatory_validation_message
                            : null,
                        items: provinces,
                        hintText: language.form_field_province_placeholder,
                        onChange: (value) {
                          setState(() {
                            districts.clear();
                            province = value.toString();
                            districts = LocationModel.getDistricts(province);
                          });
                        },
                      ),
                      Utils.mHeight,
                      DropdownWidget(
                        initialValue: district,
                        name: "district",
                        validator: (value) => (value == null || value == "")
                            ? language.form_field_mandatory_validation_message
                            : null,
                        items: districts,
                        hintText: language.form_field_district_placeholder,
                        onChange: (value) {
                          setState(() {
                            district = value.toString();
                            administrativePosts =
                                LocationModel.getAdministrativePosts(
                                    province, value.toString());
                          });
                        },
                      ),
                      Utils.mHeight,
                      DropdownWidget(
                        initialValue: administrativePost,
                        name: "administrativePost",
                        validator: (value) => (value == null || value == "")
                            ? language.form_field_mandatory_validation_message
                            : null,
                        items: administrativePosts,
                        hintText:
                            language.form_field_administrativepost_placeholder,
                        onChange: (value) {
                          setState(() {
                            administrativePost = value.toString();
                          });
                        },
                      ),
                      Utils.mHeight,
                      FutureBuilder<List<Profile>>(
                          future: ProfileModel().profiles(),
                          initialData: const [],
                          builder: (context, snapshot) {
                            profiles = snapshot.data ?? [];

                            return DropdownWidget(
                              initialValue: profile,
                              validator: (value) {
                                return (value == null || value == "")
                                    ? language
                                        .form_field_mandatory_validation_message
                                    : null;
                              },
                              name: "profile",
                              items: profiles.map((e) => e.name).toList(),
                              hintText: "Perfis",
                              onChange: (value) {
                                setState(() {
                                  profile = value.toString();
                                });
                              },
                            );
                          }),
                      Utils.mHeight,
                      TextFormFieldWidget(
                        controller: password,
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
                        name: "password",
                        validator: (value) => (value == null || value.isEmpty)
                            ? language.form_field_mandatory_validation_message
                            : null /*(!Utils.validatePassword(value)
                                ? "Please provide at least 8 characters, with one \ncapital letter and one number"
                                : )*/
                        ,
                        hintText: language.form_field_password_placeholder,
                      ),
                      Utils.mHeight,
                      DropdownWidget(
                        initialValue: securityQuestion,
                        validator: (value) => (value == null)
                            ? language.form_field_mandatory_validation_message
                            : null,
                        name: "securityQuestion",
                        items: securityQuestions,
                        hintText: "Pergunta de seguranca",
                        onChange: (value) {
                          setState(() {
                            securityQuestion = value.toString();
                          });
                        },
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
                      ButtonWidget(
                        title: language.form_field_button_save_text,
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            Utils.modalProgress(context);

                            Map<dynamic, dynamic> data =
                                _formKey.currentState!.value;
                            DateTime currentTime = DateTime.now();

                            Profile response = await ProfileModel()
                                .profileById(data["profile"]);

                            User user = User(
                              userUid: Utils.uid(),
                              firstName: data["firstName"],
                              lastName: data["lastName"],
                              mobileNumber: data["mobileNumber"],
                              email: data["email"],
                              province: data["province"],
                              district: data["district"],
                              administrativePost: data["administrativePost"],
                              password: data["password"],
                              securityQuestion: data["securityQuestion"],
                              securityAnswer: data["securityAnswer"].toString().toLowerCase(),
                              profileId: response.id,
                              createdAt: currentTime,
                              updatedAt: currentTime,
                              lastSyncAt: currentTime,
                              syncStatus: 0,

                              //related attributes
                              profile: response.name,
                              visibility: response.visibility,
                            );

                            UserModel()
                                .checkIfUsersExistsLocallyByUsername(
                                    username: user.mobileNumber ?? user.email)
                                .then(
                              (value) {
                                if (value == true) {
                                  Navigator.pop(context);
                                  Utils.snackbar(
                                    context,
                                    "Already exiting user. Don't remember your password? Please contact the administrator",
                                  );
                                } else {
                                  UserModel().insertUser(user).then((value) {
                                    if (value > 0) {
                                      Utils
                                          .navigateToHomePageAfterSigninAndSignup(
                                        context: context,
                                        user: user,
                                        notification:
                                            language.login_unsuccessful_error,
                                      );
                                    } else {
                                      Utils.snackbar(
                                        context,
                                        language
                                            .general_failed_save_form_message,
                                      );
                                    }
                                  }).catchError((e) {
                                    Utils.snackbar(
                                      context,
                                      language
                                          .general_error_occured_save_message(
                                              e.toString()),
                                    );

                                    Navigator.pop(context);
                                  }).whenComplete(
                                    () => null,
                                  );
                                }
                              },
                            );
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
                        actionText: language.signin_call_to_action,
                        callText: language.signin_button_text,
                        pageRoute: const Signin(),
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
