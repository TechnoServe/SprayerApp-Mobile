// ignore_for_file: avoid_print

import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sprayer_app/entities/charts/application_series.dart';
import 'package:sprayer_app/entities/user.dart';
import 'package:sprayer_app/helpers/utils.dart';
import 'package:sprayer_app/models/dashboard_model.dart';
import 'package:sprayer_app/models/payment_model.dart';
import 'package:sprayer_app/providers/user_cookie.dart';
import 'package:sprayer_app/providers/user_session.dart';
import 'package:sprayer_app/views/chemical_acquisition_page.dart';
import 'package:sprayer_app/views/equipments_page.dart';
import 'package:sprayer_app/views/faq_page.dart';
import 'package:sprayer_app/views/farmers_page.dart';
import 'package:sprayer_app/views/chemical_application_page.dart';
import 'package:sprayer_app/views/finance_page.dart';
import 'package:sprayer_app/views/schedule_page.dart';
import 'package:sprayer_app/views/settings_page.dart';
import 'package:sprayer_app/views/signin_page.dart';
import 'package:sprayer_app/views/sync_page.dart';
import 'package:sprayer_app/views/widgets/card_kpi_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  Future<List<ApplicationSeries>> getChemicalApplicationData(
      int userUid) async {
    String filter =
        await Utils.getCurrentCampaignFilter(alias: "chemical_application");

    List<Map<String, dynamic>> response = await DashboardModel()
        .totalSprayedTrees("WHERE user_uid = $userUid $filter");

    return List.generate(
        response.length,
        (i) => ApplicationSeries(
            response[i]["application_number"],
            response[i]["number_of_trees_sprayed"] +
                response[i]["number_of_small_trees_sprayed"]));
  }

  @override
  void initState() {
    Utils.getCampaigns();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User user = context.watch<UserSession>().loggedUser!;
    var language = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).colorScheme.background,
        iconTheme: const IconThemeData(
          color: Utils.primary,
          size: 50.0,
        ),
      ),
      drawer: Container(
        color: Utils.primary,
        width: MediaQuery.of(context).size.width * 0.95,
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(
                top: 50.0,
                left: 15.0,
                bottom: 15.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(
                        FontAwesomeIcons.solidCircleUser,
                        size: 50.0,
                        color: Colors.black,
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.mobileNumber!,
                            style: const TextStyle(
                              fontSize: 20.0,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            user.profile ?? "Error loading profile",
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  Utils.mHeight,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () async {
                          var response = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SyncPage(user: user),
                            ),
                          );

                          if (response == true) {
                            print(response);
                            setState(() {});
                          }
                        },
                        icon: const Icon(
                          FontAwesomeIcons.rotate,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      IconButton(
                        onPressed: () async {
                          var response = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SettingsPage(user: user),
                            ),
                          );

                          if (response == true) {
                            setState(() {});
                          }
                        },
                        icon: const Icon(
                          Icons.settings,
                          color: Colors.white,
                          size: 30.0,
                        ),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      IconButton(
                        onPressed: () {
                          UserCookies().remove();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Signin(),
                            ),
                            (route) => false,
                          );
                        },
                        icon: const Icon(
                          Icons.exit_to_app,
                          color: Colors.white,
                          size: 30.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.white,
                radius: 20.0,
                child: Icon(
                  FontAwesomeIcons.calendarDays,
                  color: Utils.primary,
                ),
              ),
              title: Text(
                language!.sidebar_modules_schedule_activity,
                style: const TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
                textScaleFactor: 1.0,
              ),
              trailing: const Icon(
                FontAwesomeIcons.angleRight,
                color: Colors.white,
              ),
              onTap: () async {
                var response = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const SchedulePage(),
                  ),
                );

                if (response == true) {
                  setState(() {});
                }
              },
            ),
            Utils.mHeight,
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.white,
                radius: 20.0,
                child: Icon(
                  FontAwesomeIcons.users,
                  color: Utils.primary,
                ),
              ),
              title: Text(
                language.sidebar_modules_farmersandplots,
                style: const TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
                textScaleFactor: 1.0,
              ),
              trailing: const Icon(
                FontAwesomeIcons.angleRight,
                color: Colors.white,
              ),
              onTap: () async {
                var response = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const FarmersPage(),
                  ),
                );

                if (response == true) {
                  print(response);
                  setState(() {});
                }
              },
            ),
            Utils.mHeight,
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.white,
                radius: 20.0,
                child: Icon(
                  FontAwesomeIcons.battleNet,
                  color: Utils.primary,
                ),
              ),
              title: Text(
                language.sidebar_modules_chemicalacquisition,
                style: const TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
                textScaleFactor: 1.0,
              ),
              trailing: const Icon(
                FontAwesomeIcons.angleRight,
                color: Colors.white,
              ),
              onTap: () async {
                var response = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        const ChemicalAcquisitionPage(),
                  ),
                );

                if (response == true) {
                  setState(() {});
                }
              },
            ),
            Utils.mHeight,
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.white,
                radius: 20.0,
                child: Icon(
                  FontAwesomeIcons.screwdriverWrench,
                  color: Utils.primary,
                ),
              ),
              title: Text(
                language.sidebar_modules_equipments,
                style: const TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
                textScaleFactor: 1.0,
              ),
              trailing: const Icon(
                FontAwesomeIcons.angleRight,
                color: Colors.white,
              ),
              onTap: () async {
                var response = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const EquipmentsPage(),
                  ),
                );

                if (response == true) {
                  setState(() {});
                }
              },
            ),
            Utils.mHeight,
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.white,
                radius: 20.0,
                child: Icon(
                  FontAwesomeIcons.sprayCan,
                  color: Utils.primary,
                ),
              ),
              title: Text(
                language.sidebar_modules_chemicaltreatment,
                style: const TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
                textScaleFactor: 1.0,
              ),
              trailing: const Icon(
                FontAwesomeIcons.angleRight,
                color: Colors.white,
              ),
              onTap: () async {
                var response = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        const ChemicalApplicationPage(),
                  ),
                );

                if (response == true) {
                  setState(() {});
                }
              },
            ),
            Utils.mHeight,
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.white,
                radius: 20.0,
                child: Icon(
                  FontAwesomeIcons.ccMastercard,
                  color: Utils.primary,
                ),
              ),
              title: Text(
                language.sidebar_modules_finance,
                style: const TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
                textScaleFactor: 1.0,
              ),
              trailing: const Icon(
                FontAwesomeIcons.angleRight,
                color: Colors.white,
              ),
              onTap: () async {
                var response = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const Finance(),
                  ),
                );

                if (response == true) {
                  setState(() {});
                }
              },
            ),
            Utils.mHeight,
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.white,
                radius: 20.0,
                child: Icon(
                  FontAwesomeIcons.question,
                  color: Utils.primary,
                ),
              ),
              title: Text(
                language.sidebar_modules_faq,
                style: const TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
                textScaleFactor: 1.0,
              ),
              trailing: const Icon(
                FontAwesomeIcons.angleRight,
                color: Colors.white,
              ),
              onTap: () async {
                var response = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const FAQPage(),
                  ),
                );

                if (response == true) {
                  setState(() {});
                }
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Utils.showCurrentCampaign(),
              Utils.svgHeader("undraw_investment_data_re_sh9x.svg"),
              Utils.sHeight,
              FutureBuilder<List<Map<String, dynamic>>>(
                  future: DashboardModel().dashboard(context, user.userUid!),
                  initialData: const [],
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container(
                        child: Utils.progress(),
                      );
                    }

                    List<Map<String, dynamic>> response = snapshot.data!;
                    Map<String, dynamic> kpis =
                        response.isNotEmpty ? response.first : {};

                    return CarouselSlider.builder(
                      options: CarouselOptions(
                        height: 180,
                        scrollPhysics: const BouncingScrollPhysics(),
                        aspectRatio: 16 / 9,
                        viewportFraction: 0.95,
                        initialPage: 0,
                        enableInfiniteScroll: false,
                        reverse: false,
                        autoPlay: false,
                        autoPlayInterval: const Duration(seconds: 3),
                        autoPlayAnimationDuration:
                            const Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: true,
                        scrollDirection: Axis.horizontal,
                      ),
                      itemCount: kpis.length,
                      itemBuilder: (BuildContext context, int itemIndex,
                              int pageViewIndex) =>
                          CardKpiWidget(
                        title: kpis.keys.elementAt(itemIndex),
                        value:
                            Utils.toDecimal(kpis.values.elementAt(itemIndex)),
                      ),
                    );
                  }),
              Utils.mHeight,
              FutureBuilder<Map<String, dynamic>>(
                future: PaymentModel().dashboard(user.userUid!),
                initialData: const {
                  "dashboardTotalPaid": 0.0,
                  "dashbarrdTotalDebit": 0.0,
                },
                builder: (context, snapshot) {
                  Map<String, dynamic> data = snapshot.data!;

                  return Container(
                    height: 400,
                    width: 500,
                    child: SfCircularChart(
                      legend: Legend(
                          isVisible: true,
                          position: LegendPosition.top,
                          padding: 0),
                      series: <CircularSeries>[
                        PieSeries<ChartData, String>(
                          dataSource: <ChartData>[
                            ChartData('Total Pago', data["dashboardTotalPaid"]),
                            ChartData(
                                'Total divida', data["dashbarrdTotalDebit"]),
                          ],
                          xValueMapper: (ChartData data, _) => data.category,
                          yValueMapper: (ChartData data, _) => data.value,
                          dataLabelSettings: const DataLabelSettings(
                            isVisible: true,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              Utils.mHeight,
              Container(
                padding: const EdgeInsets.all(15.0),
                height: 500,
                child: FutureBuilder<List<ApplicationSeries>>(
                  future: getChemicalApplicationData(user.userUid!),
                  initialData: const [],
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container(
                        child: Utils.progress(),
                      );
                    }

                    List<ApplicationSeries>? series = snapshot.data!;

                    return SfCartesianChart(
                      isTransposed: true,
                      title: ChartTitle(
                        text: language.general_trees_sprayed_per_application,
                      ),
                      primaryXAxis: CategoryAxis(
                        labelRotation: 45,
                      ),
                      primaryYAxis: NumericAxis(
                        edgeLabelPlacement: EdgeLabelPlacement.shift,
                        numberFormat: NumberFormat.decimalPattern(),
                        isVisible: false,
                      ),
                      series: <ChartSeries>[
                        BarSeries<ApplicationSeries, String>(
                          dataLabelSettings: const DataLabelSettings(
                            isVisible: true,
                            textStyle: TextStyle(
                              color: Utils.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(15),
                          ),
                          isTrackVisible: true,
                          trackColor: const Color.fromARGB(58, 0, 0, 0),
                          color: Utils.primary,
                          dataSource: series,
                          xValueMapper: (ApplicationSeries series, _) => (series
                                      .applicationNumber ==
                                  1)
                              ? language
                                  .chemical_integrated_managment_first_application
                              : ((series.applicationNumber == 2)
                                  ? language
                                      .chemical_integrated_managment_second_application
                                  : language
                                      .chemical_integrated_managment_third_application),
                          yValueMapper: (ApplicationSeries series, _) =>
                              series.sprayedTrees,
                        )
                      ],
                    );
                  },
                ),
              ),
              Utils.mHeight,
            ],
          ),
        ),
      ),
    );
  }
}

class CustomListTileDashboard extends StatelessWidget {
  const CustomListTileDashboard({
    Key? key,
    required this.applicationLabel,
    required this.language,
    required this.numberOfTreeSprayed,
  }) : super(key: key);

  final String applicationLabel;
  final AppLocalizations? language;
  final double numberOfTreeSprayed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(10.0),
      tileColor: Utils.secondary,
      leading: const Icon(
        FontAwesomeIcons.sprayCan,
        color: Color(0xFF868080),
      ),
      trailing: const Icon(
        FontAwesomeIcons.chartLine,
        color: Color(0xFF868080),
      ),
      title: Text(
        applicationLabel,
        style: const TextStyle(
          color: Color(0xFF868080),
          fontSize: Utils.xlargeFs,
        ),
      ),
      subtitle: Text(
        language!.general_trees_sprayed_message(
            Utils.toDecimal(numberOfTreeSprayed)),
        style: const TextStyle(
          color: Utils.primary,
          fontSize: Utils.mediumFs,
        ),
      ),
      isThreeLine: true,
    );
  }
}

class ChartData {
  final String category;
  final double value;

  ChartData(this.category, this.value);
}

class CustomListTile extends StatelessWidget {
  final String title;
  final IconData? icon;
  final Widget route;

  const CustomListTile({
    Key? key,
    required this.title,
    this.icon,
    required this.route,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.white,
        radius: 20.0,
        child: icon != null
            ? Icon(
                icon,
                color: Utils.primary,
              )
            : Container(),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 20.0,
          color: Colors.white,
        ),
      ),
      trailing: const Icon(
        FontAwesomeIcons.angleRight,
        color: Colors.white,
      ),
      onTap: () async {
        var response = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => route,
          ),
        );

        print(response);
      },
    );
  }
}
