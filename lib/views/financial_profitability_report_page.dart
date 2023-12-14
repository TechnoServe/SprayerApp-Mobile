import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sprayer_app/entities/user.dart';
import 'package:sprayer_app/helpers/utils.dart';
import 'package:sprayer_app/models/dashboard_model.dart';
import 'package:sprayer_app/providers/user_session.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sprayer_app/views/widgets/button_widget.dart';
import 'package:sprayer_app/views/widgets/card_kpi_widget.dart';
import 'package:sprayer_app/views/widgets/date_form_field.dart';

class FinancialProfitabilityReportPage extends StatefulWidget {
  const FinancialProfitabilityReportPage({Key? key, required this.user})
      : super(key: key);

  final User user;

  @override
  State<FinancialProfitabilityReportPage> createState() =>
      _FinancialProfitabilityReportPageState();
}

class _FinancialProfitabilityReportPageState
    extends State<FinancialProfitabilityReportPage> {
  double expense = 0;
  String condition = "";

  final _formKey = GlobalKey<FormBuilderState>();
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();

  getCurrentCampaign() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? campaignPref = prefs.getString("campaign_management");

    if (campaignPref != null) {
      final campaign = jsonDecode(campaignPref);
      int openingCampaign =
          DateTime.parse(campaign["opening"]).millisecondsSinceEpoch;
      int closingCampaign =
          DateTime.parse(campaign["clossing"]).millisecondsSinceEpoch;

      setState(() {
        condition =
            "WHERE user_uid = ${widget.user.userUid!} AND created_at > $openingCampaign AND created_at < $closingCampaign";
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
    User user = context.watch<UserSession>().loggedUser!;

    var language = AppLocalizations.of(context)!;

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
                  language.finance_profitability_reports,
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
                  future: DashboardModel().totalExpenses(context, condition),
                  initialData: 0.0,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Utils.progress();
                    }

                    expense = snapshot.data ?? 0;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: SizedBox(
                        height: 180,
                        child: CardKpiWidget(
                          title: language.finance_profitability_incomes,
                          value: [Utils.toDecimal(expense), "MZN"].join(" "),
                        ),
                      ),
                    );
                  },
                ),
                Utils.mHeight,
                FutureBuilder<double>(
                  future: DashboardModel().totalIncomes(context, condition),
                  initialData: 0.0,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Utils.progress();
                    }

                    double income = snapshot.data ?? 0;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: SizedBox(
                        height: 180,
                        child: CardKpiWidget(
                          title: language.finance_profitability_expense,
                          value: [Utils.toDecimal(expense - income), "MZN"]
                              .join(" "),
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
