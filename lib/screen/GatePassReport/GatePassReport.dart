import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/GatePass/GatePassModel.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GatePassReport extends StatefulWidget {
  GatePassReport({Key? key, this.dateFilter}) : super(key: key);
  String? dateFilter;
  @override
  State<GatePassReport> createState() => _GatePassReportState();
}

class _GatePassReportState extends State<GatePassReport> {
  final ScrollController _scrollController = ScrollController();
  List<DocumentSnapshot> _documents = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _limit = 10;
  final int _limitIncrement = 25;
  var ctrlSearch = TextEditingController();
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _fetchData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !_isLoading && _hasMore) {
      _fetchData();
    }
  }

  Future<void> _fetchData() async {
    print("---date_${widget.dateFilter}");
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      var orderBy = fireBCollection
          .collection("supuser")
          .doc(GLB_CURRENT_USER["CLIENTNO"])
          .collection("GATEPASS_REPORT")
          .where("gpdate", isGreaterThanOrEqualTo: Myf.dateFormateYYYYMMDD(widget.dateFilter, formate: "yyyy-MM-dd 00:00:00"))
          .where("gpdate", isLessThanOrEqualTo: Myf.dateFormateYYYYMMDD(widget.dateFilter, formate: "yyyy-MM-dd 23:59:59"));
      if (ctrlSearch.text.isNotEmpty) {
        orderBy = orderBy.where("VNO", isEqualTo: ctrlSearch.text);
      }
      Query query = orderBy.orderBy("gpdate", descending: true).limit(_limit);

      if (_documents.isNotEmpty) {
        query = query.startAfterDocument(_documents.last);
      }

      QuerySnapshot querySnapshot = await query.get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          _documents.addAll(querySnapshot.docs);
          if (querySnapshot.docs.length < _limit) {
            _hasMore = false;
          }
        });
      } else {
        setState(() {
          _hasMore = false;
        });
      }
    } catch (e) {
      print("Error fetching data: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Gate Pass Report"),
      //   backgroundColor: jsmColor,
      // ),
      body: Column(
        children: [
          Text(
            "Gate Pass Report for ${Myf.dateFormateInDDMMYYYY(widget.dateFilter)}",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(30),
              child: TextField(
                controller: ctrlSearch,
                decoration: InputDecoration(
                  hintText: "Search by Bill No.",
                  prefixIcon: Icon(FontAwesomeIcons.truck, color: Colors.grey[700]),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.clear, color: Colors.grey[700]),
                        onPressed: () {
                          setState(() {
                            ctrlSearch.clear();
                            // Optionally, trigger search reset here
                          });
                        },
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            _documents = [];
                          });
                          _fetchData();
                        },
                        icon: const Icon(Icons.search, color: Colors.white),
                        label: const Text(
                          "Search",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                          elevation: 3,
                        ),
                      )
                    ],
                  ),
                ),
                onChanged: (value) {
                  // Optionally, implement live search/filter here
                },
              ),
            ),
          ),
          Expanded(
            child: _documents.isEmpty && !_isLoading
                ? Center(child: Text("No data available on ${Myf.dateFormateInDDMMYYYY(widget.dateFilter)}"))
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: _documents.length + (_hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _documents.length) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      dynamic data = _documents[index].data();
                      GatePassModel gatePassModel = GatePassModel.fromJson(Myf.convertMapKeysToString(data));

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: ListTile(
                          title: Text("Bill No: ${gatePassModel.billNo}"),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Date: ${Myf.dateFormateYYYYMMDD(gatePassModel.dATE, formate: "dd-MM-yyyy")}"),
                              Text("Party: ${gatePassModel.party}"),
                              Text("City: ${gatePassModel.city}"),
                              Text("GP Date: ${Myf.dateFormateYYYYMMDD(gatePassModel.gpdate, formate: "dd-MM-yyyy HH:mm:ss")}"),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          if (_isLoading && _documents.isNotEmpty)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
