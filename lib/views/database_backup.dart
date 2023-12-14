import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sprayer_app/helpers/utils.dart';

class DatabaseBackup extends StatefulWidget {
  const DatabaseBackup({Key? key}) : super(key: key);

  @override
  State<DatabaseBackup> createState() => _DatabaseBackupState();
}

class _DatabaseBackupState extends State<DatabaseBackup> {
  bool productionMode = true, enableApiEndpointAndBackupFolder = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: Utils.appBar(
        context,
        false,
        actions: <Widget>[
          PopupMenuButton<int>(
            icon: const Icon(
              FontAwesomeIcons.ellipsisVertical,
              color: Utils.primary,
            ),
            onSelected: (item) {
              if (item == 0) {
                
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<int>(
                value: 0,
                child: Text(
                  'Backup history',
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Center(
            child: Column(
              children: [
                const Text(
                  "Database Backup",
                  style: TextStyle(
                    fontSize: 25.0,
                    color: Utils.primary,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                Utils.xlHeight,
                FormBuilder(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        onTap: () {
                          Utils.modalProgress(context);
                        },
                        title: const Text(
                          "Sever backup",
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                        trailing: const Icon(
                          FontAwesomeIcons.angleRight,
                          color: Utils.primary,
                        ),
                      ),
                      const Divider(),
                      ListTile(
                        onTap: () {
                          Utils.modalProgress(context);
                        },
                        title: const Text(
                          "Local backup",
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                        trailing: const Icon(
                          FontAwesomeIcons.angleRight,
                          color: Utils.primary,
                        ),
                      ),
                      const Divider(),
                      ListTile(
                        onTap: () {
                          Utils.modalProgress(context);
                        },
                        title: const Text(
                          "Restore database",
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                        trailing: const Icon(
                          FontAwesomeIcons.angleRight,
                          color: Utils.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
