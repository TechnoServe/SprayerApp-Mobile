// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:sprayer_app/entities/application.dart';
import 'package:sprayer_app/entities/farmer.dart';
import 'package:sprayer_app/helpers/utils.dart';
import 'package:sprayer_app/models/application_model.dart';
import 'package:sprayer_app/providers/user_session.dart';
import 'package:sprayer_app/views/widgets/button_widget.dart';
import 'package:sprayer_app/views/widgets/date_form_field.dart';
import 'package:sprayer_app/views/widgets/text_form_field_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SaveApplicationPage extends StatefulWidget {
  const SaveApplicationPage({
    Key? key,
    this.farmer,
    required this.title,
    required this.value,
    this.application,
  }) : super(key: key);

  final Farmer? farmer;
  final String title;
  final int value;
  final Application? application;

  @override
  State<SaveApplicationPage> createState() => _SaveApplicationPageState();
}

class _SaveApplicationPageState extends State<SaveApplicationPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  TextEditingController numberOfTreesSprayed = TextEditingController();
  TextEditingController numberOfSmallTreesSprayed = TextEditingController();
  TextEditingController sprayedAt = TextEditingController();

  updateFields() {
    if (widget.application != null) {
      numberOfTreesSprayed.text =
          widget.application!.numberOfTreesSprayed.toString();
      numberOfSmallTreesSprayed.text =
          widget.application!.numberOfSmallTreesSprayed.toString();
      sprayedAt.text = widget.application!.sprayedAt.toString();
    }
  }

  isUpdate() =>
      widget.application != null &&
      widget.application!.chemicalApplicationUid > 0;

  @override
  void initState() {
    updateFields();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: Utils.appBar(
        context,
        true,
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          height: 80.0,
          child: ButtonWidget(
            title: language.form_field_button_save_text,
            onPressed: () async {
              _formKey.currentState!.save();
              if (_formKey.currentState!.validate()) {
                DateTime currentTime = DateTime.now();
                int? applicationUid =
                    int.tryParse(currentTime.millisecondsSinceEpoch.toString());

                Application application = Application(
                  chemicalApplicationUid: isUpdate()
                      ? widget.application!.chemicalApplicationUid
                      : applicationUid!,
                  farmerUid: widget.farmer!.farmerUid,
                  userUid: Provider.of<UserSession>(context, listen: false)
                      .loggedUser!
                      .userUid!,
                  numberOfTreesSprayed: int.tryParse(
                      _formKey.currentState!.value["numberOfTreesSprayed"]) ?? 0,
                  numberOfSmallTreesSprayed: int.tryParse(
                      _formKey.currentState!.value["numberOfSmallTreesSprayed"]) ?? 0,
                  applicationNumber: widget.value,
                  sprayedAt: _formKey.currentState!.value["sprayedAt"],
                  createdAt:
                      isUpdate() ? widget.application!.createdAt : currentTime,
                  updatedAt: currentTime,
                  lastSyncAt:
                      isUpdate() ? widget.application!.lastSyncAt : currentTime,
                  syncStatus: isUpdate() ? widget.application!.syncStatus : 0,
                );

                if (isUpdate()) {
                  ApplicationModel()
                      .updateApplication(application)
                      .then((value) {
                    if (value > 0) {
                      Navigator.pop(context, true);
                    } else {
                      Utils.snackbar(
                        context,
                        language.general_success_save_form_message,
                      );
                    }
                  }).catchError((e) {
                    Utils.snackbar(
                      context,
                      language.general_error_occured_save_message(e.toString()),
                    );

                    Navigator.pop(context, true);
                  }).whenComplete(
                    () => null,
                  );
                } else {
                  ApplicationModel()
                      .insertApplication(application)
                      .then((value) {
                    if (value > 0) {
                      Navigator.pop(context, true);
                    } else {
                      Utils.snackbar(
                        context,
                        language.general_success_save_form_message,
                      );
                    }
                  }).catchError((e) {
                    Utils.snackbar(
                      context,
                      language.general_error_occured_save_message(e.toString()),
                    );

                    Navigator.pop(context, true);
                  }).whenComplete(
                    () => null,
                  );
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
                      widget.title,
                      style: const TextStyle(
                        fontSize: 25.0,
                        color: Utils.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Utils.sHeight,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          [widget.farmer!.firstName, widget.farmer!.lastName]
                              .join(" "),
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        Text(
                          language.general_total_registered_trees_message(
                            Utils.toDecimal(widget.farmer!.numberOfTrees),
                          ),
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                    Utils.svgHeader("undraw_done_re_oak4.svg"),
                    TextFormFieldWidget(
                      controller: numberOfTreesSprayed,
                      validator: (value) {
                        if ((value == null || value.isEmpty)) {
                          return language
                              .form_field_mandatory_validation_message;
                        }

                        int numberOfTrees = widget.farmer?.numberOfTrees ?? 0;
                        int numberOfSprayedTress = 0;

                        if (widget.value == 1) {
                          numberOfSprayedTress =
                              widget.farmer?.treesSprayedInFirstApplication ??
                                  0;
                        } else if (widget.value == 2) {
                          numberOfSprayedTress =
                              widget.farmer?.treesSprayedInSecondApplication ??
                                  0;
                        } else if (widget.value == 3) {
                          numberOfSprayedTress =
                              widget.farmer?.treesSprayedInThirdApplication ??
                                  0;
                        }

                        int currentPrunedTrees = int.tryParse(value) ?? 0;

                        print(currentPrunedTrees + numberOfSprayedTress);
                        print(numberOfTrees);

                        if (currentPrunedTrees + numberOfSprayedTress >
                            numberOfTrees) {
                          return language
                              .form_field_exceeded_validation_message(
                                  numberOfTrees.toString());
                        }

                        return null;
                      },
                      keyBoard: TextInputType.number,
                      name: "numberOfTreesSprayed",
                      hintText: language
                          .form_field_number_of_trees_sprayed_placeholder,
                    ),
                    Utils.mHeight,
                    TextFormFieldWidget(
                      controller: numberOfSmallTreesSprayed,
                      keyBoard: TextInputType.number,
                      name: "numberOfSmallTreesSprayed",
                      hintText: language
                          .form_field_number_of_small_trees_placeholder,
                    ),
                    Utils.mHeight,
                    DateFormFieldWidget(
                      initialValue: DateTime.tryParse(sprayedAt.text),
                      lastDate: DateTime.now(),
                      controller: sprayedAt,
                      validator: (value) => (value == null)
                          ? language.form_field_mandatory_validation_message
                          : null,
                      name: "sprayedAt",
                      hintText: language.form_field_sprayed_date_placeholder,
                    ),
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
