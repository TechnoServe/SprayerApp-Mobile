// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:sprayer_app/entities/farmer.dart';
import 'package:sprayer_app/entities/payment_agreement.dart';
import 'package:sprayer_app/entities/user.dart';
import 'package:sprayer_app/helpers/utils.dart';
import 'package:sprayer_app/models/payment_agreement_model.dart';
import 'package:sprayer_app/providers/user_session.dart';
import 'package:sprayer_app/views/widgets/button_widget.dart';
import 'package:sprayer_app/views/widgets/dropdown_widget.dart';
import 'package:sprayer_app/views/widgets/text_form_field_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SavePaymentsAgreement extends StatefulWidget {
  const SavePaymentsAgreement({
    Key? key,
    this.farmer,
  }) : super(key: key);

  final Farmer? farmer;

  @override
  State<SavePaymentsAgreement> createState() => _SavePaymentsAgreementState();
}

class _SavePaymentsAgreementState extends State<SavePaymentsAgreement> {
  final _formKey = GlobalKey<FormBuilderState>();

  TextEditingController aggreedPaymentPerLargeTrees = TextEditingController();
  TextEditingController aggreedPaymentPerSmallTrees = TextEditingController();
  TextEditingController aggreedLargeTreesToSpray = TextEditingController();
  TextEditingController aggreedSmallTreesToSpray = TextEditingController();
  String? paymentType;
  String? numberOfApplications;

  //check if the farmer was passed as parameter to the page
  //it means the page was opened in edit mode
  //returns true for edit mode
  farmerAsParameter() =>
      widget.farmer != null && widget.farmer!.paymentAgreementUid != null;

  updateController() {
    if (farmerAsParameter()) {
      aggreedPaymentPerLargeTrees.text =
          widget.farmer!.aggredPayment.toString();
      aggreedPaymentPerSmallTrees.text =
          widget.farmer!.aggreedPaymentPerSmallTrees.toString();
      aggreedLargeTreesToSpray.text = widget.farmer!.aggredTrees.toString();
      aggreedSmallTreesToSpray.text = widget.farmer!.aggredSmallTrees.toString();
      paymentType = widget.farmer!.paymentType;
      numberOfApplications = widget.farmer!.numberOfApplications.toString();
    }
  }

  @override
  void initState() {
    updateController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User? user = context.watch<UserSession>().loggedUser;
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
                int? paymentAgreementUid =
                    int.tryParse(currentTime.millisecondsSinceEpoch.toString());

                PaymentAgreement paymentAgreement = PaymentAgreement(
                  paymentAgreementUid: widget.farmer!.paymentAgreementUid ??
                      paymentAgreementUid!,
                  userUid: user!.userUid!,
                  farmerUid: widget.farmer!.farmerUid,
                  aggreedPayment: (data["aggreedPaymentPerLargeTrees"] != null)
                      ? double.tryParse(data["aggreedPaymentPerLargeTrees"]) ??
                          0
                      : 0,
                  aggreedPaymentPerSmallTrees:
                      (data["aggreedPaymentPerSmallTrees"] != null)
                          ? double.tryParse(
                                  data["aggreedPaymentPerSmallTrees"]) ??
                              0
                          : 0,
                  aggreedTreesToSpray: (data["aggreedTreesToSpray"] != null)
                      ? int.tryParse(data["aggreedTreesToSpray"]) ?? 0
                      : 0,
                  aggreedSmallTreesToSpray:
                      (data["aggreedSmallTreesToSpray"] != null)
                          ? int.tryParse(data["aggreedSmallTreesToSpray"]) ?? 0
                          : 0,
                  paymentType: data["paymentType"],
                  numberOfApplications: (data["numberOfApplications"] != null)
                      ? int.tryParse(data["numberOfApplications"]) ?? 0
                      : 0,
                  createdAt: currentTime,
                  updatedAt: currentTime,
                  lastSyncAt: currentTime,
                  syncStatus: 0,
                );

                if (farmerAsParameter()) {
                  PaymentAggreementModel()
                      .updatePaymentAgreement(paymentAgreement)
                      .then((value) {
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
                  });
                } else {
                  PaymentAggreementModel()
                      .insertPaymentAgreement(paymentAgreement)
                      .then((value) {
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
                      "${language.form_field_button_save_text} ${language.finance_payment_agreement.toLowerCase()}",
                      style: const TextStyle(
                        fontSize: 25.0,
                        color: Utils.primary,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Utils.sHeight,
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
                          Utils.toDecimal(widget.farmer!.numberOfTrees)),
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    Utils.svgHeader("undraw_done_re_oak4.svg"),
                    Utils.mHeight,
                    TextFormFieldWidget(
                        keyBoard: TextInputType.number,
                        controller: aggreedLargeTreesToSpray,
                        name: "aggreedTreesToSpray",
                        hintText: language
                            .form_field_number_of_trees_sprayed_placeholder),
                    Utils.mHeight,
                    TextFormFieldWidget(
                        keyBoard: TextInputType.number,
                        controller: aggreedSmallTreesToSpray,
                        name: "aggreedSmallTreesToSpray",
                        hintText: language
                            .form_field_number_of_trees_small_sprayed_placeholder),
                    Utils.mHeight,
                    DropdownWidget(
                      initialValue: paymentType,
                      validator: (value) => (value == null)
                          ? language.form_field_mandatory_validation_message
                          : null,
                      name: "paymentType",
                      items: const ["Kg", "Mzn"],
                      hintText: language.form_field_payment_type_placeholder,
                      onChange: (value) {
                        setState(() {
                          paymentType = value.toString();
                        });
                      },
                    ),
                    Utils.mHeight,
                    TextFormFieldWidget(
                      keyBoard: TextInputType.number,
                      controller: aggreedPaymentPerLargeTrees,
                      validator: (value) => (value == null || value.isEmpty)
                          ? language.form_field_mandatory_validation_message
                          : null,
                      name: "aggreedPaymentPerLargeTrees",
                      hintText:
                          language.form_field_payment_per_tree_placeholder,
                    ),
                    Utils.mHeight,
                    TextFormFieldWidget(
                      keyBoard: TextInputType.number,
                      controller: aggreedPaymentPerSmallTrees,
                      validator: (value) => (value == null || value.isEmpty)
                          ? language.form_field_mandatory_validation_message
                          : null,
                      name: "aggreedPaymentPerSmallTrees",
                      hintText: language
                          .form_field_payment_per_small_tree_placeholder,
                    ),
                    Utils.mHeight,
                    DropdownWidget(
                      initialValue: numberOfApplications,
                      validator: (value) => (value == null)
                          ? language.form_field_mandatory_validation_message
                          : null,
                      name: "numberOfApplications",
                      items: const ["1", "2", "3"],
                      hintText: language
                          .form_field_number_of_applications_placeholder,
                      onChange: (value) {
                        setState(() {
                          numberOfApplications = value.toString();
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
