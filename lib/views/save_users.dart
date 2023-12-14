// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:sprayer_app/entities/profile.dart';
import 'package:sprayer_app/entities/user.dart';
import 'package:sprayer_app/helpers/utils.dart';
import 'package:sprayer_app/models/profile_model.dart';
import 'package:sprayer_app/models/user_model.dart';
import 'package:sprayer_app/models/location_model.dart';
import 'package:sprayer_app/providers/user_session.dart';
import 'package:sprayer_app/views/widgets/button_widget.dart';
import 'package:sprayer_app/views/widgets/dropdown_widget.dart';
import 'package:sprayer_app/views/widgets/text_form_field_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SaveUsersPage extends StatefulWidget {
  const SaveUsersPage({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  State<SaveUsersPage> createState() => _SaveUsersPageState();
}

class _SaveUsersPageState extends State<SaveUsersPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool isObscureText = true;

//controllers for the input fields
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController mobileNumber = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController securityAnswer = TextEditingController();
  DateTime? birthDate;
  String? gender;
  String? province, district, administrativePost, profile;
  String securityQuestion = "";

  //variables to hold location data
  List<String> districts = [], administrativePosts = [];
  List<String> securityQuestions = [
    "Como se chama sua aldeia?",
    "Qual e sua cor favorita?",
    "Qual e seu sobrenome?"
  ];

//updates the controllers in the input fields when the page is in edit mode
  updateControllers() {
    firstName.text = widget.user.firstName!;
    lastName.text = widget.user.lastName ?? "";
    mobileNumber.text = widget.user.mobileNumber ?? "";
    email.text = widget.user.email ?? "";
    province = widget.user.province;
    district = widget.user.district;
    administrativePost = widget.user.administrativePost;
    password.text = widget.user.password ?? "";
    securityQuestion = widget.user.securityQuestion ?? "";
    securityAnswer.text = widget.user.securityAnswer ?? "";
    profile = widget.user.profile;
  }

  @override
  void initState() {
    updateControllers();

    districts = LocationModel.getDistricts(province!);

    administrativePosts =
        LocationModel.getAdministrativePosts(province!, district!);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: Utils.appBar(context, true),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          height: 80.0,
          child: ButtonWidget(
            title: language.form_field_button_save_text,
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
                Map<dynamic, dynamic> data = _formKey.currentState!.value;
                DateTime currentTime = DateTime.now();

                Profile response =
                    await ProfileModel().profileById(data["profile"]);

                User user = User(
                  id: widget.user.id,
                  userUid: widget.user.userUid,
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
                  createdAt: widget.user.createdAt,
                  updatedAt: currentTime,
                  lastSyncAt: widget.user.lastSyncAt,
                  syncStatus: widget.user.syncStatus,

                  //related attributes
                  profile: response.name,
                  visibility: response.visibility,
                );

                UserModel().updateUser(user).then((value) {
                  Provider.of<UserSession>(context, listen: false)
                      .updateLoggedUser(user);

                  Utils.snackbar(
                    context,
                    language.general_success_save_form_message,
                  );
                }).catchError((e) {
                  Utils.snackbar(
                    context,
                    language.general_error_occured_save_message(
                      e.toString(),
                    ),
                  );
                });
              } else {
                Utils.snackbar(
                  context,
                  language.form_field_mandatory_validation_message,
                );
              }
            },
          ),
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          Utils.closeForm(context);

          return true;
        },
        child: SingleChildScrollView(
          child: Center(
            child: FormBuilder(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                      left: 15.0,
                      right: 15.0,
                      bottom: 15.0,
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "Save user",
                          style: TextStyle(
                            fontSize: 25.0,
                            color: Utils.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          "Fill the user details",
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.black54,
                          ),
                        ),
                        Utils.mHeight,
                        TextFormFieldWidget(
                          controller: firstName,
                          validator: (value) => (value == null || value.isEmpty)
                              ? language.form_field_mandatory_validation_message
                              : null,
                          name: "firstName",
                          hintText: language.form_field_firstname_placeholder,
                        ),
                        Utils.mHeight,
                        TextFormFieldWidget(
                          validator: (value) => (value == null || value.isEmpty)
                              ? language.form_field_mandatory_validation_message
                              : null,
                          controller: lastName,
                          name: "lastName",
                          hintText: language.form_field_lastname_placeholder,
                        ),
                        Utils.mHeight,
                        TextFormFieldWidget(
                          controller: mobileNumber,
                          keyBoard: TextInputType.phone,
                          validator: (value) => (value == null || value.isEmpty)
                              ? language.form_field_mandatory_validation_message
                              : null,
                          name: "mobileNumber",
                          hintText: language.form_field_mobile_number_placeholder,
                        ),
                        Utils.mHeight,
                        TextFormFieldWidget(
                          controller: email,
                          name: "email",
                          hintText: language.form_field_email_placeholder,
                        ),
                        Utils.mHeight,
                        DropdownWidget(
                          validator: (value) => (value == null)
                              ? language.form_field_mandatory_validation_message
                              : null,
                          initialValue: province,
                          name: "province",
                          items: LocationModel.getProvinces(),
                          hintText: language.form_field_province_placeholder,
                          onChange: (value) {
                            setState(() {
                              province = value.toString();
                              districts.clear();
                              districts = LocationModel.getDistricts(province!);
                            });
                          },
                        ),
                        Utils.mHeight,
                        DropdownWidget(
                          validator: (value) => (value == null)
                              ? language.form_field_mandatory_validation_message
                              : null,
                          initialValue: district ?? districts.first,
                          name: "district",
                          items: districts,
                          hintText: language.form_field_district_placeholder,
                          onChange: (value) {
                            setState(() {
                              district = value.toString();
                              administrativePosts.clear();
                              administrativePosts =
                                  LocationModel.getAdministrativePosts(
                                      province!, district!);
                            });
                          },
                        ),
                        Utils.mHeight,
                        DropdownWidget(
                          validator: (value) => (value == null)
                              ? language.form_field_mandatory_validation_message
                              : null,
                          initialValue:
                              administrativePost ?? administrativePosts.first,
                          name: "administrativePost",
                          items: administrativePosts,
                          hintText: language.form_field_administrativepost_placeholder,
                        ),
                        Utils.mHeight,
                        TextFormFieldWidget(
                          validator: (value) => (value == null || value.isEmpty)
                              ? language.form_field_mandatory_validation_message
                              : null,
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
                          hintText: language.recover_safety_question_placeholder,
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
                        FutureBuilder<List<Profile>>(
                            future: ProfileModel().profiles(),
                            initialData: [],
                            builder: (context, snapshot) {
                              List<Profile> profileList = snapshot.data ?? [];

                              return DropdownWidget(
                                validator: (value) => (value == null)
                                    ? language
                                        .form_field_mandatory_validation_message
                                    : null,
                                initialValue: profile,
                                name: "profile",
                                items: profileList.map((e) => e.name).toList(),
                                hintText: "Perfis",
                                onChange: (value) {
                                  setState(() {
                                    profile = value.toString();
                                  });
                                },
                              );
                            }),
                        Utils.mHeight,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
