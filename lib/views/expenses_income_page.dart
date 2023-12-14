import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sprayer_app/entities/expenses_income.dart';
import 'package:sprayer_app/entities/user.dart';
import 'package:sprayer_app/helpers/utils.dart';
import 'package:sprayer_app/models/expenses_income_model.dart';
import 'package:sprayer_app/providers/user_session.dart';
import 'package:sprayer_app/views/save_expenses_income.dart';
import 'package:sprayer_app/views/widgets/button_widget.dart';
import 'package:sprayer_app/views/widgets/custom_chip_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ExpensesIncomePage extends StatefulWidget {
  const ExpensesIncomePage({Key? key}) : super(key: key);

  @override
  State<ExpensesIncomePage> createState() => _ExpensesIncomePageState();
}

class _ExpensesIncomePageState extends State<ExpensesIncomePage> {
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
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          height: 80.0,
          child: ButtonWidget(
            title: language.form_field_button_register_transaction,
            onPressed: () async {
              var response = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SaveExpensesIncomePage(),
                ),
              );

              if (response == true) {
                Utils.snackbar(
                  context,
                  language.general_success_save_form_message,
                );
                setState(() {});
              }
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Utils.showCurrentCampaign(),
                Text(
                  "${language.form_field_button_save_text} ${language.finance_expenses_and_incomes.toLowerCase()}",
                  style: const TextStyle(
                    fontSize: 25.0,
                    color: Utils.primary,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                StreamBuilder<int>(
                  stream: totalReturnedRecords.stream,
                  initialData: 0,
                  builder: (context, snapshot) {
                    return Text(
                      language.general_total_returned_message(snapshot.data!),
                      style: const TextStyle(
                        fontSize: 15.0,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    );
                  },
                ),
                Utils.svgHeader("undraw_receipt_re_fre3.svg"),
                FutureBuilder<List<ExpensesIncome>>(
                  future: ExpensesIncomeModel().expensesIncomes(user.userUid!),
                  initialData: const [],
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Utils.progress();
                    }

                    if (snapshot.hasError) {
                      return Container();
                    }

                    List<ExpensesIncome>? expensesIncomes = snapshot.data;
                    int listLength = expensesIncomes!.length;

                    totalReturnedRecords.sink.add(listLength);

                    return ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () async {
                            var response = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SaveExpensesIncomePage(
                                  expensesIncome: expensesIncomes[index],
                                ),
                              ),
                            );

                            if (response == true) {
                              Utils.snackbar(
                                context,
                                language.general_success_save_form_message,
                              );
                              setState(() {});
                            }
                          },
                          child: Card(
                            elevation: 0.0,
                            color: Utils.secondary,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  constraints: const BoxConstraints(
                                    minHeight: 50,
                                    maxHeight: 100,
                                  ),
                                  margin: const EdgeInsets.all(0),
                                  decoration: const BoxDecoration(
                                    color: Utils.primary,
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(30.0),
                                    ),
                                  ),
                                  width: 5,
                                ),
                                Expanded(
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 15.0,
                                    ),
                                    dense: true,
                                    isThreeLine: true,
                                    title: Text(
                                      expensesIncomes[index].category,
                                      style: const TextStyle(
                                        fontSize: Utils.mediumFs,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          expensesIncomes[index]
                                              .expensesIncomeType!,
                                          style: const TextStyle(
                                            color: Utils.warning,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        CustomChipWidget(
                                          value:
                                              "${language.form_field_price_placeholder}: " +
                                                  Utils.toDecimal(
                                                      expensesIncomes[index]
                                                          .price) +
                                                  " " +
                                                  expensesIncomes[index]
                                                      .paymentType!,
                                        ),
                                      ],
                                    ),
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
                  },
                ),
                Utils.xlHeight,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
