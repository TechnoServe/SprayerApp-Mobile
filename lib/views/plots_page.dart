// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sprayer_app/entities/farmer.dart';
import 'package:sprayer_app/entities/plot.dart';
import 'package:sprayer_app/helpers/custom_locale.dart';
import 'package:sprayer_app/helpers/utils.dart';
import 'package:sprayer_app/models/plot_model.dart';
import 'package:sprayer_app/providers/farmer_session.dart';
import 'package:sprayer_app/views/save_farmers_page.dart';
import 'package:sprayer_app/views/save_plots_page.dart';
import 'package:sprayer_app/views/widgets/button_widget.dart';
import 'package:sprayer_app/views/widgets/costum_list_title_widget.dart';
import 'package:sprayer_app/views/widgets/custom_chip_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:timeago/timeago.dart' as timeago;

class PlotsPage extends StatefulWidget {
  const PlotsPage({
    Key? key,
  }) : super(key: key);

  @override
  State<PlotsPage> createState() => _PlotsState();
}

class _PlotsState extends State<PlotsPage> {
  StreamController<int> totalReturnedRecords = StreamController();

  @override
  void dispose() {
    totalReturnedRecords.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Farmer farmer = context.watch<FarmerSession>().profile;
    var language = AppLocalizations.of(context)!;

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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SaveFarmersPage(
                      farmer: farmer,
                    ),
                  ),
                ).then((value) {
                  if (value == true) {
                    Utils.snackbar(
                        context, language.general_success_save_form_message);
                    setState(() {});
                  }
                });
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                value: 0,
                child: Text(
                  language.edit_farmers,
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: ButtonWidget(
            title: language.register_plots,
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SavePlotsPage(
                    farmer: farmer,
                  ),
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
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, true);

          return true;
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Center(
              child: Column(
                children: [
                  Utils.showCurrentCampaign(),
                  Text(
                    [farmer.firstName, farmer.lastName].join(" "),
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
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Theme.of(context).primaryColor,
                        ),
                        textAlign: TextAlign.center,
                      );
                    },
                  ),
                  Utils.svgHeader("undraw_environment_iaus.svg"),
                  FutureBuilder<List<Plot>>(
                    future: PlotModel().plots(farmer.farmerUid),
                    initialData: const [],
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        Utils.snackbar(
                          context,
                          language.general_error_occured_save_message(
                              snapshot.error.toString()),
                        );

                        return Container();
                      }

                      if (!snapshot.hasData) {
                        return Utils.progress();
                      }

                      List<Plot>? plots = snapshot.data;
                      int listLength = plots!.length;

                      print(plots);

                      totalReturnedRecords.sink.add(listLength);

                      return ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {},
                            child: CustomListTileWidget(
                              sinchronized: (plots[index].syncStatus == 1)
                                  ? "Última sincronização em ${timeago.format(plots[index].lastSyncAt, locale: 'pt')}"
                                  : "",
                              isEditable: true,
                              onEditPressed: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SavePlotsPage(
                                      farmer: farmer,
                                      plot: plots[index],
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
                              title: plots[index].name,
                              subtitle: plots[index].administrativePost ?? "",
                              child: Row(
                                children: [
                                  CustomChipWidget(
                                    value:
                                        "${Utils.toDecimal(plots[index].numberOfTrees)} ${language.general_tress_entity.toLowerCase()}",
                                  ),
                                  Utils.sWidth,
                                  plots[index].plotType != null ? CustomChipWidget(
                                    value:
                                        "${plots[index].plotType}",
                                  ) : Container(),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (_, __) => Container(),
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
      ),
    );
  }
}
