// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sprayer_app/entities/farmer.dart';
import 'package:sprayer_app/entities/user.dart';
import 'package:sprayer_app/helpers/utils.dart';
import 'package:sprayer_app/models/payment_agreement_model.dart';
import 'package:sprayer_app/providers/user_session.dart';
import 'package:sprayer_app/views/save_payments_agreement.dart';
import 'package:sprayer_app/views/search_for_farmer_page.dart';
import 'package:sprayer_app/views/widgets/costum_list_title_widget.dart';
import 'package:sprayer_app/views/widgets/custom_chip_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PaymentsAgreement extends StatefulWidget {
  const PaymentsAgreement({Key? key}) : super(key: key);

  @override
  State<PaymentsAgreement> createState() => _PaymentsAgreementState();
}

class _PaymentsAgreementState extends State<PaymentsAgreement> {
  StreamController<int> totalReturnedRecords = StreamController();

  bool isSearch = false;
  Map searchMap = {};

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
      appBar: Utils.appBar(
        context,
        false,
        actions: <Widget>[
          PopupMenuButton<int>(
            icon: const Icon(
              FontAwesomeIcons.ellipsisVertical,
              color: Utils.primary,
            ),
            onSelected: (item) async {
              if (item == 0) {
                Map response = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SearchForFarmerPage(),
                  ),
                );

                if (response["firstName"] != null ||
                    response["lastName"] != null ||
                    response["mobileNumber"] != null ||
                    response["administrativePost"] != null) {
                  setState(() {
                    isSearch = true;
                    searchMap = response;
                  });

                  print(response);
                } else {
                  setState(() {
                    isSearch = false;
                  });
                }
              } else if (item == 1) {
                setState(() {
                  isSearch = false;
                });
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                value: 0,
                child: Text(
                  language.search_farmers,
                ),
              ),
              PopupMenuItem<int>(
                value: 1,
                child: Text(
                  language.general_refresh,
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Column(
              children: [
                Utils.showCurrentCampaign(),
                Text(
                  language.finance_payment_agreement,
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
                    future: PaymentAggreementModel().farmers(user.userUid!),
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

                      if (isSearch == true) {
                        farmers = farmers!.where((element) {
                          return ((searchMap["firstName"] != null &&
                                  element.firstName.toLowerCase().contains(
                                      searchMap["firstName"]
                                          .toString()
                                          .toLowerCase())) ||
                              (searchMap["lastName"] != null &&
                                      element.lastName!.toLowerCase().contains(
                                          searchMap["lastName"]
                                              .toString()
                                              .toLowerCase()) ||
                                  (searchMap["mobileNumber"] != null &&
                                      element.mobileNumber! ==
                                          searchMap["mobileNumber"])));
                        }).toList();
                      }

                      int listLength = farmers!.length;

                      totalReturnedRecords.sink.add(listLength);

                      return ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          print(farmers![index].aggredPayment ?? 0);

                          int numberOfLargeTrees = farmers[index].aggredTrees ?? 0;
                          int numberOfSmallTrees = farmers[index].aggredSmallTrees ?? 0;

                          return InkWell(
                            onTap: () async {
                              var response = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SavePaymentsAgreement(
                                    farmer: farmers![index],
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
                            },
                            child: CustomListTileWidget(
                              sinchronized: "",
                              title: [
                                farmers[index].firstName,
                                farmers[index].lastName
                              ].join(" "),
                              child: (farmers[index].aggredPayment != 0.0 &&
                                      farmers[index].numberOfApplications != 0)
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${farmers[index].numberOfApplications} ${language.general_applications_entity}",
                                          style: const TextStyle(
                                            color: Utils.warning,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            CustomChipWidget(
                                              value:
                                                  "${farmers[index].aggredPayment} ${farmers[index].paymentType}/${language.general_tress_entity}",
                                            ),
                                            const SizedBox(
                                              width: 5.0,
                                            ),
                                            CustomChipWidget(
                                              value:
                                                  "${Utils.toDecimal(numberOfLargeTrees + numberOfSmallTrees)} ${language.general_agreed_tress_entity}",
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  : Column(
                                      children:  [
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
                const SizedBox(
                  height: 40.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
