// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sprayer_app/entities/farmer.dart';
import 'package:sprayer_app/entities/user.dart';
import 'package:sprayer_app/helpers/custom_locale.dart';
import 'package:sprayer_app/helpers/utils.dart';
import 'package:sprayer_app/models/farmer_model.dart';
import 'package:sprayer_app/providers/farmer_session.dart';
import 'package:sprayer_app/providers/user_session.dart';
import 'package:sprayer_app/views/plots_page.dart';
import 'package:sprayer_app/views/save_farmers_page.dart';
import 'package:sprayer_app/views/search_for_farmer_page.dart';
import 'package:sprayer_app/views/widgets/button_widget.dart';
import 'package:sprayer_app/views/widgets/costum_list_title_widget.dart';
import 'package:sprayer_app/views/widgets/custom_chip_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:timeago/timeago.dart' as timeago;

class FarmersPage extends StatefulWidget {
  const FarmersPage({Key? key}) : super(key: key);

  @override
  State<FarmersPage> createState() => _FarmersPageState();
}

class _FarmersPageState extends State<FarmersPage> {
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

    // Override "en" locale messages with custom messages that are more precise and short
    timeago.setLocaleMessages('pt', MyCustomMessages());

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
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          height: 80.0,
          child: ButtonWidget(
            title: language.register_farmers,
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SaveFarmersPage(),
                ),
              ).then((value) {
                if (value == true) {
                  Utils.snackbar(
                    context,
                    language.general_success_save_form_message,
                  );
                  setState(() {});
                }
              });
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Center(
            child: Column(
              children: [
                Utils.showCurrentCampaign(),
                Text(
                  language.general_farmers_entity,
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
                  future: FarmerModel().farmers(user.userUid!),
                  initialData: const [],
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Utils.progress();
                    }

                    if (snapshot.hasError) {
                      Utils.snackbar(
                          context, "Error occured: ${snapshot.error}");

                      return Container();
                    }

                    List<Farmer>? farmers = snapshot.data;

                    if (isSearch == true) {
                      farmers = farmers!.where((element) {
                        return ((searchMap["firstName"] != null &&
                                element.firstName.toUpperCase().contains(
                                    searchMap["firstName"]
                                        .toString()
                                        .toUpperCase())) ||
                            (searchMap["lastName"] != null &&
                                element.lastName!.toUpperCase().contains(
                                    searchMap["lastName"]
                                        .toString()
                                        .toUpperCase())) ||
                            (searchMap["mobileNumber"] != null &&
                                element.mobileNumber! ==
                                    searchMap["mobileNumber"]) ||
                            (searchMap["administrativePost"] != null &&
                                element.administrativePost!
                                    .toUpperCase()
                                    .contains(searchMap["administrativePost"]
                                        .toString()
                                        .toUpperCase())));
                      }).toList();
                    }

                    int listLength = farmers!.length;

                    totalReturnedRecords.sink.add(listLength);

                    return ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () async {
                            if (farmers?[index].status == -1) {
                              Utils.modal(
                                  context,
                                  "Activar Produtor",
                                  "Deseja activar o produtor ${farmers?[index].firstName} ${farmers?[index].lastName}?",
                                  [
                                    ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Utils.primary),
                                      ),
                                      onPressed: () {
                                        Farmer? farmer2 =
                                            farmers?[index].copyWith(status: 1);

                                        print(farmer2);

                                        if (farmer2 != null) {
                                          FarmerModel()
                                              .updateFarmer(farmer2)
                                              .then((value) {
                                            if (value > 0) {
                                              Provider.of<FarmerSession>(
                                                      context,
                                                      listen: false)
                                                  .update(farmer2);
                                              Navigator.pop(context, true);
                                            } else {
                                              Utils.snackbar(
                                                context,
                                                language
                                                    .general_failed_save_form_message,
                                              );
                                            }
                                          }).catchError((e) {
                                            Utils.snackbar(
                                              context,
                                              language
                                                  .general_error_occured_save_message(
                                                      e.toString()),
                                            );

                                            Navigator.pop(context);
                                          });
                                        }
                                      },
                                      child: Text(
                                        language
                                            .general_modal_exitform_confirmation_yes,
                                        style: const TextStyle(
                                          color: Utils.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                          Utils.danger,
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        language
                                            .general_modal_exitform_confirmation_no,
                                        style: const TextStyle(
                                          color: Utils.white,
                                        ),
                                      ),
                                    ),
                                  ]);
                            } else {
                              Provider.of<FarmerSession>(context, listen: false)
                                  .update(farmers![index]);

                              var response = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PlotsPage(),
                                ),
                              );

                              if (response == true) {
                                setState(() {});
                              }
                            }
                            setState(() {});
                          },
                          onLongPress: () {},
                          child: CustomListTileWidget(
                            backgroundColor: (farmers![index].status == -1)
                                ? Colors.grey
                                : Utils.secondary,
                            sinchronized: (farmers[index].syncStatus == 1)
                                ? "Última sincronização em ${timeago.format(farmers[index].lastSyncAt, locale: 'pt')}"
                                : "",
                            isEditable:
                                farmers[index].status == -1 ? false : true,
                            isDisabled:
                                farmers[index].status == -1 ? false : true,
                            onEditPressed: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SaveFarmersPage(
                                    farmer: farmers![index],
                                  ),
                                ),
                              ).then((value) {
                                if (value == true) {
                                  Utils.snackbar(
                                      context,
                                      language
                                          .general_success_save_form_message);
                                  setState(() {});
                                }
                              });
                            },
                            onDisablePressed: () {
                              Utils.modal(
                                  context,
                                  "Remover Produtor",
                                  "Deseja remover o produtor ${farmers?[index].firstName} ${farmers?[index].lastName}?",
                                  [
                                    ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Utils.primary),
                                      ),
                                      onPressed: () {
                                        Farmer? farmer2 = farmers?[index]
                                            .copyWith(status: -1);

                                        print(farmer2);

                                        if (farmer2 != null) {
                                          FarmerModel()
                                              .updateFarmer(farmer2)
                                              .then((value) {
                                            if (value > 0) {
                                              Provider.of<FarmerSession>(
                                                      context,
                                                      listen: false)
                                                  .update(farmer2);
                                              Navigator.pop(context, true);

                                              setState(() {});
                                            } else {
                                              Utils.snackbar(
                                                context,
                                                language
                                                    .general_failed_save_form_message,
                                              );
                                            }
                                          }).catchError((e) {
                                            Utils.snackbar(
                                              context,
                                              language
                                                  .general_error_occured_save_message(
                                                      e.toString()),
                                            );

                                            Navigator.pop(context);
                                          });
                                        }
                                      },
                                      child: Text(
                                        language
                                            .general_modal_exitform_confirmation_yes,
                                        style: const TextStyle(
                                          color: Utils.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                          Utils.danger,
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        language
                                            .general_modal_exitform_confirmation_no,
                                        style: const TextStyle(
                                          color: Utils.white,
                                        ),
                                      ),
                                    ),
                                  ]);
                            },
                            title: [
                              farmers[index].firstName,
                              farmers[index].lastName
                            ].join(" "),
                            subtitle:
                                (farmers[index].administrativePost != null)
                                    ? farmers[index].administrativePost!
                                    : "",
                            child: Row(
                              children: [
                                CustomChipWidget(
                                  value:
                                      "${farmers[index].numberOfPlots} ${language.general_plots_entity.toLowerCase()}",
                                ),
                                const SizedBox(
                                  width: 3.0,
                                ),
                                CustomChipWidget(
                                  value:
                                      "${Utils.toDecimal(farmers[index].numberOfTrees)} ${language.general_tress_entity.toLowerCase()}",
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
