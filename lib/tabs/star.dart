import 'package:flutter/material.dart';

class Star extends StatefulWidget {
  const Star({super.key});

  @override
  StarState createState() => StarState();
}

class StarState extends State<Star> {
  final bool _pinned = true;
  final bool _snap = false;
  final bool _floating = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(shrinkWrap: true, slivers: [
        SliverAppBar(
          pinned: _pinned,
          snap: _snap,
          floating: _floating,
          expandedHeight: 150.0,
          centerTitle: false,
          backgroundColor: Colors.orange,
          flexibleSpace: FlexibleSpaceBar(
            background: Opacity(
              opacity: 1,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.purple,
                      Colors.orange,
                      Colors.amber,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            title: const Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                'Prioritized',
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
