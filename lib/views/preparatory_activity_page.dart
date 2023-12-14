// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sprayer_app/entities/farmer.dart';
import 'package:sprayer_app/entities/preparatory_activity.dart';
import 'package:sprayer_app/entities/user.dart';
import 'package:sprayer_app/helpers/utils.dart';
import 'package:sprayer_app/models/preparatory_activity_model.dart';
import 'package:sprayer_app/providers/user_session.dart';
import 'package:sprayer_app/views/save_preparatory_activity_page.dart';
import 'package:sprayer_app/views/search_for_farmer_page.dart';
import 'package:sprayer_app/views/widgets/costum_list_title_widget.dart';
import 'package:sprayer_app/views/widgets/custom_chip_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PreparatoryActivityPage extends StatefulWidget {
  const PreparatoryActivityPage({Key? key}) : super(key: key);

  @override
  State<PreparatoryActivityPage> createState() =>
      _PreparatoryActivityPageState();
}

class _PreparatoryActivityPageState extends State<PreparatoryActivityPage> {
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
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Center(
            child: Column(
              children: [
                Text(
                  language.chemical_integrated_managment_preparatory_activity,
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
                      textAlign: TextAlign.center,
                    );
                  },
                ),
                Utils.svgHeader("undraw_receipt_re_fre3.svg"),
                FutureBuilder<List<Farmer>>(
                  future: PreparatoryActivityModel().farmers(user.userUid!),
                  initialData: const [],
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Utils.progress();
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
                        return InkWell(
                          onTap: () async {
                            Future<dynamic> response = Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SavePreparatoryActivityPage(
                                  farmer: farmers![index],
                                ),
                              ),
                            );

                            response.then((value) {
                              if (value == true) {
                                Utils.snackbar(
                                  context,
                                  language.general_success_save_form_message,
                                );
                                setState(() {});
                              }
                            });
                          },
                          child: CustomListTileWidget(
                            isEditable: true,
                            onEditPressed: () {
                              showModalBottomSheet(
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  builder: (context) => buildSheet(
                                      farmers![index].farmerUid,
                                      user,
                                      farmers[index],
                                      language));
                            },
                            sinchronized: "",
                            title: [
                              farmers![index].firstName,
                              farmers[index].lastName
                            ].join(" "),
                            subtitle:
                                language.general_total_registered_trees_message(
                                    Utils.toDecimal(
                                        farmers[index].numberOfTrees)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: CustomChipWidget(
                                    value:
                                        language.general_trees_cleaned_message(
                                            Utils.toDecimal(
                                                farmers[index].treesCleaned)),
                                    tileColor: farmers[index].treesCleaned == 0
                                        ? Colors.red
                                        : null,
                                  ),
                                ),
                                const SizedBox(
                                  width: 5.0,
                                ),
                                Expanded(
                                  child: CustomChipWidget(
                                    value:
                                        language.general_trees_pruned_message(
                                            Utils.toDecimal(
                                                farmers[index].treesPruned)),
                                    tileColor: farmers[index].treesPruned == 0
                                        ? Colors.red
                                        : null,
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget makeDismissable({required Widget child}) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.of(context).pop(),
        child: GestureDetector(
          onTap: () {},
          child: child,
        ),
      );

  Widget buildSheet(
          int farmerUid, User user, Farmer farmer, dynamic language) =>
      makeDismissable(
        child: DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 1.0,
          builder: (_, controller) => StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) =>
                ScaffoldMessenger(
              child: Builder(builder: (context) {
                return Scaffold(
                  backgroundColor: Colors.transparent,
                  body: Container(
                    padding: const EdgeInsets.all(15.0),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20.0),
                      ),
                      color: Colors.white,
                    ),
                    child: ListView(
                      controller: controller,
                      children: [
                        Text(
                          language.chemical_integrated_managment_preparatory_activity_history,
                          style: const TextStyle(
                            fontSize: 25.0,
                            color: Utils.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          language.chemical_integrated_managment_preparatory_activity,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 15.0,
                          ),
                        ),
                        const Divider(),
                        Utils.sHeight,
                        FutureBuilder<List<PreparatoryActivity>>(
                          future: PreparatoryActivityModel()
                              .preparatoryActivities(user.userUid!),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              Utils.snackbar(
                                  context, "Error occured: ${snapshot.error}");

                              return Container();
                            }

                            if (!snapshot.hasData) {
                              return Utils.progress();
                            }

                            List<PreparatoryActivity>? preparatoryActivities =
                                snapshot.data;

                            int listLength = preparatoryActivities!.length;

                            return ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) => ListTile(
                                leading: const Icon(
                                  FontAwesomeIcons.clockRotateLeft,
                                  color: Color(0xFF00C013),
                                ),
                                title: Text(
                                  [
                                    preparatoryActivities[index].firstName,
                                    preparatoryActivities[index].lastName
                                  ].join(" "),
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 18.0,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "${preparatoryActivities[index].numberOfTreesPruned} trees pruned",
                                            style: const TextStyle(
                                              color: Colors.black38,
                                              fontSize: 14.0,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            "${preparatoryActivities[index].numberOfTreesCleaned} trees cleaned",
                                            style: const TextStyle(
                                              color: Colors.black38,
                                              fontSize: 14.0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      DateFormat("dd/MM/yyyy").format(
                                          preparatoryActivities[index]
                                              .createdAt),
                                      style: const TextStyle(
                                        color: Colors.black38,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Container(
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
                                      Future<dynamic> response = Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              SavePreparatoryActivityPage(
                                            farmer: farmer,
                                            preparatoryActivity:
                                                preparatoryActivities[index],
                                          ),
                                        ),
                                      );

                                      response.then((value) {
                                        if (value == true) {
                                          Utils.snackbar(
                                            context,
                                            language
                                                .general_success_save_form_message,
                                          );
                                          setState(() {});
                                        }
                                      });
                                    },
                                  ),
                                ),
                                isThreeLine: true,
                              ),
                              itemCount: listLength,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      );
}
