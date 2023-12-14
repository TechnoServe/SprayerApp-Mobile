import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sprayer_app/entities/user.dart';
import 'package:sprayer_app/helpers/utils.dart';
import 'package:sprayer_app/providers/user_session.dart';
import 'package:sprayer_app/views/expenses_income_page.dart';
import 'package:sprayer_app/views/financial_profitability_report_page.dart';
import 'package:sprayer_app/views/financial_report_page.dart';
import 'package:sprayer_app/views/payments_aggreement_page.dart';
import 'package:sprayer_app/views/payments_page.dart';
import 'widgets/custom_page_builder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Finance extends StatefulWidget {
  const Finance({Key? key}) : super(key: key);

  @override
  State<Finance> createState() => _FinanceState();
}

class _FinanceState extends State<Finance> {
  @override
  Widget build(BuildContext context) {
    User user = context.watch<UserSession>().loggedUser!;
    var language = AppLocalizations.of(context)!;


    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: Utils.appBar(context, false),
      body:  SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: CustomPageBuilder(
            title: language.finance_title_page,
            svg: "undraw_wallet_aym5.svg",
            listTile: [
              {
                "item": language.finance_payment_agreement,
                "route": const PaymentsAgreement(),
              },
              {
                "item": language.finance_payments,
                "route": const PaymentsPage(),
              },
              {
                "item": language.finance_expenses_and_incomes,
                "route": const ExpensesIncomePage(),
              },
              {
                "item": language.finance_reports,
                "route": FinancialReportPage(user: user),
              },
              {
                "item": language.finance_profitability_reports,
                "route": FinancialProfitabilityReportPage(user: user),
              },
            ],
          ),
        ),
      ),
    );
  }
}
