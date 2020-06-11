import 'package:flutter/material.dart';
import 'package:flutter_stripe_payments/pages/stripe/add_new_card_page.dart';
import 'package:flutter_stripe_payments/pages/checkout_page.dart';
import 'package:flutter_stripe_payments/pages/paypal/PaypalPayment.dart';
import 'package:flutter_stripe_payments/pages/stripe/existing-cards.dart';
import 'package:flutter_stripe_payments/pages/stripe/pay_via_new_card.dart';
import 'package:flutter_stripe_payments/pages/stripe/select_card_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => CheckOutPage(),
        '/amount' : (context) => CheckOutPage(),
        '/home': (context) => SelectCardPage(),
        '/new-cards': (context) => PayViaNewCard(),
        '/add-new-card': (context) => AddNewCardPage(),
        '/existing-cards': (context) => ExistingCardsPage(),
        '/paypal-payment-page': (context) => PaypalPayment()
      },
    );
  }
}