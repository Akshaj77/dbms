import 'package:dbms/database/database_models.dart';
import 'package:flutter/material.dart';

class SpecificSale extends StatefulWidget {
  const SpecificSale({
    required this.isCustomer,
    required this.number,
    required this.year,
    required this.month,

  });

  final bool isCustomer;
  final String number;
  final String year;
  final String month;

  @override
  State<SpecificSale> createState() => _SpecificSaleState();
}

class _SpecificSaleState extends State<SpecificSale> {
  final db = DatabaseModel();
  List<dynamic>? sales;

  @override
  void initState() {
    super.initState();
    fetchSales();
  }

  Future<void> fetchSales() async {
    var result = await (widget.isCustomer
        ? db.fetchSaleforaCustomer(widget.number)
        : db.fetchSaleforMonth(widget.year, widget.month));
    
      print(result);
      setState(() {
        sales = result;
      });
      
      
  
    // print(sales![0]);
    print( sales![0].totalSale);
  }

  @override
  Widget build(BuildContext context) {
    if (sales == null) {
      return const Center(child: CircularProgressIndicator());
    } else if (sales!.isEmpty) {
      return const Center(
        child: Text(
          'No Data..',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),
      );
    } else {
      return widget.isCustomer
          ? Column(
              children: [
                Text(sales![0].customerName),
                Text(sales![0].totalSale.toString()),
              ],
            )
          : Column(
              children: [
                Text(widget.year + ' ' + widget.month),
                Text(sales![0].totalSale.toString()),
              ],
            );
    }
  }
}