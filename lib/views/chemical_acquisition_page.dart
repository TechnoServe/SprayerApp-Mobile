import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sprayer_app/entities/chemical_acquisition.dart';
import 'package:sprayer_app/entities/user.dart';
import 'package:sprayer_app/helpers/utils.dart';
import 'package:sprayer_app/models/chemical_acquisition_model.dart';
import 'package:sprayer_app/providers/user_session.dart';
import 'package:sprayer_app/views/save_chemical_acquisition_page.dart';
import 'package:sprayer_app/views/widgets/button_widget.dart';
import 'package:sprayer_app/views/widgets/custom_chip_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChemicalAcquisitionPage extends StatefulWidget {
  const ChemicalAcquisitionPage({Key? key}) : super(key: key);

  @override
  State<ChemicalAcquisitionPage> createState() =>
      _ChemicalAcquisitionPageState();
}

class _ChemicalAcquisitionPageState extends State<ChemicalAcquisitionPage> {
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
                  builder: (context) => const SaveChemicalAcquisitionPage(),
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
                  language.chemical_acquisition_title,
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
                      style: const TextStyle(
                        fontSize: 15.0,
                        color: Colors.black54,
                      ),
                    );
                  },
                ),
                Utils.svgHeader("undraw_receipt_re_fre3.svg"),
                FutureBuilder<List<ChemicalAcquisition>>(
                  future: ChemicalAcquisitionModel()
                      .chemicalAcquisitions(user.userUid!),
                  initialData: const [],
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Utils.progress();
                    }

                    if (snapshot.hasError) {
                      return Container();
                    }

                    List<ChemicalAcquisition>? chemicalAcquisitions =
                        snapshot.data;
                    int listLength = chemicalAcquisitions!.length;

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
                                builder: (context) =>
                                    SaveChemicalAcquisitionPage(
                                  chemicalAcquisition:
                                      chemicalAcquisitions[index],
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
                                      chemicalAcquisitions[index].name,
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
                                          chemicalAcquisitions[index].supplier!,
                                          style: const TextStyle(
                                            color: Utils.warning,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            if (chemicalAcquisitions[index]
                                                    .acquisitionMode ==
                                                language
                                                    .form_field_buy_input_value)
                                              Row(
                                                children: [
                                                  CustomChipWidget(
                                                    value: "${language.form_field_price_placeholder}: Mzn " +
                                                        Utils.toDecimal(
                                                            chemicalAcquisitions[
                                                                    index]
                                                                .price),
                                                  ),
                                                  const SizedBox(
                                                    width: 5.0,
                                                  ),
                                                ],
                                              )
                                            else
                                              Container(),
                                            CustomChipWidget(
                                              value:
                                                  "${language.form_field_quantity_placeholder}: " +
                                                      Utils.toDecimal(
                                                        chemicalAcquisitions[
                                                                index]
                                                            .quantity,
                                                      ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    trailing: Container(
                                      margin: const EdgeInsets.only(
                                        right: 10.0,
                                      ),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF00C013),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(500),
                                        ),
                                      ),
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Utils.secondary,
                                        ),
                                        onPressed: () async {
                                          var response = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SaveChemicalAcquisitionPage(
                                                chemicalAcquisition:
                                                    chemicalAcquisitions[index],
                                              ),
                                            ),
                                          );

                                          if (response == true) {
                                            Utils.snackbar(
                                              context,
                                              language
                                                  .general_success_save_form_message,
                                            );
                                            setState(() {});
                                          }
                                        },
                                      ),
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
