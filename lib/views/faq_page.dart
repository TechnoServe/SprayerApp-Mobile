import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sprayer_app/database/faq.dart';
import 'package:sprayer_app/entities/faq.dart';
import 'package:sprayer_app/helpers/utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sprayer_app/models/faq_model.dart';

class FAQPage extends StatefulWidget {
  const FAQPage({Key? key}) : super(key: key);

  @override
  FAQPageState createState() => FAQPageState();
}

class FAQPageState extends State<FAQPage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context)!;


    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: Utils.appBar(context, false),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Center(
            child: Column(
              children: [
                Text(
                  language.faq_title,
                  style: const TextStyle(
                    fontSize: 25.0,
                    color: Utils.primary,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                Utils.svgHeader("undraw_receipt_re_fre3.svg"),
                FutureBuilder<List<FAQ>>(
                  future: FAQModel().faqs(),
                  builder: (context, snapshot) {

                    if(snapshot.hasError) print(snapshot.error);

                    if(!snapshot.hasData) return const Center(child: CircularProgressIndicator(),);

                    List<FAQ> faqs = snapshot.data ?? [];

                    return ListView.separated(
                      padding: const EdgeInsets.all(0.0),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        String question = faqs[index].title;
                        String content = faqs[index].description;
                        return ListTile(
                          contentPadding: const EdgeInsets.all(0.0),
                          leading: const Icon(FontAwesomeIcons.circleCheck),
                          trailing: const Icon(
                            FontAwesomeIcons.circleArrowRight,
                            color: Utils.primary,
                          ),
                          title: Text(
                            question,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          onTap: () {
                            showDialog(
                              useSafeArea: true,
                              context: context,
                              builder: (context) {
                                return Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: AlertDialog(
                                    scrollable: true,
                                    title: Text(
                                      question,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    content: Text(content),
                                    actions: [
                                      ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                            Utils.primary,
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          "Fechar",
                                          style: TextStyle(
                                            color: Utils.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                      separatorBuilder: (_, __) => const Divider(),
                      itemCount: faqs.length,
                    );
                  }
                ),
                Utils.xlHeight,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
