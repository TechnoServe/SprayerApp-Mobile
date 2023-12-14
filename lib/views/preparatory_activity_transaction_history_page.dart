import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sprayer_app/entities/preparatory_activity.dart';
import 'package:sprayer_app/entities/user.dart';
import 'package:sprayer_app/helpers/utils.dart';
import 'package:sprayer_app/models/preparatory_activity_model.dart';
import 'package:sprayer_app/providers/user_session.dart';

class PreparatoryActivityTransactionHistoryPage extends StatefulWidget {
  const PreparatoryActivityTransactionHistoryPage({Key? key}) : super(key: key);

  @override
  State<PreparatoryActivityTransactionHistoryPage> createState() =>
      _PreparatoryActivityTransactionHistoryPageState();
}

class _PreparatoryActivityTransactionHistoryPageState
    extends State<PreparatoryActivityTransactionHistoryPage> {
  @override
  Widget build(BuildContext context) {
    User user = context.watch<UserSession>().loggedUser!;
    
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: Utils.appBar(context, false),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Column(
              children: [
                const Text(
                  "Transactions history",
                  style: TextStyle(
                    fontSize: 25.0,
                    color: Utils.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Preparatory activity",
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Utils.sHeight,
                FutureBuilder<List<PreparatoryActivity>>(
                  future: PreparatoryActivityModel().preparatoryActivities(user.userUid!),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      Utils.snackbar(
                          context, "Error occured: ${snapshot.error}");

                      return Container();
                    }

                    if (!snapshot.hasData) {
                      return Utils.progress();
                    }

                    List<PreparatoryActivity>? preparatoryActivities = snapshot.data;

                    int listLength = preparatoryActivities!.length;

                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) => ListTile(
                        leading: Icon(
                          FontAwesomeIcons.clockRotateLeft,
                          color: Theme.of(context).primaryColor,
                        ),
                        title: Text(
                          [
                            preparatoryActivities[index].firstName,
                            preparatoryActivities[index].lastName
                          ].join(" "),
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 18.0,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    "${preparatoryActivities[index].numberOfTreesPruned} trees pruned",
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    "${preparatoryActivities[index].numberOfTreesCleaned} trees cleaned",
                                  ),
                                ),
                              ],
                            ),
                            Text(
                                "${preparatoryActivities[index].createdAt}"),
                          ],
                        ),
                        isThreeLine: true,
                      ),
                      itemCount: listLength,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
