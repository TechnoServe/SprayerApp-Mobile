import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sprayer_app/entities/campaign.dart';
import 'package:sprayer_app/helpers/utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sprayer_app/models/campaign_model.dart';
import 'package:sprayer_app/views/widgets/button_widget.dart';
import 'package:sprayer_app/views/widgets/dropdown_widget.dart';

class CampaignManagment extends StatefulWidget {
  const CampaignManagment({
    Key? key,
  }) : super(key: key);

  @override
  State<CampaignManagment> createState() => _CampaignManagmentState();
}

class _CampaignManagmentState extends State<CampaignManagment> {
  Campaign campaign = Campaign.init();
  String selectedCampaign = "";

  getSelectedCampaign() async {
    Campaign campaign = await Utils.getCurrentCampaign();

    setState(() {
      if (campaign != null && campaign.id > 0 && campaign.description != null) {
        selectedCampaign = campaign.description ?? "";
      }
    });
  }

  @override
  void initState() {
    getSelectedCampaign();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: Utils.appBar(context, false),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          height: 80.0,
          child: ButtonWidget(
            title: language!.form_field_button_save_text,
            onPressed: () async {
              print(campaign);
              await CampaignModel()
                  .insertCurrentCampaign(campaign)
                  .then((result) {
                if (result > 0) {
                  Utils.snackbar(
                    context,
                    language.general_success_save_form_message,
                  );
                } else {
                  Utils.snackbar(
                    context,
                    language.general_error_occured_save_message(""),
                  );
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
                Text(
                  language.settings_campaign_managment,
                  style: const TextStyle(
                    fontSize: 25.0,
                    color: Utils.primary,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                Utils.xlHeight,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Utils.sHeight,
                    Utils.svgHeader("undraw_done_re_oak4.svg"),
                    FutureBuilder<List<Campaign>>(
                        initialData: [],
                        future: CampaignModel().campaigns(),
                        builder: (context, snapshot) {
                          List<Campaign> items = [];

                          if (!snapshot.hasData) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          items = snapshot.data!;

                          return FormBuilder(
                            child: DropdownWidget(
                              initialValue: selectedCampaign,
                              validator: (value) => (value == null)
                                  ? language
                                      .form_field_mandatory_validation_message
                                  : null,
                              name: "selectCampaign",
                              items: items
                                  .where((e) =>
                                      e.description != null &&
                                      e.description!.trim().isNotEmpty)
                                  .map((e) => e.description)
                                  .toList(),
                              hintText: "Seleccionar campanha",
                              onChange: (value) {
                                selectedCampaign = value.toString();
                                campaign = items
                                    .where((e) =>
                                        e.description == value.toString())
                                    .first;
                              },
                            ),
                          );
                        }),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
