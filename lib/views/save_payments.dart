// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:sprayer_app/entities/farmer.dart';
import 'package:sprayer_app/entities/payment.dart';
import 'package:sprayer_app/entities/user.dart';
import 'package:sprayer_app/helpers/utils.dart';
import 'package:sprayer_app/models/payment_model.dart';
import 'package:sprayer_app/providers/user_session.dart';
import 'package:sprayer_app/views/widgets/button_widget.dart';
import 'package:sprayer_app/views/widgets/text_form_field_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SavePayments extends StatefulWidget {
  const SavePayments({
    Key? key,
    this.farmer,
    this.debit,
    this.totalPaid,
    this.paymentType,
  }) : super(key: key);

  final Farmer? farmer;
  final double? debit;
  final double? totalPaid;
  final String? paymentType;

  @override
  State<SavePayments> createState() => _SavePaymentsState();
}

class _SavePaymentsState extends State<SavePayments> {
  final _formKey = GlobalKey<FormBuilderState>();

  TextEditingController paid = TextEditingController();
  TextEditingController discount = TextEditingController();
  TextEditingController description = TextEditingController();
  String? paymentType;

  //check if the farmer was passed as parameter to the page
  //it means the page was opened in edit mode
  //returns true for edit mode
  farmerAsParameter() =>
      widget.farmer != null && widget.farmer!.paymentUid != null;

  updateController() {
    if (farmerAsParameter()) {
      paid.text = widget.farmer!.aggredPayment.toString();
      discount.text = widget.farmer!.aggredTrees.toString();
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
                int? paymentUid =
                    int.tryParse(currentTime.millisecondsSinceEpoch.toString());

                double? paid = (data["paid"] == null || data["paid"].isEmpty)
                    ? 0
                    : double.tryParse(data["paid"]);

                double? discount =
                    (data["discount"] == null || data["discount"].isEmpty)
                        ? 0
                        : double.tryParse(data["discount"]);

                if ((paid! + discount!) > widget.debit!) {
                  Utils.snackbar(
                    context,
                    language.general_agreement_payment_over_paid_message,
                  );
                } else {
                  Payment payment = Payment(
                    paymentUid: paymentUid!,
                    userUid: user!.userUid!,
                    farmerUid: widget.farmer!.farmerUid,
                    paid: paid,
                    discount: discount,
                    paymentType: widget.paymentType,
                    description: data["description"],
                    createdAt: currentTime,
                    updatedAt: currentTime,
                    lastSyncAt: currentTime,
                    syncStatus: 0,
                  );

                  print(payment.paid);

                  if (farmerAsParameter()) {
                    PaymentModel().updatePayment(payment).then((value) {
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
                        language
                            .general_error_occured_save_message(e.toString()),
                      );

                      Navigator.pop(context);
                    });
                  } else {
                    PaymentModel().insertPayment(payment).then((value) {
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
                        language
                            .general_error_occured_save_message(e.toString()),
                      );

                      Navigator.pop(context);
                    });
                  }
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
                      "${language.form_field_button_save_text} ${language.finance_payments.toLowerCase()}",
                      style: const TextStyle(
                        fontSize: 25.0,
                        color: Utils.primary,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                            "${language.general_debit_entity}: ${Utils.toDecimal(widget.debit ?? 0)} ${widget.paymentType}",
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: Utils.danger,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Utils.svgHeader("undraw_done_re_oak4.svg"),
                    Utils.mHeight,
                    TextFormFieldWidget(
                      validator: (value) => (value == null || value.isEmpty)
                          ? language.form_field_mandatory_validation_message
                          : null,
                      keyBoard: TextInputType.number,
                      controller: paid,
                      name: "paid",
                      hintText:
                          language.form_field_collected_amount_placeholder,
                    ),
                    Utils.mHeight,
                    TextFormFieldWidget(
                      keyBoard: TextInputType.number,
                      controller: discount,
                      name: "discount",
                      hintText: language.form_field_discount_placeholder,
                    ),
                    Utils.mHeight,
                    TextFormFieldWidget(
                      maxLines: 4,
                      controller: description,
                      name: "description",
                      hintText: language.form_field_description_placeholder,
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
