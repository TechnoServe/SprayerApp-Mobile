// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:sprayer_app/entities/event.dart';
import 'package:sprayer_app/entities/farmer.dart';
import 'package:sprayer_app/entities/user.dart';
import 'package:sprayer_app/helpers/utils.dart';
import 'package:sprayer_app/models/event_model.dart';
import 'package:sprayer_app/models/farmer_model.dart';
import 'package:sprayer_app/views/widgets/button_widget.dart';
import 'package:sprayer_app/views/widgets/date_form_field.dart';
import 'package:sprayer_app/views/widgets/dropdown_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SaveSchedulePage extends StatefulWidget {
  const SaveSchedulePage({
    Key? key,
    required this.user,
    this.event,
  }) : super(key: key);

  final User user;
  final Event? event;

  @override
  State<SaveSchedulePage> createState() => _SaveSchedulePageState();
}

class _SaveSchedulePageState extends State<SaveSchedulePage> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool isObscureText = true;

  TextEditingController controler = TextEditingController();

//controllers for the input fields
  String activityType = "";
  late DateTime fromDate, toDate;
  late DateTime fromTime, toTime;
  late List<Farmer> farmers;

  getListOfFarmers() async {
    if (widget.event != null) {
      var result = await EventModel().farmers(widget.event!.eventUid);

      setState(() {
        farmers = result;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    farmers = [];
    if (widget.event == null) {
      fromDate = DateTime.now();
      toDate = fromDate.add(const Duration(days: 7));

      fromTime = DateTime(fromDate.hour, fromDate.minute);
      toTime = DateTime(toDate.hour, toDate.minute);
    } else {
      activityType = widget.event!.eventType;
      fromDate = widget.event!.fromDate;
      toDate = widget.event!.toDate;

      getListOfFarmers();
    }
  }

  @override
  Widget build(BuildContext context) {
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

                Event event = Event(
                  eventUid: Utils.uid(),
                  userUid: widget.user.userUid!,
                  name: data["eventType"],
                  eventType: data["eventType"],
                  fromDate: data["fromDate"],
                  toDate: data["toDate"],
                  createdAt: currentTime,
                  updatedAt: currentTime,
                  lastSyncAt: currentTime,
                  syncStatus: 0,
                );

                EventModel eventModel = EventModel();

                if (widget.event != null) {
                  eventModel.updateEvent(event).then((value) {
                    print("Updating");
                    if (value > 0) {
                      for (var element in farmers) {
                        eventModel.insertParticipantEvent({
                          "event_uid": event.eventUid,
                          "farmer_uid": element.farmerUid,
                        });
                      }
                      Navigator.pop(context, true);
                    } else {
                      Utils.snackbar(
                        context,
                        language.general_success_save_form_message,
                      );
                    }
                  }).catchError((e) {
                    Utils.snackbar(
                      context,
                      language.general_error_occured_save_message(e.toString()),
                    );

                    Navigator.pop(context);
                  }).whenComplete(
                    () => null,
                  );
                } else {
                  eventModel.insertEvent(event).then((value) {
                    print("Inserting");
                    if (value > 0) {
                      for (var element in farmers) {
                        eventModel.insertParticipantEvent({
                          "event_uid": event.eventUid,
                          "farmer_uid": element.farmerUid,
                        });
                      }
                      Navigator.pop(context, true);
                    } else {
                      Utils.snackbar(
                        context,
                        language.general_success_save_form_message,
                      );
                    }
                  }).catchError((e) {
                    Utils.snackbar(
                      context,
                      language.general_error_occured_save_message(e.toString()),
                    );

                    Navigator.pop(context);
                  }).whenComplete(
                    () => null,
                  );
                }
              } else {
                Utils.snackbar(
                  context,
                  language.form_field_mandatory_validation_message,
                );
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
          child: Center(
            child: FormBuilder(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Utils.showCurrentCampaign(),
                  Container(
                    padding: const EdgeInsets.only(
                      left: 15.0,
                      right: 15.0,
                      bottom: 15.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            language.form_field_event_activity,
                            style: const TextStyle(
                              fontSize: 25.0,
                              color: Utils.primary,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Utils.mHeight,
                        DropdownWidget(
                          initialValue: activityType,
                          validator: (value) => (value == null || value == "")
                              ? language.form_field_mandatory_validation_message
                              : null,
                          name: "eventType",
                          items: const [
                            "Acordo de Pagamentos",
                            "Poda e Limpeza",
                            "Primeira Aplicação",
                            "Segunda Aplicação",
                            "Terceira Aplicação",
                            "Aquisição de Quimicos",
                            "Manutenção de Atomizadores",
                            "Cobranças",
                            "Treinamentos",
                          ],
                          hintText: language
                              .form_field_event_activity_title_placeholder,
                          onChange: (value) {
                            setState(() {
                              activityType = value.toString();
                            });
                          },
                        ),
                        Utils.mHeight,
                        DateFormFieldWidget(
                          initialValue: fromDate,
                          firstDate: DateTime.now(),
                          validator: (value) => (value == null)
                              ? language.form_field_mandatory_validation_message
                              : null,
                          name: "fromDate",
                          hintText:
                              language.form_field_event_from_date_placeholder,
                          onChanged: (value) {
                            setState(() {
                              fromDate = DateTime.parse(value.toString());
                              toDate = fromDate.add(const Duration(days: 7));
                            });
                          },
                        ),
                        Utils.mHeight,
                        DateFormFieldWidget(
                          initialValue: toDate,
                          validator: (value) => (value == null)
                              ? language.form_field_mandatory_validation_message
                              : null,
                          name: "toDate",
                          hintText:
                              language.form_field_event_end_date_placeholder,
                          onChanged: (value) {
                            setState(() {
                              toDate = DateTime.parse(value.toString());
                            });
                          },
                        ),
                        const Divider(),
                        TextButton.icon(
                          onPressed: () async {
                            dynamic result = await showModalBottomSheet<bool>(
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (context) => buildSheet(
                                widget.user,
                                language,
                              ),
                            );

                            if (result == true || result == null) {
                              setState(() {});
                            }
                          },
                          icon: const Icon(Icons.add),
                          label: Text(
                            language.save_farmers,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Utils.dark,
                            ),
                          ),
                        ),
                        const Divider(),
                        Text(
                          language.events_number_of_selected_farmers(
                              farmers.length.toString()),
                          style: const TextStyle(
                            fontSize: 18.0,
                            color: Utils.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ListView.separated(
                          separatorBuilder: (_, __) => const Divider(),
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) => ListTile(
                            onTap: () {
                              setState(() {});
                            },
                            leading: const Icon(
                              Icons.account_circle_sharp,
                              color: Color(0xFF00C013),
                              size: 40.0,
                            ),
                            subtitle: Text(
                                "${farmers[index].numberOfTrees} ${language.form_field_number_of_large_trees_placeholder}"),
                            title: Text(
                              [
                                farmers[index].firstName,
                                farmers[index].lastName
                              ].join(" "),
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                          itemCount: farmers.length,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget makeDismissable({required Widget child}) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.of(context).pop(true),
        child: GestureDetector(
          onTap: () {},
          child: child,
        ),
      );

  Widget buildSheet(User user, dynamic language) => makeDismissable(
        child: DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 1.0,
          builder: (_, controller) => StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) =>
                ScaffoldMessenger(
              child: Builder(builder: (context) {
                return Scaffold(
                  backgroundColor: Colors.transparent,
                  floatingActionButton: FloatingActionButton(
                    backgroundColor: Utils.primary,
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: const Icon(
                      Icons.check,
                      color: Utils.white,
                    ),
                  ),
                  body: Container(
                    padding: const EdgeInsets.all(15.0),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20.0),
                      ),
                      color: Colors.white,
                    ),
                    child: ListView(
                      controller: controller,
                      children: [
                        Text(
                          language.events_number_of_selected_farmers(
                              farmers.length.toString()),
                          style: const TextStyle(
                            fontSize: 25.0,
                            color: Utils.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Divider(),
                        Utils.sHeight,
                        FutureBuilder<List<Farmer>>(
                          future: FarmerModel().farmers(user.userUid!),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              Utils.snackbar(
                                  context, "Error occured: ${snapshot.error}");

                              return Container();
                            }

                            if (!snapshot.hasData) {
                              return Utils.progress();
                            }

                            List<Farmer> listOfFarmers = snapshot.data!;
                            int listLength = listOfFarmers.length;

                            return ListView.separated(
                              separatorBuilder: (_, __) => const Divider(),
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) => ListTile(
                                onTap: () {
                                  setState(() {
                                    int currentIndex = farmers.indexWhere(
                                        (element) =>
                                            element.farmerUid ==
                                            listOfFarmers[index].farmerUid);

                                    if (currentIndex == -1) {
                                      farmers.add(listOfFarmers[index]);
                                    } else {
                                      farmers.removeAt(currentIndex);
                                    }
                                  });
                                },
                                leading: Icon(
                                  farmers.indexWhere((element) =>
                                              element.farmerUid ==
                                              listOfFarmers[index].farmerUid) >
                                          -1
                                      ? Icons.check_box_rounded
                                      : Icons.account_circle_sharp,
                                  color: const Color(0xFF00C013),
                                  size: 40.0,
                                ),
                                subtitle: Text(
                                    "${listOfFarmers[index].numberOfTrees} Trees"),
                                title: Text(
                                  [
                                    listOfFarmers[index].firstName,
                                    listOfFarmers[index].lastName
                                  ].join(" "),
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ),
                              itemCount: listLength,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      );
}
