// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sprayer_app/entities/farmer.dart';
import 'package:sprayer_app/entities/user.dart';
import 'package:sprayer_app/helpers/utils.dart';
import 'package:sprayer_app/models/payment_model.dart';
import 'package:sprayer_app/providers/user_session.dart';
import 'package:sprayer_app/views/save_payments.dart';
import 'package:sprayer_app/views/widgets/costum_list_title_widget.dart';
import 'package:sprayer_app/views/widgets/custom_chip_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PaymentsPage extends StatefulWidget {
  const PaymentsPage({Key? key}) : super(key: key);

  @override
  State<PaymentsPage> createState() => _PaymentsPageState();
}

class _PaymentsPageState extends State<PaymentsPage> {
  StreamController<int> totalReturnedRecords = StreamController();

  @override
  void dispose() {
    totalReturnedRecords.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context)!;
    User user = context.watch<UserSession>().loggedUser!;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: Utils.appBar(context, false),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Column(
              children: [
                Utils.showCurrentCampaign(),
                Text(
                  language.finance_payments_title,
                  style: const TextStyle(
                    fontSize: 25.0,
                    color: Utils.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                StreamBuilder<int>(
                  stream: totalReturnedRecords.stream,
                  initialData: 0,
                  builder: (context, snapshot) {
                    return Text(
                      language.general_total_returned_message(snapshot.data!),
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Theme.of(context).primaryColor,
                      ),
                    );
                  },
                ),
                Utils.svgHeader("undraw_receipt_re_fre3.svg"),
                FutureBuilder<List<Farmer>>(
                    future: PaymentModel().farmers(user.userUid!),
                    initialData: const [],
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const SizedBox(
                          height: 50.0,
                          width: 50.0,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      if (snapshot.hasError) {
                        return Container();
                      }

                      List<Farmer>? farmers = snapshot.data;
                      int listLength = farmers!.length;

                      totalReturnedRecords.sink.add(listLength);

                      return ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          int numberOfApplication =
                              farmers[index].numberOfApplications ?? 0;

                          double agreedPaymentPerTreesInEachApplication = 0,
                              toPay = 0,
                              debit = 0;

                          double totalPaid = farmers[index].totalPaid ?? 0;
                          double discount = farmers[index].discount ?? 0;
                          totalPaid = totalPaid.roundToDouble();

                          if (numberOfApplication > 0) {
                            agreedPaymentPerTreesInEachApplication =
                                farmers[index].aggredPayment! /
                                    numberOfApplication;

                            int fisrtApplication =
                                farmers[index].treesSprayedInFirstApplication ??
                                    0;
                            int secondApplication = farmers[index]
                                    .treesSprayedInSecondApplication ??
                                0;
                            int thirdApplication =
                                farmers[index].treesSprayedInThirdApplication ??
                                    0;

                            toPay = ((fisrtApplication +
                                        secondApplication +
                                        thirdApplication) *
                                    agreedPaymentPerTreesInEachApplication)
                                .roundToDouble();

                            debit = (toPay - totalPaid - discount).roundToDouble();
                          }

                          return InkWell(
                            onTap: () async {
                              if (farmers[index].aggredPayment == 0.0 &&
                                  numberOfApplication == 0) {
                                Utils.snackbar(
                                  context,
                                  language.general_set_agreement_message,
                                );
                              } else if (totalPaid == toPay) {
                                Utils.snackbar(
                                  context,
                                  language
                                      .general_agreement_payment_fully_paid_message,
                                );
                              } else {
                                var response = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SavePayments(
                                      farmer: farmers[index],
                                      debit: debit,
                                      totalPaid: totalPaid,
                                      paymentType: farmers[index].paymentType,
                                    ),
                                  ),
                                );

                                if (response == true) {
                                  Utils.snackbar(
                                    context,
                                    language.general_success_save_form_message,
                                  );
                                  setState(() {});
                                } else {}
                              }
                            },
                            child: CustomListTileWidget(
                              sinchronized: "",
                              title: [
                                farmers[index].firstName,
                                farmers[index].lastName
                              ].join(" "),
                              child: (farmers[index].aggredPayment != 0.0 &&
                                      numberOfApplication != 0)
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${language.finance_payments_to_pay}: ${Utils.toDecimal(toPay)} ${farmers[index].paymentType}",
                                          style: const TextStyle(
                                            color: Utils.warning,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            CustomChipWidget(
                                              value:
                                                  "${language.finance_payments_total_debit}: ${Utils.toDecimal(debit)} ${farmers[index].paymentType}",
                                              tileColor: Utils.danger,
                                            ),
                                            const SizedBox(
                                              width: 5.0,
                                            ),
                                            CustomChipWidget(
                                              value:
                                                  "${language.finance_payments_total_paid}: ${Utils.toDecimal(totalPaid)} ${farmers[index].paymentType}",
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  : Column(
                                      children: [
                                        Utils.sHeight,
                                        Text(
                                          language.finance_no_agreement,
                                          style: const TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          );
                        },
                        separatorBuilder: (_, __) => const SizedBox(
                          height: 0.0,
                        ),
                        itemCount: listLength,
                      );
                    }),
                Utils.xlHeight,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
