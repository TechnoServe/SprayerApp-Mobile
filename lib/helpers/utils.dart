import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:sprayer_app/entities/campaign.dart';
import 'package:sprayer_app/entities/user.dart';
import 'package:sprayer_app/models/campaign_model.dart';
import 'package:sprayer_app/providers/user_cookie.dart';
import 'package:sprayer_app/providers/user_session.dart';
import 'package:sprayer_app/views/home_page.dart';

class Utils {
  //localhost api endpoint
  //use the pc ip so the emulator may access the local machine server
  //static const String api = "http://192.168.43.192/sprayerapplive/api";
  //live api endpoint
  static const String api = "https://sprayerapp.com/api";

  //static const String api = "https://sprayer.agritechmoz.com/api";

  //global variables
  static const String db = "sparyer.db";
  static const int dbVersion = 37;
  static const String defaultAppFolder = "sparyer";
  static const String appVersion = "1.0.22+22";

  //gets the user session from the provider

  //unique int value based on timestamp
  static int uid({dynamic suffix}) => DateTime.now().millisecondsSinceEpoch;

  //to decimal
  static toDecimal(value) {
    final NumberFormat decimal = NumberFormat.decimalPattern();
    return decimal.format(value);
  }

  static bool validatePassword(value) {
    /**
     * r'^
     *    (?=.*[A-Z])       // should contain at least one upper case
     *    (?=.*[a-z])       // should contain at least one lower case
     *   (?=.*?[0-9])      // should contain at least one digit
     *    (?=.*?[!@#\$&*~]) // should contain at least one Special character
     *   .{8,}             // Must be at least 8 characters in length
     *  $
     */
    return RegExp(r'^(?=.*?[A-Z])(?=.*?[0-9]).{8,}$').hasMatch(value);
  }

  static DateTime findFirstDateOfTheWeek(DateTime dateTime) {
    return dateTime.subtract(Duration(days: dateTime.weekday - 1));
  }

  static DateTime findLastDateOfTheWeek(DateTime dateTime) {
    return dateTime
        .add(Duration(days: DateTime.daysPerWeek - dateTime.weekday));
  }

  static navigateToHomePageAfterSigninAndSignup({
    required BuildContext context,
    required User user,
    required String notification,
  }) {
    print("User successfully logged: $user");
    UserCookies().save(user);
    Provider.of<UserSession>(context, listen: false).updateLoggedUser(user);

    Utils.snackbar(
      context,
      notification,
    );

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const Home(),
      ),
      (route) => false,
    );
  }

  //fontsize
  static const double smallFs = 15.0;
  static const double mediumFs = 18.0;
  static const double largeFs = 20.0;
  static const double xlargeFs = 25.0;
  static const double xxlargeFs = 30.0;

  //height variables, used to separate widgets vertically
  //extra large height
  static const SizedBox xlHeight = SizedBox(
    height: 40.0,
  );

  //large height
  static const SizedBox lHeight = SizedBox(
    height: 30.0,
  );

  //medium height
  static const SizedBox mHeight = SizedBox(
    height: 20.0,
  );

  //small height
  static const SizedBox sHeight = SizedBox(
    height: 10.0,
  );

  static const SizedBox xlWidth = SizedBox(
    width: 40.0,
  );

  //large height
  static const SizedBox lWidth = SizedBox(
    width: 30.0,
  );

  //medium height
  static const SizedBox mWidth = SizedBox(
    width: 20.0,
  );

  //small height
  static const SizedBox sWidth = SizedBox(
    width: 10.0,
  );

  //colors for foregrounds and backgrounds
  //primary
  static const Color primary = Color(
    0xFF00C013,
  );

  //secondary
  static const Color secondary = Color(
    0xFFF9F8F8,
  );

  static const Color success = Color(
    0xff3cb521,
  );
  static const Color info = Color(
    0xff3399f3,
  );
  static const Color warning = Color(
    0xffd47500,
  );
  static const Color danger = Color(
    0xffcd0200,
  );
  static const Color light = Color(
    0xffeeeeee,
  );
  static const Color dark = Color(
    0xff333333,
  );
  static const Color white = Colors.white;
  static const Color black = Colors.black;

  static getCampaigns() async {
    await CampaignModel().apiGetFromServerAsFuture();
    List<Campaign> campaigns = await CampaignModel().campaigns();

    if (campaigns.isNotEmpty) {
      campaigns.sort(
        (a, b) =>
            a.closing.millisecondsSinceEpoch - b.closing.millisecondsSinceEpoch,
      );
      Campaign currentCampaign = campaigns.last;
      await CampaignModel().insertCurrentCampaign(currentCampaign);
    }
  }

  static Future<Campaign> getCurrentCampaign() async {
    return await CampaignModel().getCurrentCampaign();
  }

  static Future<String> getCurrentCampaignFilter(
      {required String alias, bool beginsWithAnd = true}) async {
    Campaign currentCampaign = await Utils.getCurrentCampaign();
    String filter = "";

    if (currentCampaign.id > 0) {
      int openingCampaign = currentCampaign.opening.millisecondsSinceEpoch;
      int closingCampaign = currentCampaign.closing.millisecondsSinceEpoch;

      filter =
          "${beginsWithAnd == true ? 'AND' : ''} ${alias.isNotEmpty ? '$alias.' : ''}created_at > $openingCampaign AND ${alias.isNotEmpty ? '$alias.' : ''}created_at < $closingCampaign";
    }

    return filter;
  }

  //circular progress indicator
  static Widget progress({Color? customColor}) => SizedBox(
        height: 50.0,
        width: 50.0,
        child: Center(
          child: CircularProgressIndicator(
            color: customColor ?? Utils.primary,
          ),
        ),
      );

  //progress indicator in modal popup
  static modalProgress(BuildContext context) {
    var language = AppLocalizations.of(context)!;
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            Expanded(
              child: Text(language.general_loading_message),
            ),
            Utils.progress()
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }

  //app bar
  static PreferredSizeWidget? appBar(BuildContext context, closeForm,
      {List<Widget>? actions}) {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).colorScheme.background,
      leading: InkWell(
        child: const Icon(
          FontAwesomeIcons.arrowLeft,
          color: Utils.primary,
        ),
        onTap: () {
          if (closeForm == true) {
            Utils.closeForm(context);
          } else {
            Navigator.pop(context, true);
          }
        },
      ),
      actions: actions,
    );
  }

  //snack bar
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackbar(
          BuildContext context, String content) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          elevation: 11.0,
          content: Text(
            content,
            style: const TextStyle(
              color: Utils.white,
            ),
          ),
          backgroundColor: Utils.primary,
        ),
      );

  //close form
  static closeForm(BuildContext context) {
    var language = AppLocalizations.of(context)!;

    return Utils.modal(
        context,
        language.general_modal_exitform_confirmation_title,
        language.general_modal_exitform_confirmation, [
      ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Utils.primary),
        ),
        onPressed: () {
          Navigator.pop(context);
          Navigator.pop(context);
        },
        child: Text(
          language.general_modal_exitform_confirmation_yes,
          style: const TextStyle(
            color: Utils.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
            Utils.danger,
          ),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text(
          language.general_modal_exitform_confirmation_no,
          style: const TextStyle(
            color: Utils.white,
          ),
        ),
      ),
    ]);
  }

  //snack bar
  static modal(BuildContext context, String title, String content,
          List<Widget>? actions) =>
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: actions,
        ),
        barrierDismissible: false,
      );

  //render svg
  static Widget svgHeader(String svg) => Column(
    children: [
      Utils.mHeight,
      SvgPicture.asset(
        "assets/undraw/$svg",
        semanticsLabel: 'svg header image',
        fit: BoxFit.cover,
        height: 150,
      ),
      Utils.mHeight,
    ],
  );

  static showCurrentCampaign() {
    return FutureBuilder<Campaign>(
      future: Utils.getCurrentCampaign(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data != null) {
            Campaign? currentCampaign = snapshot.data;

            if (currentCampaign != null &&
                currentCampaign.id > 0 &&
                currentCampaign.description != null) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Chip(
                    label: Text(
                      "${currentCampaign.description}",
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Utils.primary,
                  ),
                ],
              );
            } else {
              return Container();
            }
          } else {
            return Container();
          }
        }

        return Container();
      },
    );
  }
}
