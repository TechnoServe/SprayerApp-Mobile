// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sprayer_app/entities/farmer.dart';
import 'package:sprayer_app/entities/user.dart';
import 'package:sprayer_app/helpers/utils.dart';
import 'package:sprayer_app/models/location_model.dart';
import 'package:sprayer_app/providers/user_session.dart';
import 'package:sprayer_app/views/widgets/button_widget.dart';
import 'package:sprayer_app/views/widgets/dropdown_widget.dart';
import 'package:sprayer_app/views/widgets/text_form_field_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchForFarmerPage extends StatefulWidget {
  const SearchForFarmerPage({
    Key? key,
    this.farmer,
  }) : super(key: key);

  final Farmer? farmer;

  @override
  State<SearchForFarmerPage> createState() => _SearchForFarmerPageState();
}

class _SearchForFarmerPageState extends State<SearchForFarmerPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map searchMap = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User user = context.watch<UserSession>().loggedUser!;
    var language = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
        leading: InkWell(
          child: const Icon(
            FontAwesomeIcons.arrowLeft,
            color: Utils.primary,
          ),
          onTap: () async {
            Navigator.pop(
              context,
              searchMap,
            );
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          height: 80.0,
          child: ButtonWidget(
            title: language.general_search,
            onPressed: () async {
              _formKey.currentState!.save();
              setState(() {
                searchMap = _formKey.currentState!.value;
              });

              Navigator.pop(context, searchMap);
            },
          ),
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, searchMap);
          return true;
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: FormBuilder(
                key: _formKey,
                child: Column(
                  children: [
                    Text(
                      language.search_farmers,
                      style: const TextStyle(
                        fontSize: 25.0,
                        color: Utils.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      language.fill_farmer_details,
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    Utils.xlHeight,
                    TextFormFieldWidget(
                      name: "firstName",
                      hintText: language.form_field_firstname_placeholder,
                    ),
                    Utils.mHeight,
                    TextFormFieldWidget(
                      name: "lastName",
                      hintText: language.form_field_lastname_placeholder,
                    ),
                    Utils.mHeight,
                    TextFormFieldWidget(
                      keyBoard: TextInputType.number,
                      name: "mobileNumber",
                      hintText: language.form_field_mobile_number_placeholder,
                    ),
                    Utils.mHeight,
                    DropdownWidget(
                      name: "administrativePost",
                      items: LocationModel.getAdministrativePosts(
                          user.province!, user.district!),
                      hintText: language.form_field_administrativepost_placeholder,
                    ),
                    Utils.xlHeight,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
