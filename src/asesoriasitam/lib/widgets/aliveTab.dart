import 'package:flutter/material.dart';

///Keeps tap loaded or alive in tabview
class AliveTab extends StatefulWidget {
  Widget tabBody;
  AliveTab({Key? key, required this.tabBody}) : super(key: key);

  @override
  _AliveTabState createState() => _AliveTabState();
}

class _AliveTabState extends State<AliveTab>
    with AutomaticKeepAliveClientMixin<AliveTab> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.tabBody;
  }

  @override
  bool get wantKeepAlive => true;
}
