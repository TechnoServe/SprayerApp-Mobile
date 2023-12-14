import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sprayer_app/entities/application.dart';
import 'package:sprayer_app/entities/user.dart';
import 'package:sprayer_app/helpers/utils.dart';
import 'package:sprayer_app/models/application_model.dart';
import 'package:sprayer_app/providers/user_session.dart';

class ApplicationTransactionHistoryPage extends StatefulWidget {
  const ApplicationTransactionHistoryPage({
    Key? key,
    required this.farmerUid,
    required this.applicationNumber,
  }) : super(key: key);

  final int farmerUid;
  final int applicationNumber;

  @override
  State<ApplicationTransactionHistoryPage> createState() =>
      _ApplicationTransactionHistoryPageState();
}

class _ApplicationTransactionHistoryPageState
    extends State<ApplicationTransactionHistoryPage> {
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
                  "${(widget.applicationNumber == 1) ? "First" : ((widget.applicationNumber == 2) ? "Second" : "Third")} application",
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Utils.sHeight,
                FutureBuilder<List<Application>>(
                  future: ApplicationModel().applications(user.userUid!),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      Utils.snackbar(
                          context, "Error occured: ${snapshot.error}");

                      return Container();
                    }

                    if (!snapshot.hasData) {
                      return Utils.progress();
                    }

                    List<Application>? applications = snapshot.data!
                        .where((element) => element.applicationNumber == widget.applicationNumber && element.farmerUid == widget.farmerUid)
                        .toList();

                    int listLength = applications.length;

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
                            applications[index].firstName,
                            applications[index].lastName
                          ].join(" "),
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 18.0,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${applications[index].numberOfTreesSprayed} trees sprayed",
                            ),
                            Text("${applications[index].createdAt}"),
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
