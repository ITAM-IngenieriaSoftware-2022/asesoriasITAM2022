import 'package:asesoriasitam/db/pagination_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:asesoriasitam/db/clases/interface_card_tile.dart';
import 'package:flutter/material.dart';

enum ResultDisplayType { card, tile, incompleteTile }

class GeneralPaginatedListView extends StatefulWidget {
  ///Firebase query to get paginated results from
  final Query query;

  ///The object de querySnapshot should be converted to.
  ///Must implement IncluyeCardTile interface.
  final IncluyeCardTile resultObject;

  ///The type of card/tile to display de results in.
  ///They include card and tile.
  final ResultDisplayType displayType;

  ///Message displayed when no data
  final String noDataMessage;

  ///Pagination: number of first hits
  final int first;

  ///Pagination: number of next hits
  final int next;

  ///ListView scroll Direction. Vertical by default.
  final Axis scrollDirection;

  ///If scrollDirection horizontal, the height of the
  ///listview's container parent.
  final double? listViewHeight;

  ///Optional list of widgets to display in listview
  ///before showing results.
  final List<Widget>? before;

  ///Optional list of widgets to display in listview
  ///before showing results.
  final List<Widget>? after;

  ///Wether the listview has any results
  bool hasData = true;

  GeneralPaginatedListView({
    Key? key,
    required this.query,
    required this.resultObject,
    required this.displayType,
    required this.noDataMessage,
    this.scrollDirection = Axis.vertical,
    this.listViewHeight,
    this.first = 15,
    this.next = 10,
    this.before = const [],
    this.after,
  }) : super(key: key);

  @override
  _GeneralPaginatedListViewState createState() =>
      _GeneralPaginatedListViewState();
}

class _GeneralPaginatedListViewState extends State<GeneralPaginatedListView> {
  late GeneralPagination _pagination;
  List<IncluyeCardTile> _results = [];
  bool _hasDocs = false;
  bool _error = false;
  bool loading = true;

  @override
  void initState() {
    print("initing listview");
    _pagination = GeneralPagination(query: widget.query);
    getFirstDocs();
    super.initState();
  }

  Future<void> getFirstDocs() async {
    debugPrint("Getting first docs...");
    _results = [];
    QuerySnapshot snap = await _pagination.getFirstDocs(first: widget.first);
    List<IncluyeCardTile> _incoming = [];
    if (snap.docs.isNotEmpty) {
      for (DocumentSnapshot doc in snap.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['uid'] = doc.id;
        _incoming.add(widget.resultObject.fromMap(data));
      }
      if (this.mounted) {
        setState(() {
          _results.addAll(_incoming);
          print(_results);
          loading = false;
          _hasDocs = _incoming.isNotEmpty;
          widget.hasData = _hasDocs;
        });
      }
    } else {
      setState(() {
        loading = false;
        _hasDocs = false;
      });
    }
  }

  //how to detect if last and stop making queries?
  Future<void> getNextDocs() async {
    print("Getting next docs...");
    QuerySnapshot snap = await _pagination.getNextDocs(next: widget.next);
    List<IncluyeCardTile> _incoming = [];
    if (snap != null) {
      for (DocumentSnapshot doc in snap.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['uid'] = doc.id;
        _incoming.add(widget.resultObject.fromMap(data));
      }
      setState(() {
        _results.addAll(_incoming);
        _hasDocs = true;
        widget.hasData = true;
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Center(
          child: SizedBox(
              height: 50, width: 50, child: CircularProgressIndicator()));
    } else if (_error) {
      return Center(
        child: Text("UnU\nSe produjo un error...perdon toy chiquito"),
      );
    } else if (!_hasDocs) {
      return ListView(
        scrollDirection: widget.scrollDirection,
        children: widget.before! + [_noDataListView()],
      );
    } else {
      return Container(
        height: widget.listViewHeight,
        child: NotificationListener(
          onNotification: (ScrollNotification scrollEnd) {
            var metrics = scrollEnd.metrics;
            if (metrics.atEdge) {
              if (metrics.pixels == 0)
                print('At top');
              else {
                print('At bottom');
                getNextDocs();
              }
            }

            return true;
          },
          child: ListView.builder(
            scrollDirection: widget.scrollDirection,
            itemCount: _results.length +
                (widget.before != null ? widget.before!.length : 0),
            itemBuilder: (context, index) {
              print(index);
              if (widget.before != null && index < widget.before!.length) {
                return widget.before![index];
              } else {
                IncluyeCardTile f = _results[index -
                    (widget.before != null ? widget.before!.length : 0)];
                print(f.toString());
                switch (widget.displayType) {
                  case ResultDisplayType.card:
                    return f.card(context: context);
                  case ResultDisplayType.tile:
                    return f.tile(context: context);
                  case ResultDisplayType.incompleteTile:
                    return f.incompleteTile(context: context);
                }
              }
            },
          ),
        ),
      );
    }
  }

  Widget _noDataListView() {
    return Center(
      child: ListView(
        shrinkWrap: true,
        children: [
          Center(
              child: Padding(
            padding: const EdgeInsets.all(64.0),
            child: Column(
              children: [
                Text("UnU",
                    style: TextStyle(
                        fontSize: 50, color: Theme.of(context).hintColor)),
                Text(widget.noDataMessage,
                    style: TextStyle(color: Theme.of(context).hintColor)),
              ],
            ),
          ))
        ],
      ),
    );
  }
}
