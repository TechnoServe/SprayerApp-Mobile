// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:sprayer_app/entities/user.dart';
import 'package:sprayer_app/helpers/utils.dart';
import 'package:sprayer_app/models/application_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sprayer_app/models/campaign_model.dart';
import 'package:sprayer_app/models/chemical_acquisition_model.dart';
import 'package:sprayer_app/models/equipment_model.dart';
import 'package:sprayer_app/models/event_model.dart';
import 'package:sprayer_app/models/expenses_income_model.dart';
import 'package:sprayer_app/models/faq_model.dart';
import 'package:sprayer_app/models/farmer_model.dart';
import 'package:sprayer_app/models/payment_agreement_model.dart';
import 'package:sprayer_app/models/payment_model.dart';
import 'package:sprayer_app/models/plot_model.dart';
import 'package:sprayer_app/models/preparatory_activity_model.dart';
import 'package:sprayer_app/models/user_model.dart';

class SyncPage extends StatefulWidget {
  const SyncPage({
    Key? key,
    required this.user,
  }) : super(key: key);
  final User user;

  @override
  State<SyncPage> createState() => _SyncPageState();
}

class _SyncPageState extends State<SyncPage> {
  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: Utils.appBar(context, false),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Text(
                  "Sincronizar para o servidor",
                  style: TextStyle(
                    fontSize: Utils.mediumFs,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(),
                Row(
                  children: [
                    Text(
                      language.general_farmers_entity,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    StreamBuilder<dynamic>(
                      stream:
                          FarmerModel().apiPostToServer(widget.user.userUid!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.none ||
                            snapshot.connectionState ==
                                ConnectionState.waiting) {
                          return const SizedBox(
                            height: 20.0,
                            width: 20.0,
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.connectionState ==
                                ConnectionState.active ||
                            snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            var response = snapshot.data;

                            if (response["completed"] == true) {}

                            return SizedBox(
                              child: Row(
                                children: [
                                  Text(
                                    response["progress"],
                                    style: const TextStyle(fontSize: 16.0),
                                  ),
                                ],
                              ),
                            );
                          }
                        }

                        return const SizedBox(
                          child: Text(
                            "0 / 0",
                            style: TextStyle(fontSize: 16.0),
                          ),
                        );
                      },
                    )
                  ],
                ),
                const Divider(),
                Row(
                  children: [
                    Text(
                      language.general_plots_entity,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    StreamBuilder<dynamic>(
                      stream: PlotModel().apiPostToServer(widget.user.userUid!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.none ||
                            snapshot.connectionState ==
                                ConnectionState.waiting) {
                          return const SizedBox(
                            height: 20.0,
                            width: 20.0,
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.connectionState ==
                                ConnectionState.active ||
                            snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            var response = snapshot.data;

                            if (response["completed"] == true) {}

                            return SizedBox(
                              child: Row(
                                children: [
                                  Text(
                                    response["progress"],
                                    style: const TextStyle(fontSize: 16.0),
                                  ),
                                ],
                              ),
                            );
                          }
                        }

                        return const SizedBox(
                          child: Text(
                            "0 / 0",
                            style: TextStyle(fontSize: 16.0),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const Divider(),
                Row(
                  children: [
                    Text(
                      language.finance_payment_agreement,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    StreamBuilder<dynamic>(
                      stream: PaymentAggreementModel()
                          .apiPostToServer(widget.user.userUid!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.none ||
                            snapshot.connectionState ==
                                ConnectionState.waiting) {
                          return const SizedBox(
                            height: 20.0,
                            width: 20.0,
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.connectionState ==
                                ConnectionState.active ||
                            snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            var response = snapshot.data;

                            if (response["completed"] == true) {}

                            return SizedBox(
                              child: Row(
                                children: [
                                  Text(
                                    response["progress"],
                                    style: const TextStyle(fontSize: 16.0),
                                  ),
                                ],
                              ),
                            );
                          }
                        }

                        return const SizedBox(
                          child: Text(
                            "0 / 0",
                            style: TextStyle(fontSize: 16.0),
                          ),
                        );
                      },
                    )
                  ],
                ),
                const Divider(),
                Row(
                  children: [
                    Text(
                      language.finance_payments_title,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    StreamBuilder<dynamic>(
                      stream:
                          PaymentModel().apiPostToServer(widget.user.userUid!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.none ||
                            snapshot.connectionState ==
                                ConnectionState.waiting) {
                          return const SizedBox(
                            height: 20.0,
                            width: 20.0,
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.connectionState ==
                                ConnectionState.active ||
                            snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            var response = snapshot.data;

                            if (response["completed"] == true) {}

                            return SizedBox(
                              child: Row(
                                children: [
                                  Text(
                                    response["progress"],
                                    style: const TextStyle(fontSize: 16.0),
                                  ),
                                ],
                              ),
                            );
                          }
                        }

                        return const SizedBox(
                          child: Text(
                            "0 / 0",
                            style: TextStyle(fontSize: 16.0),
                          ),
                        );
                      },
                    )
                  ],
                ),
                const Divider(),
                Row(
                  children: [
                    Text(
                      language.finance_expenses_and_incomes,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    StreamBuilder<dynamic>(
                      stream: ExpensesIncomeModel()
                          .apiPostToServer(widget.user.userUid!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.none ||
                            snapshot.connectionState ==
                                ConnectionState.waiting) {
                          return const SizedBox(
                            height: 20.0,
                            width: 20.0,
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.connectionState ==
                                ConnectionState.active ||
                            snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            var response = snapshot.data;

                            if (response["completed"] == true) {}

                            return SizedBox(
                              child: Row(
                                children: [
                                  Text(
                                    response["progress"],
                                    style: const TextStyle(fontSize: 16.0),
                                  ),
                                ],
                              ),
                            );
                          }
                        }

                        return const SizedBox(
                          child: Text(
                            "0 / 0",
                            style: TextStyle(fontSize: 16.0),
                          ),
                        );
                      },
                    )
                  ],
                ),
                const Divider(),
                Row(
                  children: [
                    Text(
                      language.chemical_acquisition_title,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    StreamBuilder<dynamic>(
                      stream: ChemicalAcquisitionModel()
                          .apiPostToServer(widget.user.userUid!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.none ||
                            snapshot.connectionState ==
                                ConnectionState.waiting) {
                          return const SizedBox(
                            height: 20.0,
                            width: 20.0,
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.connectionState ==
                                ConnectionState.active ||
                            snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            var response = snapshot.data;

                            if (response["completed"] == true) {}

                            return SizedBox(
                              child: Row(
                                children: [
                                  Text(
                                    response["progress"],
                                    style: const TextStyle(fontSize: 16.0),
                                  ),
                                ],
                              ),
                            );
                          }
                        }

                        return const SizedBox(
                          child: Text(
                            "0 / 0",
                            style: TextStyle(fontSize: 16.0),
                          ),
                        );
                      },
                    )
                  ],
                ),
                const Divider(),
                Row(
                  children: [
                    Text(
                      language
                          .chemical_integrated_managment_preparatory_activity,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    StreamBuilder<dynamic>(
                      stream: PreparatoryActivityModel()
                          .apiPostToServer(widget.user.userUid!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.none ||
                            snapshot.connectionState ==
                                ConnectionState.waiting) {
                          return const SizedBox(
                            height: 20.0,
                            width: 20.0,
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.connectionState ==
                                ConnectionState.active ||
                            snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            var response = snapshot.data;

                            if (response["completed"] == true) {}

                            return SizedBox(
                              child: Row(
                                children: [
                                  Text(
                                    response["progress"],
                                    style: const TextStyle(fontSize: 16.0),
                                  ),
                                ],
                              ),
                            );
                          }
                        }

                        return const SizedBox(
                          child: Text(
                            "0 / 0",
                            style: TextStyle(fontSize: 16.0),
                          ),
                        );
                      },
                    )
                  ],
                ),
                const Divider(),
                Row(
                  children: [
                    Text(
                      language.chemical_integrated_managment_title,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    StreamBuilder<dynamic>(
                      stream: ApplicationModel()
                          .apiPostToServer(widget.user.userUid!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.none ||
                            snapshot.connectionState ==
                                ConnectionState.waiting) {
                          return const SizedBox(
                            height: 20.0,
                            width: 20.0,
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.connectionState ==
                                ConnectionState.active ||
                            snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            var response = snapshot.data;

                            if (response["completed"] == true) {}

                            return SizedBox(
                              child: Row(
                                children: [
                                  Text(
                                    response["progress"],
                                    style: const TextStyle(fontSize: 16.0),
                                  ),
                                ],
                              ),
                            );
                          }
                        }

                        return const SizedBox(
                          child: Text(
                            "0 / 0",
                            style: TextStyle(fontSize: 16.0),
                          ),
                        );
                      },
                    )
                  ],
                ),
                const Divider(),
                Row(
                  children: [
                    Text(
                      language.chemical_equipments_title,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    StreamBuilder<dynamic>(
                      stream: EquipmentModel()
                          .apiPostToServer(widget.user.userUid!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.none ||
                            snapshot.connectionState ==
                                ConnectionState.waiting) {
                          return const SizedBox(
                            height: 20.0,
                            width: 20.0,
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.connectionState ==
                                ConnectionState.active ||
                            snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            var response = snapshot.data;

                            if (response["completed"] == true) {}

                            return SizedBox(
                              child: Row(
                                children: [
                                  Text(
                                    response["progress"],
                                    style: const TextStyle(fontSize: 16.0),
                                  ),
                                ],
                              ),
                            );
                          }
                        }

                        return const SizedBox(
                          child: Text(
                            "0 / 0",
                            style: TextStyle(fontSize: 16.0),
                          ),
                        );
                      },
                    )
                  ],
                ),

                const Divider(),
                Row(
                  children: [
                    Text(
                      language.form_field_event_activity,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    StreamBuilder<dynamic>(
                      stream:
                          EventModel().apiPostToServer(widget.user.userUid!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.none ||
                            snapshot.connectionState ==
                                ConnectionState.waiting) {
                          return const SizedBox(
                            height: 20.0,
                            width: 20.0,
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.connectionState ==
                                ConnectionState.active ||
                            snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            var response = snapshot.data;

                            if (response["completed"] == true) {}

                            return SizedBox(
                              child: Row(
                                children: [
                                  Text(
                                    response["progress"],
                                    style: const TextStyle(fontSize: 16.0),
                                  ),
                                ],
                              ),
                            );
                          }
                        }

                        return const SizedBox(
                          child: Text(
                            "0 / 0",
                            style: TextStyle(fontSize: 16.0),
                          ),
                        );
                      },
                    )
                  ],
                ),
                const Divider(),
                Row(
                  children: [
                    const Text(
                      "Utilizadores",
                      style: TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    StreamBuilder<dynamic>(
                      stream: UserModel().apiPostToServer(widget.user.userUid!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.none ||
                            snapshot.connectionState ==
                                ConnectionState.waiting) {
                          return const SizedBox(
                            height: 20.0,
                            width: 20.0,
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.connectionState ==
                                ConnectionState.active ||
                            snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            var response = snapshot.data;

                            if (response["completed"] == true) {}

                            return SizedBox(
                              child: Row(
                                children: [
                                  Text(
                                    response["progress"],
                                    style: const TextStyle(fontSize: 16.0),
                                  ),
                                ],
                              ),
                            );
                          }
                        }

                        return const SizedBox(
                          child: Text(
                            "0 / 0",
                            style: TextStyle(fontSize: 16.0),
                          ),
                        );
                      },
                    )
                  ],
                ),
                //this is for fetching data from server
                Utils.xlHeight,
                Text(
                  "Sincronizar para o telefone",
                  style: TextStyle(
                    fontSize: Utils.mediumFs,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(),
                Row(
                  children: [
                    Text(
                      language.general_farmers_entity,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    StreamBuilder<dynamic>(
                      stream: FarmerModel().apiGetFromServer(widget.user),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.none ||
                            snapshot.connectionState ==
                                ConnectionState.waiting) {
                          return const SizedBox(
                            height: 20.0,
                            width: 20.0,
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.connectionState ==
                                ConnectionState.active ||
                            snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            var response = snapshot.data;

                            if (response["completed"] == true) {}

                            return SizedBox(
                              child: Row(
                                children: [
                                  Text(
                                    response["progress"],
                                    style: const TextStyle(fontSize: 16.0),
                                  ),
                                ],
                              ),
                            );
                          }
                        }

                        return const SizedBox(
                          child: Text(
                            "0 / 0",
                            style: TextStyle(fontSize: 16.0),
                          ),
                        );
                      },
                    )
                  ],
                ),
                const Divider(),
                Row(
                  children: [
                    Text(
                      language.general_plots_entity,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    StreamBuilder<dynamic>(
                      stream: PlotModel().apiGetFromServer(widget.user),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.none ||
                            snapshot.connectionState ==
                                ConnectionState.waiting) {
                          return const SizedBox(
                            height: 20.0,
                            width: 20.0,
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.connectionState ==
                                ConnectionState.active ||
                            snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            var response = snapshot.data;

                            if (response["completed"] == true) {}

                            return SizedBox(
                              child: Row(
                                children: [
                                  Text(
                                    response["progress"],
                                    style: const TextStyle(fontSize: 16.0),
                                  ),
                                ],
                              ),
                            );
                          }
                        }

                        return const SizedBox(
                          child: Text(
                            "0 / 0",
                            style: TextStyle(fontSize: 16.0),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const Divider(),
                Row(
                  children: [
                    Text(
                      language.finance_payment_agreement,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    StreamBuilder<dynamic>(
                      stream: PaymentAggreementModel()
                          .apiGetFromServer(widget.user),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.none ||
                            snapshot.connectionState ==
                                ConnectionState.waiting) {
                          return const SizedBox(
                            height: 20.0,
                            width: 20.0,
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.connectionState ==
                                ConnectionState.active ||
                            snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            var response = snapshot.data;

                            if (response["completed"] == true) {}

                            return SizedBox(
                              child: Row(
                                children: [
                                  Text(
                                    response["progress"],
                                    style: const TextStyle(fontSize: 16.0),
                                  ),
                                ],
                              ),
                            );
                          }
                        }

                        return const SizedBox(
                          child: Text(
                            "0 / 0",
                            style: TextStyle(fontSize: 16.0),
                          ),
                        );
                      },
                    )
                  ],
                ),
                const Divider(),
                Row(
                  children: [
                    Text(
                      language.finance_payments_title,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    StreamBuilder<dynamic>(
                      stream: PaymentModel().apiGetFromServer(widget.user),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.none ||
                            snapshot.connectionState ==
                                ConnectionState.waiting) {
                          return const SizedBox(
                            height: 20.0,
                            width: 20.0,
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.connectionState ==
                                ConnectionState.active ||
                            snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            var response = snapshot.data;

                            if (response["completed"] == true) {}

                            return SizedBox(
                              child: Row(
                                children: [
                                  Text(
                                    response["progress"],
                                    style: const TextStyle(fontSize: 16.0),
                                  ),
                                ],
                              ),
                            );
                          }
                        }

                        return const SizedBox(
                          child: Text(
                            "0 / 0",
                            style: TextStyle(fontSize: 16.0),
                          ),
                        );
                      },
                    )
                  ],
                ),
                const Divider(),
                Row(
                  children: [
                    Text(
                      language.finance_expenses_and_incomes,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    StreamBuilder<dynamic>(
                      stream:
                          ExpensesIncomeModel().apiGetFromServer(widget.user),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.none ||
                            snapshot.connectionState ==
                                ConnectionState.waiting) {
                          return const SizedBox(
                            height: 20.0,
                            width: 20.0,
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.connectionState ==
                                ConnectionState.active ||
                            snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            var response = snapshot.data;

                            if (response["completed"] == true) {}

                            return SizedBox(
                              child: Row(
                                children: [
                                  Text(
                                    response["progress"],
                                    style: const TextStyle(fontSize: 16.0),
                                  ),
                                ],
                              ),
                            );
                          }
                        }

                        return const SizedBox(
                          child: Text(
                            "0 / 0",
                            style: TextStyle(fontSize: 16.0),
                          ),
                        );
                      },
                    )
                  ],
                ),
                const Divider(),
                Row(
                  children: [
                    Text(
                      language.chemical_acquisition_title,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    StreamBuilder<dynamic>(
                      stream: ChemicalAcquisitionModel()
                          .apiGetFromServer(widget.user),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.none ||
                            snapshot.connectionState ==
                                ConnectionState.waiting) {
                          return const SizedBox(
                            height: 20.0,
                            width: 20.0,
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.connectionState ==
                                ConnectionState.active ||
                            snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            var response = snapshot.data;

                            if (response["completed"] == true) {}

                            return SizedBox(
                              child: Row(
                                children: [
                                  Text(
                                    response["progress"],
                                    style: const TextStyle(fontSize: 16.0),
                                  ),
                                ],
                              ),
                            );
                          }
                        }

                        return const SizedBox(
                          child: Text(
                            "0 / 0",
                            style: TextStyle(fontSize: 16.0),
                          ),
                        );
                      },
                    )
                  ],
                ),
                const Divider(),
                Row(
                  children: [
                    Text(
                      language
                          .chemical_integrated_managment_preparatory_activity,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    StreamBuilder<dynamic>(
                      stream: PreparatoryActivityModel()
                          .apiGetFromServer(widget.user),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.none ||
                            snapshot.connectionState ==
                                ConnectionState.waiting) {
                          return const SizedBox(
                            height: 20.0,
                            width: 20.0,
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.connectionState ==
                                ConnectionState.active ||
                            snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            var response = snapshot.data;

                            if (response["completed"] == true) {}

                            return SizedBox(
                              child: Row(
                                children: [
                                  Text(
                                    response["progress"],
                                    style: const TextStyle(fontSize: 16.0),
                                  ),
                                ],
                              ),
                            );
                          }
                        }

                        return const SizedBox(
                          child: Text(
                            "0 / 0",
                            style: TextStyle(fontSize: 16.0),
                          ),
                        );
                      },
                    )
                  ],
                ),
                const Divider(),
                Row(
                  children: [
                    Text(
                      language.chemical_integrated_managment_title,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    StreamBuilder<dynamic>(
                      stream: ApplicationModel().apiGetFromServer(widget.user),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.none ||
                            snapshot.connectionState ==
                                ConnectionState.waiting) {
                          return const SizedBox(
                            height: 20.0,
                            width: 20.0,
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.connectionState ==
                                ConnectionState.active ||
                            snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            var response = snapshot.data;

                            if (response["completed"] == true) {}

                            return SizedBox(
                              child: Row(
                                children: [
                                  Text(
                                    response["progress"],
                                    style: const TextStyle(fontSize: 16.0),
                                  ),
                                ],
                              ),
                            );
                          }
                        }

                        return const SizedBox(
                          child: Text(
                            "0 / 0",
                            style: TextStyle(fontSize: 16.0),
                          ),
                        );
                      },
                    )
                  ],
                ),
                const Divider(),
                Row(
                  children: [
                    Text(
                      language.chemical_equipments_title,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    StreamBuilder<dynamic>(
                      stream: EquipmentModel().apiGetFromServer(widget.user),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.none ||
                            snapshot.connectionState ==
                                ConnectionState.waiting) {
                          return const SizedBox(
                            height: 20.0,
                            width: 20.0,
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.connectionState ==
                                ConnectionState.active ||
                            snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            var response = snapshot.data;

                            if (response["completed"] == true) {}

                            return SizedBox(
                              child: Row(
                                children: [
                                  Text(
                                    response["progress"],
                                    style: const TextStyle(fontSize: 16.0),
                                  ),
                                ],
                              ),
                            );
                          }
                        }

                        return const SizedBox(
                          child: Text(
                            "0 / 0",
                            style: TextStyle(fontSize: 16.0),
                          ),
                        );
                      },
                    )
                  ],
                ),

                const Divider(),
                Row(
                  children: [
                    Text(
                      language.form_field_event_activity,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    StreamBuilder<dynamic>(
                      stream: EventModel().apiGetFromServer(widget.user),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.none ||
                            snapshot.connectionState ==
                                ConnectionState.waiting) {
                          return const SizedBox(
                            height: 20.0,
                            width: 20.0,
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.active ||
                            snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            var response = snapshot.data;

                            if (response["completed"] == true) {}

                            return SizedBox(
                              child: Row(
                                children: [
                                  Text(
                                    response["progress"],
                                    style: const TextStyle(fontSize: 16.0),
                                  ),
                                ],
                              ),
                            );
                          }
                        }

                        return const SizedBox(
                          child: Text(
                            "0 / 0",
                            style: TextStyle(fontSize: 16.0),
                          ),
                        );
                      },
                    )
                  ],
                ),
                const Divider(),
                Row(
                  children: [
                    const Text(
                      "FAQ's",
                      style: TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    StreamBuilder<dynamic>(
                      stream: FAQModel().apiGetFromServer(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.none ||
                            snapshot.connectionState ==
                                ConnectionState.waiting) {
                          return const SizedBox(
                            height: 20.0,
                            width: 20.0,
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.connectionState ==
                                ConnectionState.active ||
                            snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            var response = snapshot.data;

                            if (response["completed"] == true) {}

                            return SizedBox(
                              child: Row(
                                children: [
                                  Text(
                                    response["progress"],
                                    style: const TextStyle(fontSize: 16.0),
                                  ),
                                ],
                              ),
                            );
                          }
                        }

                        return const SizedBox(
                          child: Text(
                            "0 / 0",
                            style: TextStyle(fontSize: 16.0),
                          ),
                        );
                      },
                    )
                  ],
                ),

                const Divider(),
                Row(
                  children: [
                    const Text(
                      "Campaign's",
                      style: TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    StreamBuilder<dynamic>(
                      stream: CampaignModel().apiGetFromServer(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.none ||
                            snapshot.connectionState ==
                                ConnectionState.waiting) {
                          return const SizedBox(
                            height: 20.0,
                            width: 20.0,
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.connectionState ==
                                ConnectionState.active ||
                            snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            var response = snapshot.data;

                            if (response["completed"] == true) {}

                            return SizedBox(
                              child: Row(
                                children: [
                                  Text(
                                    response["progress"],
                                    style: const TextStyle(fontSize: 16.0),
                                  ),
                                ],
                              ),
                            );
                          }
                        }

                        return const SizedBox(
                          child: Text(
                            "0 / 0",
                            style: TextStyle(fontSize: 16.0),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
