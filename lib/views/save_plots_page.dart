// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:sprayer_app/entities/farmer.dart';
import 'package:sprayer_app/entities/plot.dart';
import 'package:sprayer_app/entities/user.dart';
import 'package:sprayer_app/helpers/utils.dart';
import 'package:sprayer_app/models/location_model.dart';
import 'package:sprayer_app/models/plot_model.dart';
import 'package:sprayer_app/providers/user_session.dart';
import 'package:sprayer_app/views/widgets/button_widget.dart';
import 'package:sprayer_app/views/widgets/dropdown_widget.dart';
import 'package:sprayer_app/views/widgets/text_form_field_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SavePlotsPage extends StatefulWidget {
  const SavePlotsPage({
    Key? key,
    required this.farmer,
    this.plot,
  }) : super(key: key);

  final Farmer farmer;
  final Plot? plot;

  @override
  State<SavePlotsPage> createState() => _SavePlotsPageState();
}

class _SavePlotsPageState extends State<SavePlotsPage> {
  final _formKey = GlobalKey<FormBuilderState>();

  //controllers for the input fields
  TextEditingController name = TextEditingController();
  TextEditingController numberOfLargeTrees = TextEditingController();
  TextEditingController numberOfSmallTrees = TextEditingController();
  TextEditingController declaredArea = TextEditingController();
  String? plotType;
  String? plotAge;
  String? otherCrop;
  String? administrativePost;

  //check if the farmer was passed as parameter to the page
  //it means the page was opened in edit mode
  //returns true for edit mode
  plotAsParameter() => widget.plot != null;

//updates the controllers in the input fields when the page is in edit mode
  updateControllers() {
    if (widget.plot != null) {
      name.text = widget.plot!.name;
      numberOfLargeTrees.text = widget.plot!.numberOfTrees.toString();
      numberOfSmallTrees.text = widget.plot!.numberOfSmallTrees != null ? widget.plot!.numberOfSmallTrees .toString() : "0";
      declaredArea.text = widget.plot!.declaredArea != null ? widget.plot!.declaredArea.toString() : "0";
      plotType = widget.plot!.plotType;
      plotAge = widget.plot!.plotAge;
      otherCrop = widget.plot!.otherCrop;
      administrativePost = widget.plot!.administrativePost;
    }
  }

  @override
  void initState() {
    updateControllers();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User user = context.watch<UserSession>().loggedUser!;
    var language = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: Utils.appBar(context, true),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          height: 80.0,
          child: ButtonWidget(
            title: language.form_field_button_save_text,
            onPressed: () async {
              _formKey.currentState!.save();
              if (_formKey.currentState!.validate()) {
                Map<dynamic, dynamic> data = _formKey.currentState!.value;
                DateTime currentTime = DateTime.now();
                int? plotUid = Utils.uid();

                Plot plot = Plot(
                  id: plotAsParameter() ? widget.plot!.id : null,
                  plotUid: plotAsParameter() ? widget.plot!.plotUid : plotUid,
                  farmerUid: widget.farmer.farmerUid,
                  userUid: user.userUid!,
                  name: data["name"],
                  numberOfTrees: int.tryParse(data["numberOfLargeTrees"])!,
                  numberOfSmallTrees: int.tryParse(data["numberOfSmallTrees"])!,
                  plotType: data["plotType"],
                  plotAge: data["plotAge"],
                  otherCrop: data["otherCrop"],
                  declaredArea: data["declaredArea"],
                  province: widget.farmer.province,
                  district: widget.farmer.district,
                  administrativePost: data["administrativePost"],
                  createdAt: currentTime,
                  updatedAt: currentTime,
                  lastSyncAt: currentTime,
                  syncStatus: 0,
                );

                if (plotAsParameter()) {
                  PlotModel().updatePlot(plot).then((value) {
                    print(value);
                    if (value > 0) {
                      Navigator.pop(context, true);
                    } else {
                      Utils.snackbar(
                          context, language.general_failed_save_form_message);
                    }
                  }).catchError((e) {
                    Utils.snackbar(
                      context,
                      language.general_error_occured_save_message(e.toString()),
                    );

                    Navigator.pop(context);
                  });
                } else {
                  PlotModel().insertPlot(plot).then((value) {
                    if (value > 0) {
                      Navigator.pop(context, true);
                    } else {
                      Utils.snackbar(
                          context, language.general_failed_save_form_message);
                    }
                  }).catchError((e) {
                    Utils.snackbar(
                      context,
                      language.general_error_occured_save_message(e.toString()),
                    );

                    Navigator.pop(context);
                  });
                }
              }
            },
          ),
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          Utils.closeForm(context);

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
                      language.save_plots,
                      style: const TextStyle(
                        fontSize: 25.0,
                        color: Utils.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      language.fill_plot_details,
                      style: const TextStyle(
                        fontSize: 15.0,
                        color: Colors.black54,
                      ),
                    ),
                    Utils.xlHeight,
                    TextFormFieldWidget(
                      validator: (value) => (value == null || value.isEmpty)
                          ? language.form_field_mandatory_validation_message
                          : null,
                      name: "name",
                      controller: name,
                      hintText: language.form_field_plotname_placeholder,
                    ),
                    Utils.mHeight,
                    TextFormFieldWidget(
                      keyBoard: TextInputType.number,
                      validator: (value) => (value == null || value.isEmpty)
                          ? language.form_field_mandatory_validation_message
                          : null,
                      name: "numberOfLargeTrees",
                      controller: numberOfLargeTrees,
                      hintText:
                          language.form_field_number_of_large_trees_placeholder,
                    ),
                    Utils.mHeight,
                    TextFormFieldWidget(
                      keyBoard: TextInputType.number,
                      name: "numberOfSmallTrees",
                      controller: numberOfSmallTrees,
                      hintText:
                          language.form_field_number_of_small_trees_placeholder,
                    ),
                    Utils.mHeight,
                    DropdownWidget(
                      validator: (value) => (value == null)
                          ? language.form_field_mandatory_validation_message
                          : null,
                      name: "plotType",
                      initialValue: plotType,
                      items: const ["Plantação nova", "Plantação estabelecida", "Mista"],
                      hintText: language.form_field_plot_type_placeholder,
                      onChange: (value) {
                        setState(() {
                          plotType = value.toString();
                        });
                      },
                    ),
                    Utils.mHeight,
                    DropdownWidget(
                      validator: (value) => (value == null)
                          ? language.form_field_mandatory_validation_message
                          : null,
                      name: "plotAge",
                      initialValue: plotAge,
                      items: const ["0-5 anos", "5-10 anos", "Mais de 10 anos"],
                      hintText: "Idade da Plantação",
                      onChange: (value) {
                        setState(() {
                          plotAge = value.toString();
                        });
                      },
                    ),
                    Utils.mHeight,
                    DropdownWidget(
                      name: "otherCrop",
                      initialValue: otherCrop,
                      items: const [
                        "Tomate",
                        "Cebola",
                        "Batata",
                        "Soja",
                        "Macadamia"
                      ],
                      hintText: language.form_field_other_crop_placeholder,
                      onChange: (value) {
                        setState(() {
                          otherCrop = value.toString();
                        });
                      },
                    ),
                    Utils.mHeight,
                    TextFormFieldWidget(
                      name: "declaredArea",
                      controller: declaredArea,
                      hintText: language.form_field_declared_area_placeholder,
                    ),
                    Utils.mHeight,
                    DropdownWidget(
                      validator: (value) => (value == null)
                          ? language.form_field_mandatory_validation_message
                          : null,
                      name: "administrativePost",
                      initialValue: administrativePost,
                      items: LocationModel.getAdministrativePosts(
                          user.province!, user.district!),
                      hintText:
                          language.form_field_administrativepost_placeholder,
                      onChange: (value) {
                        setState(() {
                          administrativePost = value.toString();
                        });
                      },
                    ),
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
