import 'package:flutter/material.dart';
import 'package:intl/intl.dart ';
import 'package:dbms/database/database_models.dart';

class FeaturesPage extends StatefulWidget {

  @override
  State<FeaturesPage> createState() => _FeaturesPageState();
}

class _FeaturesPageState extends State<FeaturesPage> {
  String? selectedMonth;
  String? customerNum;
  Future<dynamic>? futureObjectmaxSale;
  Future<List<dynamic>>? futureCustomerSale;
  Future<List<dynamic>>? futureMonthlySale;

  final db = DatabaseModel(); 

  @override
  void initState() {
    super.initState();
    fetchMaxSale('2024', '03');
    fetchCustomerSale('6789012345');
    fetchMonthlySale('2024', '03');
  }

  void fetchMaxSale(String year, String month){
    setState(() {
      futureObjectmaxSale = db.MaximumsaleProduct(year, month);
    });
  }

  void fetchCustomerSale(String? customerNum){
    setState(() {
      futureCustomerSale = customerNum == null?null:db.fetchSaleforaCustomer(customerNum);
    });
  }

  void fetchMonthlySale(String year, String month){
    setState(() {
      futureMonthlySale = db.fetchSaleforMonth(year, month);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Info'),
      ),
      body: Column(
        children: [
          Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Select Month',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  DropdownButton<String>(
                    hint: Text('Select a month'),
                    value: selectedMonth,
                    items: [
                      for (var i = 1; i <= 12; i++)
                        DropdownMenuItem<String>(
                          value: i.toString().padLeft(2, '0'),
                          child: Text(DateFormat('MMMM').format(DateTime(2024, i))),
                        ),
                    ],
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedMonth = newValue;
                        fetchMaxSale('2024', selectedMonth!);
                        fetchMonthlySale('2024', selectedMonth!);
                      });
                    },
                  ),
                  FutureBuilder<List<dynamic>>(
                    future: futureMonthlySale,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return Text('Max Sales: ${snapshot.data![0].totalSale}');
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Enter a Number',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        customerNum = value;
                        fetchCustomerSale(customerNum);
                      });
                    },
                  ),
                  FutureBuilder<List<dynamic>>(
                    future: futureCustomerSale,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return Text('${snapshot.data![0].customerName}: ${snapshot.data![0].totalSale}');
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: FutureBuilder<dynamic>(
                future: futureObjectmaxSale,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Text('${snapshot.data![0].productName}: ${snapshot.data![0].totalSale}');
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}