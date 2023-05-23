import 'dart:async';

import 'package:etno_app/main.dart';
import 'package:etno_app/utils/WarningWidgetValueNotifier.dart';
import 'package:etno_app/widgets/appbar_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/Service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../store/section.dart';

class PageServicesList extends StatefulWidget{
  const PageServicesList({super.key, required this.locality, required this.category});
  final String locality;
  final String category;
  @override
  State<StatefulWidget> createState() {
    return ServicesListState();
  }
}
class ServicesListState extends State<PageServicesList> {
  final Section section = Section();
  PageServicesList get props => super.widget;
  @override
  void initState() {
    section.getAllServiceByLocalityAndCategory(props.locality, props.category);
    super.initState();
  }
  Widget renderWidgets(BuildContext contextState){
    return Observer(builder: (context) {
      if(section.getListServices.isNotEmpty){
        return servicesList(section, contextState);
      } else{
        return Container(
           padding: const EdgeInsets.only(top: 300.0),
            alignment: Alignment.center,
            child: Column(
                children: [
                  Text(AppLocalizations.of(contextState)!.no_service, style: TextStyle(fontWeight: FontWeight.bold)),
                  Icon(Icons.medical_information, size: 50.0)
                ]
            )
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(cardTheme: const CardTheme(color: Colors.white)),
      title: 'Page services',
      home: Scaffold(
          appBar: appBarCustom(context, true , props.category, Icons.language, false, () => null),
          body: SafeArea(
              child: Column(
                  children: [
                    const WarningWidgetValueNotifier(),
                    Container(
                        padding: const EdgeInsets.all(15.0),
                        child:
                       renderWidgets(context)
                    )
                  ]
              )
          )
      ),
    );
  }
}

Widget servicesList(Section section, BuildContext context){
  final Size screenSize = MediaQuery.of(context).size;
  Future<void> launchCaller(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);

  }
  return Container(
    padding: EdgeInsets.only(bottom: 15.0),
    height: screenSize.height,

   // alignment: AlignmentDirectional.center,
    child : ListView(
      padding: EdgeInsets.only(bottom: 180),
      physics: AlwaysScrollableScrollPhysics(),
      children:
      section.getListServices.map((e) => //
          Container(
              alignment: Alignment.topLeft,
              child: Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            renderImageServiceList(e),
                            const SizedBox(width: 8.0),
                            Flexible(
                              child: Text(
                                e.owner!,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),

                      const Divider(),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.topLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(AppLocalizations.of(context)!.type_service, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0)),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(AppLocalizations.of(context)!.service, style: const TextStyle(color: Colors.grey, fontSize: 10.0)),
                                Spacer(),

                                ElevatedButton(
                                    onPressed: (){ launchCaller(e.number!); },
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                    child: Text(AppLocalizations.of(context)!.call),
                                  ),

                              ],
                            ),
                          ],
                        ),
                      ),

                    ],
                  )
              ),
            ),

      ).toList()

  ));
}

Widget renderImageServiceList(Service service){
  if (service.imageUrl == null){
    return Image.asset('assets/service_icon.png', height: 20, width: 20);
  }else{
    return  ClipRRect(borderRadius: BorderRadius.circular(500.0),
        child: Image.network(
          service.imageUrl!,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        )); //Image.network(service.imageUrl!, fit: BoxFit.fill, height: 40, width: 40);
  }
}