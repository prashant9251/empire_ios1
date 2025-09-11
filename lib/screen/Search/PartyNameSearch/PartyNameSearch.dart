import 'package:empire_ios/Models/MasterModel.dart';
import 'package:empire_ios/functions/syncLocalFunction.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PartyNameSearch extends StatefulWidget {
  String atype;
  PartyNameSearch({Key? key, required this.atype}) : super(key: key);

  @override
  State<PartyNameSearch> createState() => _PartyNameSearchState();
}

class _PartyNameSearchState extends State<PartyNameSearch> {
  late LazyBox MST;
  List<MasterModel> partyList = [];
  List<MasterModel> filteredPartyList = [];

  initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return SearchAnchor.bar(
      barHintText: "Search Party Name",
      isFullScreen: false,
      barLeading: const Icon(Icons.person),
      contextMenuBuilder: (context, editableTextState) {
        return const Text("ok");
      },
      suggestionsBuilder: (context, controller) {
// MST = Hive.lazyBox("MST");
        filteredPartyList = partyList
            .where(
              (party) => (party.partyname.toString().toLowerCase().contains(
                        controller.text.toLowerCase(),
                      ) &&
                  party.aTYPE == widget.atype),
            )
            .toList();
        return [
          filteredPartyList.isNotEmpty
              ? SizedBox(
                  height: ScreenHeight(context) * .7,
                  child: ListView.separated(
                    separatorBuilder: (context, index) => const Divider(
                      color: Colors.black,
                      height: 1,
                    ),
                    padding: const EdgeInsets.all(8),
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    primary: false,
                    itemCount: filteredPartyList.length,
                    itemBuilder: (context, index) {
                      var address = filteredPartyList[index].aD1.toString() +
                          filteredPartyList[index].aD2.toString() +
                          filteredPartyList[index].aD3.toString() +
                          filteredPartyList[index].aD4.toString();
                      return ListTile(
                        title: Text(filteredPartyList[index].partyname.toString()),
                        subtitle: Text(
                          address,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        trailing: Text(
                          filteredPartyList[index].aTYPE.toString(),
                          style: const TextStyle(color: Colors.black),
                        ),
                        onTap: () {
                          controller.text = filteredPartyList[index].partyname.toString();
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                )
              : const Center(child: Text("No Data Found"))
        ];
      },
    );
  }

  void getData() async {
    partyList.clear();
    MST = await SyncLocalFunction.openLazyBoxCheckByYearWise("MST");
    for (var i = 0; i < MST.length; i++) {
      var key = MST.keyAt(i);
      dynamic value = await MST.get(key);
      if (value != null && value is Map) {
        partyList.add(MasterModel.fromJson(Myf.convertMapKeysToString(value)));
      }
    }
  }
}
