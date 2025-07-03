import 'package:flutter/material.dart';

double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;

double horizontalPadding(BuildContext context) => screenWidth(context) * .022;
double verticalPadding(BuildContext context) => screenHeight(context) * .035;

double cardHorizontalPadding(BuildContext context) => screenWidth(context) * .015;
double cardVerticalPadding(BuildContext context) => screenHeight(context) * .018;
