import 'package:flutter/material.dart';
import 'package:sprayer_app/helpers/utils.dart';
import 'package:sprayer_app/views/application_page.dart';
import 'package:sprayer_app/views/preparatory_activity_page.dart';
import 'widgets/custom_page_builder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChemicalApplicationPage extends StatefulWidget {
  const ChemicalApplicationPage({Key? key}) : super(key: key);

  @override
  State<ChemicalApplicationPage> createState() =>
      _ChemicalApplicationPageState();
}

class _ChemicalApplicationPageState extends State<ChemicalApplicationPage> {
  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: Utils.appBar(context, false),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: CustomPageBuilder(
            title: language.chemical_integrated_managment_title,
            svg: "undraw_chore_list_re_2lq8.svg",
            listTile: [
              {
                "item": language.chemical_integrated_managment_first_application,
                "route": ApplicationPage(
                  title: language.chemical_integrated_managment_first_application,
                  value: 1,
                ),
              },
              {
                "item": language.chemical_integrated_managment_second_application,
                "route": ApplicationPage(
                  title: language.chemical_integrated_managment_second_application,
                  value: 2,
                ),
              },
              {
                "item": language.chemical_integrated_managment_third_application,
                "route": ApplicationPage(
                  title: language.chemical_integrated_managment_third_application,
                  value: 3,
                ),
              },
            ],
          ),
        ),
      ),
    );
  }
}
