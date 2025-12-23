// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import '../../../../widgets/button/back_button.dart';
import '../../../../widgets/custom_text_styles.dart';

class Security extends StatefulWidget {
  const Security({super.key});

  @override
  State<Security> createState() => _SecurityState();
}

class _SecurityState extends State<Security> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: PrimaryBackButton(),
        centerTitle: true,
        title: Text(
          'Security',
          style: CustomTextStyles.appBarTitleText(context),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        surfaceTintColor: Theme.of(context).colorScheme.background,
      ),
      body: Center(
        child: Text('Security Screen'),
      ),
    );
  }
}