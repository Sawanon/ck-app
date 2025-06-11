import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottery_ck/components/header.dart';
import 'package:lottery_ck/res/color.dart';

class GuessPage extends StatelessWidget {
  const GuessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          const Header(
            title: 'ທາຍຫວຍ',
          ),
          Expanded(
            child: ListView(
              children: [
                Container(
                  alignment: Alignment.center,
                  height: 150,
                  color: AppColors.primary,
                  child: Text(
                    "Banner",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                DefaultTabController(
                  length: 2,
                  child: Builder(builder: (context) {
                    final tabController = DefaultTabController.of(context);
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TabBar(
                          tabs: [
                            Tab(
                              child: Text("a"),
                            ),
                            Tab(
                              child: Text("b"),
                            ),
                          ],
                        ),
                        AnimatedBuilder(
                          animation: tabController,
                          builder: (context, _) {
                            final index = tabController.index;
                            return IndexedStack(
                              index: index,
                              children: [
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(16),
                                  color: Colors.blue.shade100,
                                  child: Column(
                                    children: List.generate(
                                        2, (i) => Text('Tab A content $i')),
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(16),
                                  color: Colors.yellow.shade100,
                                  child: Column(
                                    children: List.generate(
                                        5, (i) => Text('Tab B content $i')),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        // SizedBox(
                        //   height: 400,
                        //   child: TabBarView(
                        //     children: [
                        //       Container(
                        //         color: Colors.blue,
                        //       ),
                        //       Container(
                        //         color: Colors.yellow,
                        //       ),
                        //     ],
                        //   ),
                        // ),
                      ],
                    );
                  }),
                )
              ],
            ),
          ),
        ],
      )),
    );
  }
}
