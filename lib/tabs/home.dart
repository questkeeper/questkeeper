import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
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
          backgroundColor: Colors.deepPurple,
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.pin,
            background: Opacity(
              opacity: 0.5,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.deepPurple,
                      Colors.purple,
                      Colors.indigo,
                      Colors.blue,
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
                'Assignments',
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
