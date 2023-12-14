import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:sprayer_app/database/database.dart';
import 'package:sprayer_app/helpers/notification_service.dart';
import 'package:sprayer_app/helpers/utils.dart';
import 'package:sprayer_app/l10n/l10n.dart';
import 'package:sprayer_app/models/profile_model.dart';
import 'package:sprayer_app/providers/farmer_session.dart';
import 'package:sprayer_app/providers/locale_provider.dart';
import 'package:sprayer_app/providers/theme_provider.dart';
import 'package:sprayer_app/providers/user_session.dart';
import 'package:sprayer_app/views/home_page.dart';
import 'package:sprayer_app/views/signin_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  DatabaseBuilder().initializeDatabase();
  NotificationService.initNotification();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserSession(),
        ),
        ChangeNotifierProvider(
          create: (_) => FarmerSession(),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => LocaleProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    Utils.getCampaigns();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'smart sprayer',
      locale: localeProvider.locale,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        AppLocalizations.delegate,
      ],
      supportedLocales: L10n.all,
      themeMode: themeProvider.themeMode,
      theme: MyThemes.lightTheme,
      darkTheme: MyThemes.darkTheme,
      home: StreamBuilder(
        stream: ProfileModel().apiGetFromServer(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == false) {
              print("No data to download");
            }
            if (snapshot.hasError) {
              print(
                  "Profiles downloading. An error ocoured: ${snapshot.error}");
            }
          }

          return Provider.of<UserSession>(context, listen: false).loggedUser ==
                  null
              ? const Signin()
              : const Home();
        },
      ),
    );
  }
}
