// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sprayer_app/entities/user.dart';
import 'package:sprayer_app/helpers/utils.dart';
import 'package:sprayer_app/models/dashboard_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sprayer_app/views/widgets/button_widget.dart';
import 'package:sprayer_app/views/widgets/card_kpi_widget.dart';
import 'package:sprayer_app/views/widgets/date_form_field.dart';

class FinancialReportPage extends StatefulWidget {
  const FinancialReportPage({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  State<FinancialReportPage> createState() => _FinancialReportPageState();
}

class _FinancialReportPageState extends State<FinancialReportPage> {
  double priceOfCashew = 37;
  String condition = "";

  final _formKey = GlobalKey<FormBuilderState>();
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();

  getCurrentCampaign() async {
    String filter = await Utils.getCurrentCampaignFilter(alias: "");

    if (filter.isNotEmpty) {
      setState(() {
        condition = "WHERE user_uid = ${widget.user.userUid!} $filter";
      });
    } else {
      setState(() {
        condition = "WHERE user_uid = ${widget.user.userUid!}";
      });
    }
  }

  @override
  void initState() {
    getCurrentCampaign();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context)!;

    print(condition);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: Utils.appBar(context, false),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Utils.showCurrentCampaign(),
                Text(
                  language.finance_reports,
                  style: const TextStyle(
                    fontSize: 25.0,
                    color: Utils.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Utils.mHeight,
                FormBuilder(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: DateFormFieldWidget(
                            validator: (value) => (value == null)
                                ? language
                                    .form_field_mandatory_validation_message
                                : null,
                            name: "fromSearchDate",
                            controller: fromDateController,
                            hintText:
                                language.form_field_event_from_date_placeholder,
                          ),
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: DateFormFieldWidget(
                            validator: (value) => (value == null)
                                ? language
                                    .form_field_mandatory_validation_message
                                : null,
                            name: "toSearchDate",
                            controller: toDateController,
                            hintText:
                                language.form_field_event_end_date_placeholder,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ButtonWidget(
                    title: language.general_search,
                    onPressed: () {
                      _formKey.currentState!.save();

                      int? fromDate = _formKey.currentState!
                          .value["fromSearchDate"]?.millisecondsSinceEpoch;
                      int? toDate = _formKey.currentState!.value["toSearchDate"]
                          ?.millisecondsSinceEpoch;

                      String? fromQuery;
                      String? toQuery;

                      if (fromDate != null) {
                        fromQuery = "created_at >= $fromDate";
                      }

                      if (toDate != null) {
                        toQuery = "created_at <= $toDate";
                      }

                      setState(() {
                        condition = [
                          "WHERE user_uid = ${widget.user.userUid!}",
                          fromQuery,
                          toQuery
                        ].where((element) => element != null).join(" AND ");
                      });
                    },
                  ),
                ),
                Utils.mHeight,
                FutureBuilder<double>(
                  future: DashboardModel().totalIncomes(context, condition),
                  initialData: 0.0,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Utils.progress();
                    }

                    double income = snapshot.data!;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: SizedBox(
                        height: 200,
                        child: CardKpiWidget(
                          title: language.general_total_incomes,
                          value: [Utils.toDecimal(income), "MZN"].join(" "),
                        ),
                      ),
                    );
                  },
                ),
                Utils.mHeight,
                FutureBuilder<double>(
                  future: DashboardModel().totalExpenses(context, condition),
                  initialData: 0.0,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Utils.progress();
                    }

                    double expense = snapshot.data!;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: SizedBox(
                        height: 200,
                        child: CardKpiWidget(
                          title: language.general_total_expenses,
                          value: [Utils.toDecimal(expense), "MZN"].join(" "),
                        ),
                      ),
                    );
                  },
                ),
                Utils.mHeight,
                FutureBuilder<double>(
                  future: DashboardModel().profitPerTree(context, condition),
                  initialData: 0.0,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Utils.progress();
                    }

                    double income = snapshot.data!;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: SizedBox(
                        height: 180,
                        child: CardKpiWidget(
                          title: language
                              .general_profit_per_tree_per_sprayer_message,
                          value: [Utils.toDecimal(income), "MZN"].join(" "),
                        ),
                      ),
                    );
                  },
                ),
                Utils.mHeight,
                FutureBuilder<double>(
                  future: DashboardModel().costPerTree(context, condition),
                  initialData: 0.0,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Utils.progress();
                    }

                    double costPerTree = snapshot.data!;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: SizedBox(
                        height: 200,
                        child: CardKpiWidget(
                          title: language
                              .general_cost_per_tree_per_sprayer_message,
                          value:
                              [Utils.toDecimal(costPerTree), "MZN"].join(" "),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
