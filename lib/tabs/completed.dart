import 'package:flutter/material.dart';

class Completed extends StatefulWidget {
  const Completed({super.key});

  @override
  CompletedState createState() => CompletedState();
}

class CompletedState extends State<Completed> {
  final bool _pinned = true;
  final bool _snap = false;
  final bool _floating = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(shrinkWrap: true, slivers: [
        SliverAppBar(
          backgroundColor: Colors.green,
          pinned: _pinned,
          snap: _snap,
          floating: _floating,
          expandedHeight: 150.0,
          centerTitle: false,
          flexibleSpace: FlexibleSpaceBar(
            background: Opacity(
              opacity: 0.75,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.purple, Colors.green, Colors.lightGreen],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            title: const Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                'Completed',
                textScaler: TextScaler.linear(1.1),
              ),
            ),
          ),
        ),
        _listItem(),
      ]),
    );
  }

  Widget _listItem() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Container();
        },
        childCount: 1,
      ),
    );
    // return AssignmentsList(
    //   page: PageType.star,
    // );
  }
}
