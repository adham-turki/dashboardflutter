import 'package:bi_replicate/utils/constants/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TestStateManagement extends StatefulWidget {
  const TestStateManagement({super.key});

  @override
  State<TestStateManagement> createState() => _TestStateManagementState();
}

class _TestStateManagementState extends State<TestStateManagement> {
  @override
  Widget build(BuildContext context) {
    bool isDesktop = Responsive.isDesktop(context);
    return Column(
      children: [isDesktop ? desktopScreen() : mobileScreen()],
    );
  }

  desktopScreen() {}

  mobileScreen() {}
}
