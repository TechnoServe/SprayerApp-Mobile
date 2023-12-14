import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sprayer_app/entities/user.dart';
import 'package:sprayer_app/helpers/notification_service.dart';
import 'package:sprayer_app/helpers/utils.dart';
import 'package:sprayer_app/models/event_model.dart';
import 'package:sprayer_app/providers/user_session.dart';
import 'package:sprayer_app/views/campaign_management.dart';
import 'package:sprayer_app/views/save_users.dart';
import 'package:sprayer_app/views/widgets/change_theme_button_widget.dart';
import 'package:sprayer_app/views/widgets/language_picker_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    Key? key,
    required this.user,
  }) : super(key: key);
  final User user;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isNotificationActive = false;
  String currentPeriod = "Diariamente";

  List<String> periodicSchedule = [
    "Em cada minuto",
    "Diariamente",
    "Semanalmente"
  ];

  setIsNotificationActive(value) async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    instance.setBool("isNotificationActive", value);
  }

  getIsNotificationActive() async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    return instance.getBool("isNotificationActive");
  }

  setCurrentPeriod(value) async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    instance.setString("currentPeriod", value);
  }

  getCurrentPeriod() async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    return instance.getString("currentPeriod");
  }

  initValues() async {
    final notificationActivationStatus = await getIsNotificationActive();
    final periodicActivationValue = await getCurrentPeriod();

    setState(() {
      isNotificationActive = notificationActivationStatus;
      currentPeriod = periodicActivationValue;
    });
  }

  showNotificcations() async {
    if (!isNotificationActive) {
      NotificationService.cancelAllNotifications();
    } else {
      RepeatInterval repeatInterval = RepeatInterval.weekly;
      if (currentPeriod == "Em cada minuto") {
        repeatInterval = RepeatInterval.everyMinute;
      } else if (currentPeriod == "Diariamente") {
        repeatInterval = RepeatInterval.daily;
      }

      int numberOfParticipants = await EventModel().getNumberOfParticipants();
      int numberOfTreesToAssist = await EventModel().getNumberOfTreesToAssist();

      NotificationService.showPeriodicNotification(
          id: Random().nextInt(100),
          title: "Agendar actividades",
          body:
              "Tem um total de $numberOfParticipants produtores e $numberOfTreesToAssist arvores a assistir nos proximos 7 dias",
          repeatInterval: repeatInterval);
    }
  }

  @override
  void initState() {
    initValues();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: Utils.appBar(context, false),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Text(
                language!.settings_title,
                style: const TextStyle(
                  fontSize: 25.0,
                  color: Utils.primary,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              Utils.xlHeight,
              ListTile(
                title: Text(
                  language.settings_darkmode_toggle,
                  style: const TextStyle(
                    fontSize: 20.0,
                  ),
                ),
                trailing: const ChangeThemeButtonWidget(),
              ),
              const Divider(),
              ListTile(
                title: Text(
                  language.settings_changelanguage_selection,
                  style: const TextStyle(
                    fontSize: 20.0,
                  ),
                ),
                trailing: const LanguagePickerWidget(),
              ),
              const Divider(),
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SaveUsersPage(
                        user: context.watch<UserSession>().loggedUser!,
                      ),
                    ),
                  );
                },
                title: Text(
                  language.settings_accountdetails_edit,
                  style: const TextStyle(
                    fontSize: 20.0,
                  ),
                ),
                trailing: const Icon(
                  FontAwesomeIcons.penToSquare,
                  color: Utils.primary,
                ),
              ),
              const Divider(),
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CampaignManagment(),
                    ),
                  );
                },
                title: Text(
                  language.settings_campaign_managment,
                  style: const TextStyle(
                    fontSize: 20.0,
                  ),
                ),
                trailing: const Icon(
                  FontAwesomeIcons.angleRight,
                  color: Utils.primary,
                ),
              ),
              const Divider(),
              Utils.mHeight,
              const Text(
                "Configurar notificações",
                style: TextStyle(
                  color: Utils.primary,
                  fontSize: 25.0,
                ),
                textAlign: TextAlign.start,
              ),
              ListTile(
                onTap: () async {},
                title: const Text(
                  "Activar notificação",
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
                trailing: Switch.adaptive(
                  activeColor: Utils.primary,
                  value: isNotificationActive,
                  onChanged: (value) {
                    setState(() {
                      isNotificationActive = !isNotificationActive;
                      setIsNotificationActive(value);

                      showNotificcations();
                    });
                  },
                ),
              ),
              const Divider(),
              ListTile(
                onTap: () async {},
                title: const Text(
                  "Mostar notificação",
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
                trailing: DropdownButton(
                  value: currentPeriod,
                  items: periodicSchedule.map(
                    (element) {
                      return DropdownMenuItem(
                        value: element,
                        onTap: () {
                          setState(() {
                            currentPeriod = element;
                            setCurrentPeriod(element);

                            showNotificcations();
                          });
                        },
                        child: Text(
                          element,
                          style: const TextStyle(
                            fontSize: Utils.smallFs,
                            color: Utils.primary,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      );
                    },
                  ).toList(),
                  onChanged: (_) {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
