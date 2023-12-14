// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:sprayer_app/entities/equipment.dart';
import 'package:sprayer_app/entities/user.dart';
import 'package:sprayer_app/helpers/utils.dart';
import 'package:sprayer_app/models/equipment_model.dart';
import 'package:sprayer_app/providers/user_session.dart';
import 'package:sprayer_app/views/widgets/button_widget.dart';
import 'package:sprayer_app/views/widgets/dropdown_widget.dart';
import 'package:sprayer_app/views/widgets/text_form_field_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SaveEquipmentsPage extends StatefulWidget {
  const SaveEquipmentsPage({
    Key? key,
    this.equipment,
  }) : super(key: key);

  final Equipment? equipment;

  @override
  State<SaveEquipmentsPage> createState() => _SaveEquipmentsPageState();
}

class _SaveEquipmentsPageState extends State<SaveEquipmentsPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  String? name, brand, status, buyedYear;
  TextEditingController model = TextEditingController(),
      description = TextEditingController();
  DateTime? acquiredAt;

  bool isNonOperational = true;

  List<String> years = [];

  getYears() {
    for (var i = DateTime.now().year; i >= 2000; i--) {
      years.add(i.toString());
    }
  }

  //check if the farmer was passed as parameter to the page
  //it means the page was opened in edit mode
  //returns true for edit mode
  equipmentAsParameter() =>
      widget.equipment != null && widget.equipment!.id != null;

  updateControllers() {
    if (equipmentAsParameter()) {
      name = widget.equipment!.name;
      model.text = widget.equipment!.model!;
      brand = widget.equipment!.brand;
      status = widget.equipment!.status;
      buyedYear = widget.equipment!.buyedYear.toString();

      print(widget.equipment!.equipmentUid);
    }
  }

  @override
  void initState() {
    updateControllers();
    getYears();
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
            title: language.form_field_button_save_text,
            onPressed: () async {
              _formKey.currentState!.save();
              if (_formKey.currentState!.validate()) {
                Map<dynamic, dynamic> data = _formKey.currentState!.value;
                DateTime currentTime = DateTime.now();
                int? equipmentUid =
                    int.tryParse(currentTime.millisecondsSinceEpoch.toString());

                Equipment equipment = Equipment(
                  equipmentUid: equipmentAsParameter()
                      ? widget.equipment!.equipmentUid
                      : equipmentUid!,
                  userUid: user.userUid!,
                  name: data["name"]!,
                  model: data["model"]!,
                  brand: data["brand"]!,
                  status: data["status"]!,
                  buyedYear: equipmentAsParameter()
                      ? widget.equipment!.buyedYear
                      : currentTime.year,
                  createdAt: equipmentAsParameter()
                      ? widget.equipment!.createdAt
                      : currentTime,
                  updatedAt: currentTime,
                  lastSyncAt: equipmentAsParameter()
                      ? widget.equipment!.lastSyncAt
                      : currentTime,
                  syncStatus:
                      equipmentAsParameter() ? widget.equipment!.syncStatus : 0,
                );

                if (equipmentAsParameter()) {
                  EquipmentModel().updateEquipment(equipment).then((value) {
                    if (value > 0) {
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
                  }).whenComplete(
                    () => null,
                  );
                } else {
                  EquipmentModel().insertEquipment(equipment).then((value) {
                    if (value > 0) {
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
                    Text(
                      "${language.form_field_button_save_text} ${language.chemical_equipments_title.toLowerCase()}",
                      style: const TextStyle(
                        fontSize: 25.0,
                        color: Utils.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Utils.sHeight,
                    Utils.svgHeader("undraw_done_re_oak4.svg"),
                    DropdownWidget(
                      initialValue: name,
                      validator: (value) => (value == null)
                          ? language.form_field_mandatory_validation_message
                          : null,
                      name: "name",
                      items:  const [
                        "Atomizador", "EPI", "Catana", "Tractor"
                      ],
                      hintText: language.form_field_equipment_name_placeholder,
                    ),
                    Utils.mHeight,
                    DropdownWidget(
                      initialValue: brand,
                      name: "brand",
                      items: const [
                        "Cifarelli",
                        "Mariyama",
                        "Farmat",
                        "Olimac",
                        "Hunter",
                        "Maruyama",
                        "Honda",
                        "Oleo-Mac",
                        "Warrior",
                        "Sawan",
                        "MISTTUFPER",
                        "ETG3WF3A",
                        "Huskvarna"
                      ],
                      hintText: language.form_field_brand_placeholder,
                    ),
                    Utils.mHeight,
                    DropdownWidget(
                      initialValue: buyedYear,
                      name: "buyedYear",
                      items: years,
                      hintText: language.form_field_buyed_year_placeholder,
                    ),
                    Utils.mHeight,
                    TextFormFieldWidget(
                      controller: model,
                      name: "model",
                      hintText: language.form_field_model_placeholder,
                    ),
                    Utils.mHeight,
                    DropdownWidget(
                      initialValue: status,
                      name: "status",
                      items: [
                        language.form_field_operational_input_value,
                        language.form_field_non_operational_input_value,
                      ],
                      hintText: language.form_field_status_placeholder,
                    ),
                    Utils.mHeight,
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
