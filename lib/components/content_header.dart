import 'package:bi_replicate/provider/screen_content_provider.dart';
import 'package:bi_replicate/utils/constants/responsive.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../provider/local_provider.dart';
import '../widget/language_widget.dart';
import 'customCard.dart';

class ContentHeader extends StatefulWidget {
  const ContentHeader({super.key});

  @override
  State<ContentHeader> createState() => _ContentHeaderState();
}

class _ContentHeaderState extends State<ContentHeader> {
  double width = 0;
  double height = 0;
  late ScreenContentProvider provider;
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    provider = context.read<ScreenContentProvider>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Column(
        children: [
          Responsive.isDesktop(context)
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Consumer<ScreenContentProvider>(
                        builder: ((context, value, child) {
                      return Column(
                        children: [
                          Text(
                            provider.getTitle(),
                            style: TextStyle(
                              fontSize: Responsive.isDesktop(context)
                                  ? width * 0.015
                                  : 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      );
                    })),
                    const Text(
                      "Base Currency: ILS",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Consumer<ScreenContentProvider>(
                        builder: ((context, value, child) {
                      return Text(
                        provider.getTitle(),
                        style: TextStyle(
                          fontSize: Responsive.isDesktop(context)
                              ? width * 0.015
                              : 18,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    })),
                    const Text(
                      "Base Currency: ILS",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
          SizedBox(
            height: height * 0.04,
          ),
          Responsive.isDesktop(context)
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CustomCard(
                      gradientColor: [Color(0xff1cacff), Color(0xff30c4ff)],
                      title: '42136',
                      subtitle: 'Mon-Fri',
                      label: 'Overall Sale',
                      icon: Icons
                          .attach_money, // Provide the actual path to the icon
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    CustomCard(
                      gradientColor: [Color(0xfffd8236), Color(0xffffce6c)],
                      title: '1446',
                      subtitle: 'Mon-Fri',
                      label: 'Total Visited',
                      icon: Icons.abc, // Provide the actual path to the icon
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    CustomCard(
                      gradientColor: [Color(0xff4741c1), Color(0xff7e4fe4)],
                      title: '61%',
                      subtitle: 'Mon-Fri',
                      label: 'Overall Growth',
                      icon: Icons
                          .bar_chart, // Provide the actual path to the icon
                    ),
                  ],
                )
              : SizedBox(
                  width: width * 0.8,
                  height: height * 0.18,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: const [
                      CustomCard(
                        gradientColor: [Color(0xff1cacff), Color(0xff30c4ff)],
                        title: '42136',
                        subtitle: 'Mon-Fri',
                        label: 'Overall Sale',
                        icon: Icons
                            .attach_money, // Provide the actual path to the icon
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      CustomCard(
                        gradientColor: [Color(0xfffd8236), Color(0xffffce6c)],
                        title: '1446',
                        subtitle: 'Mon-Fri',
                        label: 'Total Visited',
                        icon: Icons.abc, // Provide the actual path to the icon
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      CustomCard(
                        gradientColor: [Color(0xff4741c1), Color(0xff7e4fe4)],
                        title: '61%',
                        subtitle: 'Mon-Fri',
                        label: 'Overall Growth',
                        icon: Icons
                            .bar_chart, // Provide the actual path to the icon
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
