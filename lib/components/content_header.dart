import 'package:bi_replicate/provider/screen_content_provider.dart';
import 'package:bi_replicate/utils/constants/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';

class ContentHeader extends StatefulWidget {
  const ContentHeader({super.key});

  @override
  State<ContentHeader> createState() => _ContentHeaderState();
}

class _ContentHeaderState extends State<ContentHeader> {
  double width = 0;

  late ScreenContentProvider provider;
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;

    provider = context.read<ScreenContentProvider>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Consumer<ScreenContentProvider>(builder: ((context, value, child) {
            return Text(
              provider.getTitle(),
              style: TextStyle(
                fontSize: Responsive.isDesktop(context) ? width * 0.015 : 18,
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
    );
  }
}
