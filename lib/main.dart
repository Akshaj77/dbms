import 'package:dbms/page/debt_registry.dart';
import 'package:dbms/page/landing_page.dart';
import 'package:dbms/page/maxSale.dart';
import 'package:dbms/page/order_history.dart';
import 'package:dbms/page/paylater.dart';
import 'package:dbms/page/sales.dart';
import 'package:flutter/material.dart';
import 'page/product_detail.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: const SpecificSale(isCustomer:  false,number: '9876543210',year: '2024',month: '03',),
    // home: const OrderHistory(),
    home:  LandingPage(),
    // home: const MaxSaleProduct(year: '2024', month: '03'),1
    );
  }
}

