// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:sprayer_app/entities/farmer.dart';
import 'package:sprayer_app/entities/preparatory_activity.dart';
import 'package:sprayer_app/entities/user.dart';
import 'package:sprayer_app/helpers/utils.dart';
import 'package:sprayer_app/models/preparatory_activity_model.dart';
import 'package:sprayer_app/providers/user_session.dart';
import 'package:sprayer_app/views/widgets/button_widget.dart';
import 'package:sprayer_app/views/widgets/dropdown_widget.dart';
import 'package:sprayer_app/views/widgets/text_form_field_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SavePreparatoryActivityPage extends StatefulWidget {
  const SavePreparatoryActivityPage({
    Key? key,
    this.farmer,
    this.preparatoryActivity,
  }) : super(key: key);

  final Farmer? farmer;
  final PreparatoryActivity? preparatoryActivity;

  @override
  State<SavePreparatoryActivityPage> createState() =>
      _SavePreparatoryActivityPageState();
}

class _SavePreparatoryActivityPageState
    extends State<SavePreparatoryActivityPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  TextEditingController numberOfTreesCleaned = TextEditingController();
  TextEditingController numberOfTreesPruned = TextEditingController();
  String? pruningType;

  updateFields() {
    if (widget.preparatoryActivity != null) {
      numberOfTreesCleaned.text =
          widget.preparatoryActivity!.numberOfTreesCleaned.toString();
      numberOfTreesPruned.text =
          widget.preparatoryActivity!.numberOfTreesPruned.toString();
      pruningType = widget.preparatoryActivity!.pruningType;
    }
  }

  isUpdate() =>
      widget.preparatoryActivity != null &&
      widget.preparatoryActivity!.numberOfTreesPruned > 0 &&
      widget.preparatoryActivity!.numberOfTreesCleaned > 0;

  @override
  void initState() {
    updateFields();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User user = context.watch<UserSession>().loggedUser!;
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
                Map<dynamic, dynamic> data = _formKey.currentState!.value;
                DateTime currentTime = DateTime.now();

                PreparatoryActivity preparatoryActivity = PreparatoryActivity(
                  preparatoryActivityUid: isUpdate()
                      ? widget.preparatoryActivity!.preparatoryActivityUid
                      : Utils.uid(),
                  farmerUid: widget.farmer!.farmerUid,
                  userUid: user.userUid!,
                  numberOfTreesCleaned:
                      int.tryParse(data["numberOfTreesCleaned"])!,
                  numberOfTreesPruned:
                      int.tryParse(data["numberOfTreesPruned"])!,
                  pruningType: data["pruningType"],
                  createdAt: isUpdate()
                      ? widget.preparatoryActivity!.createdAt
                      : currentTime,
                  updatedAt: currentTime,
                  lastSyncAt: isUpdate()
                      ? widget.preparatoryActivity!.lastSyncAt
                      : currentTime,
                  syncStatus:
                      isUpdate() ? widget.preparatoryActivity!.syncStatus : 0,
                );

                if (isUpdate()) {
                  PreparatoryActivityModel()
                      .updatePreparatoryActivity(preparatoryActivity)
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

                    Navigator.pop(context);
                  }).whenComplete(
                    () => null,
                  );
                } else {
                  PreparatoryActivityModel()
                      .insertPreparatoryActivity(preparatoryActivity)
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

                    Navigator.pop(context);
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
                      "${language.form_field_button_save_text} ${language.chemical_integrated_managment_preparatory_activity.toLowerCase()}",
                      style: const TextStyle(
                        fontSize: 25.0,
                        color: Utils.primary,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
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
                          "${widget.farmer!.numberOfTrees} registered trees",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                    Utils.svgHeader("undraw_done_re_oak4.svg"),
                    Utils.mHeight,
                    TextFormFieldWidget(
                      controller: numberOfTreesPruned,
                      validator: (value) {
                        if ((value == null || value.isEmpty)) {
                          return language
                              .form_field_mandatory_validation_message;
                        }

                        int numberOfTrees = widget.farmer?.numberOfTrees ?? 0;
                        int numberOfTreesPruned =
                            widget.farmer?.treesPruned ?? 0;
                        int currentPrunedTrees = int.tryParse(value) ?? 0;

                        if (currentPrunedTrees + numberOfTreesPruned >
                            numberOfTrees) {
                          return "Excedeu o numero de $numberOfTrees arvores do produtor";
                        }

                        return null;
                      },
                      keyBoard: TextInputType.number,
                      name: "numberOfTreesPruned",
                      hintText: language
                          .form_field_number_of_trees_pruned_placeholder,
                    ),
                    Utils.mHeight,
                    TextFormFieldWidget(
                      controller: numberOfTreesCleaned,
                      validator: (value) {
                        if ((value == null || value.isEmpty)) {
                          return language
                              .form_field_mandatory_validation_message;
                        }

                        int numberOfTrees = widget.farmer?.numberOfTrees ?? 0;
                        int numberOfTreesCleaned =
                            widget.farmer?.treesCleaned ?? 0;
                        int currentPrunedTrees = int.tryParse(value) ?? 0;

                        print(currentPrunedTrees + numberOfTreesCleaned);
                        print(numberOfTrees);

                        if (currentPrunedTrees + numberOfTreesCleaned >
                            numberOfTrees) {
                          return language
                              .form_field_exceeded_validation_message(
                                  numberOfTrees.toString());
                        }

                        return null;
                      },
                      keyBoard: TextInputType.number,
                      name: "numberOfTreesCleaned",
                      hintText: language
                          .form_field_number_of_trees_cleaned_placeholder,
                    ),
                    Utils.mHeight,
                    DropdownWidget(
                      validator: (value) => (value == null)
                          ? language.form_field_mandatory_validation_message
                          : null,
                      name: "pruningType",
                      initialValue: pruningType,
                      items: const ["Pre Colheita", "Pos Colheita"],
                      hintText: language.form_field_pruning_type_placeholder,
                      onChange: (value) {
                        setState(() {
                          pruningType = value.toString();
                        });
                      },
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
