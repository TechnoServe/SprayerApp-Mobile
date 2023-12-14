import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sprayer_app/entities/event.dart';
import 'package:sprayer_app/entities/user.dart';
import 'package:sprayer_app/helpers/utils.dart';
import 'package:sprayer_app/providers/user_session.dart';
import 'package:sprayer_app/views/save_schedule_page.dart';

class ScheduleDetailsPage extends StatefulWidget {
  const ScheduleDetailsPage({
    Key? key,
    required this.event,
  }) : super(key: key);

  final Event event;

  @override
  State<ScheduleDetailsPage> createState() => _ScheduleDetailsPageState();
}

class _ScheduleDetailsPageState extends State<ScheduleDetailsPage> {
  @override
  Widget build(BuildContext context) {
    User user = context.watch<UserSession>().loggedUser!;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Utils.primary,
        onPressed: () async {
          dynamic result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SaveSchedulePage(
                user: user,
                event: widget.event,
              ),
            ),
          );

          if (result == true) {
            setState(() {});
          }
        },
        child: const Icon(
          Icons.edit,
          color: Utils.white,
        ),
      ),
      appBar: Utils.appBar(context, false),
      body: Container(),
    );
  }
}
