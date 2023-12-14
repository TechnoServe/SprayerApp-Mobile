import 'package:flutter/material.dart';
import 'package:sprayer_app/helpers/utils.dart';

class CustomPageBuilder extends StatelessWidget {
  const CustomPageBuilder({
    Key? key,
    required this.title,
    required this.svg,
    required this.listTile,
    this.onTap,
  }) : super(key: key);

  final String title;
  final String svg;
  final List<Map> listTile;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 25.0,
              color: Color(
                0xFF00C013,
              ),
              fontWeight: FontWeight.bold,
            ),
          ),
          Utils.svgHeader(svg),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => listTile[index]['route'],
                    ),
                  );
                },
                child: ListTile(
                  contentPadding: const EdgeInsets.only(
                    left: 15.0,
                  ),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      color: Colors.black12,
                      width: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  tileColor: Utils.secondary,
                  title: Text(
                    listTile[index]['item'],
                    style: const TextStyle(
                      fontSize: 22.0,
                      color: Colors.black54,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  trailing: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                      color: Utils.primary,
                    ),
                    width: 5,
                  ),
                ),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(
              height: 10.0,
            ),
            itemCount: listTile.length,
          ),
          const SizedBox(
            height: 20.0,
          ),
        ],
      ),
    );
  }
}
