// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:sprayer_app/database/expenses_incomes_category.dart';
import 'package:sprayer_app/entities/expenses_income.dart';
import 'package:sprayer_app/entities/user.dart';
import 'package:sprayer_app/helpers/utils.dart';
import 'package:sprayer_app/models/expenses_income_model.dart';
import 'package:sprayer_app/providers/user_session.dart';
import 'package:sprayer_app/views/widgets/button_widget.dart';
import 'package:sprayer_app/views/widgets/dropdown_widget.dart';
import 'package:sprayer_app/views/widgets/text_form_field_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sprayer_app/providers/locale_provider.dart';

class SaveExpensesIncomePage extends StatefulWidget {
  const SaveExpensesIncomePage({
    Key? key,
    this.expensesIncome,
  }) : super(key: key);

  final ExpensesIncome? expensesIncome;

  @override
  State<SaveExpensesIncomePage> createState() => _SaveExpensesIncomePageState();
}

class _SaveExpensesIncomePageState extends State<SaveExpensesIncomePage> {
  final _formKey = GlobalKey<FormBuilderState>();
  String? category, expensesIncomeType, paymentType;
  TextEditingController price = TextEditingController(),
      description = TextEditingController();
  DateTime? acquiredAt;

  bool isFree = true;

  //check if the farmer was passed as parameter to the page
  //it means the page was opened in edit mode
  //returns true for edit mode
  expensesIncomeAsParameter() =>
      widget.expensesIncome != null && widget.expensesIncome!.id != null;

  updateControllers() {
    if (expensesIncomeAsParameter()) {
      category = widget.expensesIncome!.category;
      expensesIncomeType = widget.expensesIncome!.expensesIncomeType;
      description.text = widget.expensesIncome!.description!;
      price.text = widget.expensesIncome!.price.toString();
      paymentType = widget.expensesIncome!.paymentType;
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

    final provider = Provider.of<LocaleProvider>(context);
    final locale = provider.locale;

    print(expensesIncomesPaymentType(locale.languageCode).map((e) => null));

    Map<String, List<String>?> expensesMap = {
      language.form_field_expense_input_value: [
        "Trabalhadores",
        "Gasolina para atomizadores",
        "Combustivel para motorizadas",
        "Peças de Atomizador",
        "Material de Protecção e Higiene",
        "Transporte",
        "Alimentação",
        "Hospedagem",
        "Custos do Provedor",
        "Sacos para Castanha",
      ],
      language.form_field_income_input_value: [
        "Limpeza",
        "Poda",
        "Venda de castanha",
      ],
    };

    Map<String, List<String>?> paymentTypesMap = {
      language.form_field_expense_input_value: [
        "Mzn",
      ],
      language.form_field_income_input_value: [
        "Kg",
        "Mzn",
      ],
    };

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
                int? expensesIncomeUid =
                    int.tryParse(currentTime.millisecondsSinceEpoch.toString());

                ExpensesIncome expensesIncome = ExpensesIncome(
                  expensesIncomeUid: expensesIncomeAsParameter()
                      ? widget.expensesIncome!.expensesIncomeUid
                      : expensesIncomeUid!,
                  userUid: user.userUid!,
                  category: data["category"]!,
                  expensesIncomeType: data["expensesIncomeType"]!,
                  price: data["price"] != null
                      ? double.tryParse(data["price"])
                      : 0,
                  paymentType: data["paymentType"]!,
                  description: data["description"]!,
                  createdAt: expensesIncomeAsParameter()
                      ? widget.expensesIncome!.createdAt
                      : currentTime,
                  updatedAt: currentTime,
                  lastSyncAt: expensesIncomeAsParameter()
                      ? widget.expensesIncome!.lastSyncAt
                      : currentTime,
                  syncStatus: expensesIncomeAsParameter()
                      ? widget.expensesIncome!.syncStatus
                      : 0,
                );

                if (expensesIncomeAsParameter()) {
                  ExpensesIncomeModel()
                      .updateExpensesIncome(expensesIncome)
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
                  }).whenComplete(
                    () => null,
                  );
                } else {
                  ExpensesIncomeModel()
                      .insertExpensesIncome(expensesIncome)
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
                      language.finance_expenses_and_incomes,
                      style: const TextStyle(
                        fontSize: 25.0,
                        color: Utils.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Utils.sHeight,
                    Utils.svgHeader("undraw_done_re_oak4.svg"),
                    DropdownWidget(
                      initialValue: expensesIncomeType,
                      validator: (value) => (value == null)
                          ? language.form_field_mandatory_validation_message
                          : null,
                      name: "expensesIncomeType",
                      items: [
                        language.form_field_expense_input_value,
                        language.form_field_income_input_value,
                      ],
                      hintText:
                          language.form_field_transaction_type_placeholder,
                      onChange: (value) {
                        setState(() {
                          expensesIncomeType = value.toString();
                        });
                      },
                    ),
                    Utils.mHeight,
                    DropdownWidget(
                      initialValue: category,
                      validator: (value) => (value == null)
                          ? language.form_field_mandatory_validation_message
                          : null,
                      name: "category",
                      items: expensesMap[expensesIncomeType] ?? [],
                      hintText: language.form_field_category_placeholder,
                      onChange: (value) {
                        (value) {
                          setState(() {
                            category = value.toString();
                            isFree = value == "Free" ? true : false;
                          });
                        };
                      },
                    ),
                    Utils.mHeight,
                    TextFormFieldWidget(
                      validator: (value) => (value == null || value.isEmpty)
                          ? language.form_field_mandatory_validation_message
                          : null,
                      controller: price,
                      keyBoard: TextInputType.number,
                      name: "price",
                      hintText: language.form_field_price_placeholder,
                    ),
                    Utils.mHeight,
                    DropdownWidget(
                      initialValue: paymentType,
                      validator: (value) => (value == null)
                          ? language.form_field_mandatory_validation_message
                          : null,
                      name: "paymentType",
                      items:paymentTypesMap[expensesIncomeType] ?? [],
                      hintText: language.form_field_payment_type_placeholder,
                      onChange: (value) {
                        (value) {
                          setState(() {
                            paymentType = value.toString();
                            isFree = value == "Free" ? true : false;
                          });
                        };
                      },
                    ),
                    Utils.mHeight,
                    TextFormFieldWidget(
                      maxLines: 4,
                      controller: description,
                      name: "description",
                      hintText: language.form_field_description_placeholder,
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
