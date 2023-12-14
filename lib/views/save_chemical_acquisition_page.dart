// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:sprayer_app/entities/chemical_acquisition.dart';
import 'package:sprayer_app/entities/user.dart';
import 'package:sprayer_app/helpers/utils.dart';
import 'package:sprayer_app/models/chemical_acquisition_model.dart';
import 'package:sprayer_app/providers/user_session.dart';
import 'package:sprayer_app/views/widgets/button_widget.dart';
import 'package:sprayer_app/views/widgets/date_form_field.dart';
import 'package:sprayer_app/views/widgets/dropdown_widget.dart';
import 'package:sprayer_app/views/widgets/text_form_field_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SaveChemicalAcquisitionPage extends StatefulWidget {
  const SaveChemicalAcquisitionPage({
    Key? key,
    this.chemicalAcquisition,
  }) : super(key: key);

  final ChemicalAcquisition? chemicalAcquisition;

  @override
  State<SaveChemicalAcquisitionPage> createState() =>
      _SaveChemicalAcquisitionPageState();
}

class _SaveChemicalAcquisitionPageState
    extends State<SaveChemicalAcquisitionPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  String? acquisitionMode, whereYouAcquired, supplier, chemicalName;
  TextEditingController price = TextEditingController(),
      quantity = TextEditingController();
  DateTime? acquiredAt;

  bool isFree = false;

  Map<String, dynamic> suppliersAndChemicals = {
    "AGRIFOCUS": [
      "Fortis k 5% - L",
      "Suti - L",
      "Starback - L",
      "Cropox Super - Kg",
      "Agrizeb  - L",
    ],
    "BAYER": [
      "Bulldock SC125 - L",
      "Flint SC500 - L",
    ],
    "SNOW Internacional": [
      "Ninja Plus - L",
      "Snow Vil 50 SC - L",
      "Snow Vil Super 20% SC - L",
      "Snow Cop - Kg",
      "Snowtrobin - L",
    ],
    "ETG": [
      "Lambdex - L",
      "Korovil 5SC - L",
      "ETG Copoxy 50% Kg",
    ],
  };

  List<String> chemicals = [];

  //check if the farmer was passed as parameter to the page
  //it means the page was opened in edit mode
  //returns true for edit mode
  chemicalAcquisitionAsParameter() => widget.chemicalAcquisition != null;

  updateControllers() {
    if (chemicalAcquisitionAsParameter()) {
      acquisitionMode = widget.chemicalAcquisition!.acquisitionMode;
      whereYouAcquired = widget.chemicalAcquisition!.whereYouAcquired;
      supplier = widget.chemicalAcquisition!.supplier ?? "";
      chemicalName = widget.chemicalAcquisition!.name;
      price.text = widget.chemicalAcquisition!.price.toString();
      quantity.text = widget.chemicalAcquisition!.quantity.toString();
      acquiredAt = widget.chemicalAcquisition!.acquiredAt;

      for (var element in suppliersAndChemicals.entries) {
        if (element.key == supplier) {
          chemicals = element.value;
        }
      }
    }
  }

  @override
  void initState() {
    updateControllers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User user = context.watch<UserSession>().loggedUser!;
    var language = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: Utils.appBar(context, true),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          height: 80.0,
          child: ButtonWidget(
            title: "Save",
            onPressed: () async {
              _formKey.currentState!.save();
              if (_formKey.currentState!.validate()) {
                Map<dynamic, dynamic> data = _formKey.currentState!.value;
                print(data);

                DateTime currentTime = DateTime.now();
                int? chemicalAcquisitionUid =
                    int.tryParse(currentTime.millisecondsSinceEpoch.toString());

                ChemicalAcquisition chemicalAcquisition = ChemicalAcquisition(
                  chemicalAcquisitionUid: chemicalAcquisitionAsParameter()
                      ? widget.chemicalAcquisition!.chemicalAcquisitionUid
                      : chemicalAcquisitionUid!,
                  userUid: user.userUid!,
                  acquisitionMode: data["acquisitionMode"],
                  whereYouAcquired: data["whereYouAcquired"],
                  supplier: data["supplier"]!,
                  name: data["name"]!,
                  quantity: data["quantity"] != null
                      ? double.tryParse(data["quantity"])
                      : 0,
                  price: !isFree
                      ? (data["price"] != null
                          ? double.tryParse(data["price"])
                          : 0)
                      : 0,
                  acquiredAt: data["acquiredAt"],
                  createdAt: chemicalAcquisitionAsParameter()
                      ? widget.chemicalAcquisition!.createdAt
                      : currentTime,
                  updatedAt: currentTime,
                  lastSyncAt: chemicalAcquisitionAsParameter()
                      ? widget.chemicalAcquisition!.lastSyncAt
                      : currentTime,
                  syncStatus: chemicalAcquisitionAsParameter()
                      ? widget.chemicalAcquisition!.syncStatus
                      : 0,
                );

                if (chemicalAcquisitionAsParameter()) {
                  ChemicalAcquisitionModel()
                      .updateChemicalAcquisition(chemicalAcquisition)
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
                  ChemicalAcquisitionModel()
                      .insertChemicalAcquisition(chemicalAcquisition)
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
                      "${language.form_field_button_save_text} ${language.chemical_acquisition_title.toLowerCase()}",
                      style: const TextStyle(
                        fontSize: 25.0,
                        color: Utils.primary,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Utils.sHeight,
                    Utils.svgHeader("undraw_done_re_oak4.svg"),
                    DropdownWidget(
                      initialValue: acquisitionMode,
                      validator: (value) => (value == null)
                          ? language.form_field_mandatory_validation_message
                          : null,
                      name: "acquisitionMode",
                      items: [
                        language.form_field_free_input_value,
                        language.form_field_buy_input_value,
                        "Produtor"
                      ],
                      hintText: language
                          .form_field_how_did_you_get_chemicals_placeholder,
                      onChange: (value) {
                        setState(() {
                          acquisitionMode = value.toString();
                          isFree = value == language.form_field_free_input_value
                              ? true
                              : false;
                        });
                      },
                    ),
                    Utils.mHeight,
                    DropdownWidget(
                      initialValue: whereYouAcquired,
                      validator: (value) => (value == null)
                          ? language.form_field_mandatory_validation_message
                          : null,
                      name: "whereYouAcquired",
                      items: const [
                        "Agro-Dealers",
                        "Feira",
                        "Provedor"
                      ],
                      hintText: "Onde adquiriu os quimicos",
                      onChange: (value) {
                        setState(() {
                          whereYouAcquired = value.toString();
                        });
                      },
                    ),
                    Utils.mHeight,
                    DropdownWidget(
                      initialValue: supplier,
                      validator: (value) => (value == null)
                          ? language.form_field_mandatory_validation_message
                          : null,
                      name: "supplier",
                      items: suppliersAndChemicals.entries
                          .map((e) => e.key)
                          .toList(),
                      hintText: language.form_field_supplier_placeholder,
                      onChange: (value) {
                        setState(() {
                          supplier = value.toString();
                          chemicals.clear();
                          for (var element in suppliersAndChemicals.entries) {
                            if (element.key == value.toString()) {
                              chemicals = element.value;
                            }
                          }
                        });
                      },
                    ),
                    Utils.mHeight,
                    DropdownWidget(
                      initialValue: chemicalName,
                      validator: (value) => (value == null)
                          ? language.form_field_mandatory_validation_message
                          : null,
                      name: "name",
                      items: chemicals,
                      hintText: language.form_field_chemical_name_placeholder,
                    ),
                    (isFree == false)
                        ? Column(
                            children: [
                              Utils.mHeight,
                              TextFormFieldWidget(
                                validator: (value) => (value == null ||
                                        value.isEmpty)
                                    ? language
                                        .form_field_mandatory_validation_message
                                    : null,
                                controller: price,
                                keyBoard: TextInputType.number,
                                name: "price",
                                hintText:
                                    language.form_field_total_price_placeholder,
                              ),
                            ],
                          )
                        : Container(),
                    Utils.mHeight,
                    TextFormFieldWidget(
                      validator: (value) => (value == null || value.isEmpty)
                          ? language.form_field_mandatory_validation_message
                          : null,
                      controller: quantity,
                      keyBoard: TextInputType.number,
                      name: "quantity",
                      hintText: language.form_field_quantity_placeholder,
                    ),
                    Utils.mHeight,
                    DateFormFieldWidget(
                      initialValue: acquiredAt,
                      name: "acquiredAt",
                      hintText: language.form_field_acquired_date_placeholder,
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
