import 'package:flutter/material.dart';

double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;

double horizontalPadding(BuildContext context) => screenWidth(context) * .04;
double verticalPadding(BuildContext context) => screenHeight(context) * .03;
