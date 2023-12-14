import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:sprayer_app/entities/farmer.dart';
import 'package:sprayer_app/entities/user.dart';
import 'package:sprayer_app/helpers/utils.dart';
import 'package:sprayer_app/models/farmer_model.dart';
import 'package:sprayer_app/models/location_model.dart';
import 'package:sprayer_app/providers/farmer_session.dart';
import 'package:sprayer_app/providers/user_session.dart';
import 'package:sprayer_app/views/widgets/button_widget.dart';
import 'package:sprayer_app/views/widgets/dropdown_widget.dart';
import 'package:sprayer_app/views/widgets/text_form_field_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SaveFarmersPage extends StatefulWidget {
  const SaveFarmersPage({
    Key? key,
    this.farmer,
  }) : super(key: key);

  final Farmer? farmer;

  @override
  State<SaveFarmersPage> createState() => _SaveFarmersPageState();
}

class _SaveFarmersPageState extends State<SaveFarmersPage> {
  final _formKey = GlobalKey<FormBuilderState>();

  List<String> birthYear = [];
  List<String> districts = [], administrativePosts = [];

  getBirthYears() {
    List<String> _birthYear = [];
    for (int year = 1980; year <= 2015; year++) {
      birthYear.add(year.toString());
    }
    birthYear.sort((a, b) => b.compareTo(a));
  }

//controllers for the input fields
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  DateTime? birthDate;
  String? genderController, birthYearController;
  String districtController = "";
  String? administrativePostController;

  //check if the farmer was passed as parameter to the page
  //it means the page was opened in edit mode
  //returns true for edit mode
  farmerAsParameter() => widget.farmer != null && widget.farmer!.id != null;

//updates the controllers in the input fields when the page is in edit mode
  updateControllers() {
    if (farmerAsParameter()) {
      print(widget.farmer!);

      firstNameController.text = widget.farmer!.firstName;
      lastNameController.text = widget.farmer!.lastName!;
      mobileNumberController.text = widget.farmer!.mobileNumber!;
      birthDate =
          (widget.farmer!.birthDate != null) ? widget.farmer!.birthDate : null;
      birthYearController = widget.farmer!.birthYear.toString();
      genderController = widget.farmer!.gender;
      districtController = widget.farmer!.district!;
      administrativePostController = widget.farmer!.administrativePost;

      districts = LocationModel.getDistricts(widget.farmer!.province!);

      administrativePosts =
          LocationModel.getAdministrativePosts(
              widget.farmer!.province!, widget.farmer!.district!);
    }
  }

  @override
  void initState() {
    updateControllers();
    getBirthYears();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User user = context.watch<UserSession>().loggedUser!;
    var language = AppLocalizations.of(context)!;

    if(districts.isEmpty) {
      districts = LocationModel.getDistricts(user.province!);
    }

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
              _formKey.currentState!.save();
              if (_formKey.currentState!.validate()) {
                Map<dynamic, dynamic> data = _formKey.currentState!.value;
                DateTime currentTime = DateTime.now();

                Farmer farmer = Farmer(
                  id: farmerAsParameter() ? widget.farmer!.id : null,
                  farmerUid: farmerAsParameter()
                      ? widget.farmer!.farmerUid
                      : Utils.uid(),
                  userUid: user.userUid!,
                  firstName: data["firstName"],
                  lastName: data["lastName"],
                  birthDate: null,
                  birthYear: int.tryParse(data["birthYear"]),
                  gender: data["gender"],
                  mobileNumber: data["mobileNumber"],
                  email: data["email"],
                  province: user.province,
                  district: data["district"],
                  administrativePost: data["administrativePost"],
                  createdAt: farmerAsParameter()
                      ? widget.farmer!.createdAt
                      : currentTime,
                  updatedAt: currentTime,
                  lastSyncAt: farmerAsParameter()
                      ? widget.farmer!.lastSyncAt
                      : currentTime,
                  syncStatus:
                      farmerAsParameter() ? widget.farmer!.syncStatus : 0,
                  status: 0,
                );

                if (farmerAsParameter()) {
                  FarmerModel().updateFarmer(farmer).then((value) {
                    if (value > 0) {
                      Provider.of<FarmerSession>(context, listen: false)
                          .update(farmer);
                      Navigator.pop(context, true);
                    } else {
                      Utils.snackbar(
                        context,
                        language.general_failed_save_form_message,
                      );
                    }
                  }).catchError((e) {
                    Utils.snackbar(
                      context,
                      language.general_error_occured_save_message(e.toString()),
                    );

                    Navigator.pop(context);
                  });
                } else {
                  FarmerModel().insertFarmer(farmer).then((value) {
                    if (value > 0) {
                      Navigator.pop(context, true);
                    } else {
                      Utils.snackbar(
                          context, language.general_failed_save_form_message);
                    }
                  }).catchError((e) {
                    Utils.snackbar(
                      context,
                      language.general_error_occured_save_message(e.toString()),
                    );

                    Navigator.pop(context);
                  });
                }
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
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: FormBuilder(
                key: _formKey,
                child: Column(
                  children: [
                    Utils.showCurrentCampaign(),
                    Text(
                      language.save_farmers,
                      style: const TextStyle(
                        fontSize: 25.0,
                        color: Utils.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      language.fill_farmer_details,
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    Utils.xlHeight,
                    TextFormFieldWidget(
                      validator: (value) => (value == null || value.isEmpty)
                          ? language.form_field_mandatory_validation_message
                          : null,
                      controller: firstNameController,
                      name: "firstName",
                      hintText: language.form_field_firstname_placeholder,
                    ),
                    Utils.mHeight,
                    TextFormFieldWidget(
                      validator: (value) => (value == null || value.isEmpty)
                          ? language.form_field_mandatory_validation_message
                          : null,
                      controller: lastNameController,
                      name: "lastName",
                      hintText: language.form_field_lastname_placeholder,
                    ),
                    Utils.mHeight,
                    DropdownWidget(
                      validator: (value) => (value == null)
                          ? language.form_field_mandatory_validation_message
                          : null,
                      initialValue: genderController,
                      name: "gender",
                      items: const ["Homem", "Mulher"],
                      hintText: language.form_field_gender_placeholder,
                      onChange: (value) {
                        setState(() {
                          genderController = value.toString();
                        });
                      },
                    ),
                    Utils.mHeight,
                    DropdownWidget(
                      validator: (value) => (value == null)
                          ? language.form_field_mandatory_validation_message
                          : null,
                      initialValue: birthYearController,
                      name: "birthYear",
                      items: birthYear,
                      hintText: language.form_field_birth_year_placeholder,
                      onChange: (value) {
                        setState(() {
                          birthYearController = value.toString();
                        });
                      },
                    ),
                    Utils.mHeight,
                    TextFormFieldWidget(
                      keyBoard: TextInputType.number,
                      controller: mobileNumberController,
                      name: "mobileNumber",
                      hintText: language.form_field_mobile_number_placeholder,
                    ),
                    Utils.mHeight,
                    DropdownWidget(
                      initialValue: districtController,
                      name: "district",
                      validator: (value) => (value == null || value == "")
                          ? language.form_field_mandatory_validation_message
                          : null,
                      items: districts,
                      hintText: language.form_field_district_placeholder,
                      onChange: (value) {
                        setState(() {
                          districtController = value.toString();
                          administrativePosts =
                              LocationModel.getAdministrativePosts(
                                  user.province!, value.toString());
                        });
                      },
                    ),
                    Utils.mHeight,
                    DropdownWidget(
                      validator: (value) => (value == null)
                          ? language.form_field_mandatory_validation_message
                          : null,
                      initialValue: administrativePostController,
                      name: "administrativePost",
                      items: administrativePosts,
                      hintText:
                          language.form_field_administrativepost_placeholder,
                      onChange: (value) {
                        setState(() {
                          administrativePostController = value.toString();
                        });
                      },
                    ),
                    Utils.xlHeight,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
