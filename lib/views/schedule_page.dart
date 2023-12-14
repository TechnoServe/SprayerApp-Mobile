import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sprayer_app/entities/event.dart';
import 'package:sprayer_app/entities/user.dart';
import 'package:sprayer_app/helpers/utils.dart';
import 'package:sprayer_app/models/event_model.dart';
import 'package:sprayer_app/providers/user_session.dart';
import 'package:sprayer_app/views/save_schedule_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final List<Color> _colorCollection = [];

  final DateTime firstDayOfTheWeek =
      Utils.findFirstDateOfTheWeek(DateTime.now());
  final DateTime lastDayOfTheWeek = Utils.findLastDateOfTheWeek(DateTime.now());

  void _initializeEventColor() {
    // ignore: deprecated_member_use
    _colorCollection.add(const Color(0xFF0F8644));
    _colorCollection.add(const Color(0xFF8B1FA9));
    _colorCollection.add(const Color(0xFF01A1EF));
    _colorCollection.add(const Color(0xFF3D4FB5));
    _colorCollection.add(const Color(0xFF636363));
  }

  @override
  void initState() {
    _initializeEventColor();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User user = context.watch<UserSession>().loggedUser!;
    var language = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Utils.primary,
        onPressed: () async {
          dynamic result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SaveSchedulePage(
                user: user,
              ),
            ),
          );

          if (result == true || result == null) {
            setState(() {});
          }
        },
        label: Text(
          language.sidebar_modules_schedule_activity,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      appBar: Utils.appBar(context, false),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Utils.showCurrentCampaign(),
            Text(
              language.sidebar_modules_schedule_activity,
              style: const TextStyle(
                fontSize: 25.0,
                color: Utils.primary,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            FutureBuilder<List<Event>>(
              future: EventModel().events(user.userUid!),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.data!.isEmpty) {
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: Center(
                        child: Text(
                      language.form_field_no_event_activity,
                      style: const TextStyle(
                        fontSize: 20.0,
                      ),
                    )),
                  );
                }

                if (snapshot.data != null) {
                  List<Event> item = snapshot.data ?? [];

                  Random random = Random();

                  return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: item.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 15,
                          ),
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SaveSchedulePage(
                                    user: user,
                                    event: item[index],
                                  ),
                                ),
                              );
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            tileColor: _colorCollection[random.nextInt(4)],
                            textColor: Colors.white,
                            iconColor: Colors.white,
                            leading: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(Icons.calendar_month),
                                Text(
                                  "${DateFormat("MMM, dd").format(item[index].fromDate)} - ${DateFormat("dd").format(item[index].toDate)}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            title: Text(
                              item[index].eventType,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(language
                                .events_number_of_farmers_and_trees_assisted(
                                    "${item[index].numberOfParticipants ?? 0}",
                                    "${item[index].numberOfTress ?? 0}")),
                          ),
                        );
                      });
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
