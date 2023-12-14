// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sprayer_app/entities/application.dart';
import 'package:sprayer_app/entities/farmer.dart';
import 'package:sprayer_app/entities/user.dart';
import 'package:sprayer_app/helpers/utils.dart';
import 'package:sprayer_app/models/application_model.dart';
import 'package:sprayer_app/providers/user_session.dart';
import 'package:sprayer_app/views/save_application_page.dart';
import 'package:sprayer_app/views/search_for_farmer_page.dart';
import 'package:sprayer_app/views/widgets/costum_list_title_widget.dart';
import 'package:sprayer_app/views/widgets/custom_chip_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class ApplicationPage extends StatefulWidget {
  const ApplicationPage({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);
  final String title;
  final int value;

  @override
  State<ApplicationPage> createState() => _ApplicationPageState();
}

class _ApplicationPageState extends State<ApplicationPage> {
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
                Utils.showCurrentCampaign(),
                Text(
                  widget.title,
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
                FutureBuilder<List<Farmer>>(
                  future: ApplicationModel().farmers(user.userUid!),
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
                        int? treesSprayed = (widget.value == 1)
                            ? farmers![index].treesSprayedInFirstApplication
                            : ((widget.value == 2)
                                ? farmers![index]
                                    .treesSprayedInSecondApplication
                                : farmers![index]
                                    .treesSprayedInThirdApplication);

                        return InkWell(
                          onTap: () async {
                            Future<dynamic> response = Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SaveApplicationPage(
                                  farmer: farmers![index],
                                  title: widget.title,
                                  value: widget.value,
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
                            onEditPressed: () async {
                              dynamic result = await showModalBottomSheet<bool>(
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                context: context,
                                builder: (context) => buildSheet(
                                  widget.value,
                                  farmers![index].farmerUid,
                                  user,
                                  farmers[index],
                                  language,
                                ),
                              );

                              if (result == true || result == null) {
                                setState(() {});
                              }
                            },
                            sinchronized: "",
                            title: [
                              farmers[index].firstName,
                              farmers[index].lastName
                            ].join(" "),
                            subtitle:
                                Utils.toDecimal(farmers[index].numberOfTrees) +
                                    " ${language.general_tress_entity}",
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    CustomChipWidget(
                                      value: language
                                          .general_trees_sprayed_message(
                                              Utils.toDecimal(treesSprayed)),
                                      tileColor: (treesSprayed == 0)
                                          ? Colors.red
                                          : null,
                                    ),
                                  ],
                                ),
                                farmers[index].dateOfSecondApplication !=
                                            null &&
                                        widget.value == 1
                                    ? Row(
                                        children: [
                                          const Icon(Icons.calendar_month),
                                          Utils.sWidth,
                                          Text(
                                            "Second application: ${DateFormat("dd/MM/yyyy").format(farmers[index].dateOfSecondApplication!)}",
                                            style: const TextStyle(
                                                color: Utils.primary),
                                          ),
                                        ],
                                      )
                                    : Container(),
                                farmers[index].dateOfThirdApplication != null &&
                                        widget.value == 2
                                    ? Text(
                                        "Third application ${DateFormat("dd/MM/yyyy").format(farmers[index].dateOfThirdApplication!)}",
                                      )
                                    : Container(),
                                Utils.sHeight,
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

  Widget makeDismissable({required Widget child}) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.of(context).pop(),
        child: GestureDetector(
          onTap: () {},
          child: child,
        ),
      );

  Widget buildSheet(int applicationNumber, int farmerUid, User user,
          Farmer farmer, dynamic language) =>
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
                         language.chemical_integrated_managment_chemical_application_transaction,
                          style: const TextStyle(
                            fontSize: 25.0,
                            color: Utils.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${(applicationNumber == 1) ? language.chemical_integrated_managment_first_application
                              : ((applicationNumber == 2) ? language.chemical_integrated_managment_second_application
                              : language.chemical_integrated_managment_third_application )}",
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 15.0,
                          ),
                        ),
                        const Divider(),
                        Utils.sHeight,
                        FutureBuilder<List<Application>>(
                          future:
                              ApplicationModel().applications(user.userUid!),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              Utils.snackbar(
                                  context, "Error occured: ${snapshot.error}");

                              return Container();
                            }

                            if (!snapshot.hasData) {
                              return Utils.progress();
                            }

                            List<Application>? applications = snapshot.data!
                                .where((element) =>
                                    element.applicationNumber ==
                                        applicationNumber &&
                                    element.farmerUid == farmerUid)
                                .toList();

                            int listLength = applications.length;

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
                                    applications[index].firstName,
                                    applications[index].lastName
                                  ].join(" "),
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 18.0,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${applications[index].numberOfTreesSprayed + applications[index].numberOfSmallTreesSprayed} trees sprayed",
                                      style: const TextStyle(
                                        color: Colors.black38,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                    Text(
                                      DateFormat("dd/MM/yyyy").format(
                                          applications[index].sprayedAt),
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
                                              SaveApplicationPage(
                                            farmer: farmer,
                                            title: widget.title,
                                            value: widget.value,
                                            application: applications[index],
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
