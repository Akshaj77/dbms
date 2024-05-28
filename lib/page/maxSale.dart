import 'package:dbms/database/database_models.dart';
import 'package:flutter/material.dart';

class MaxSaleProduct extends StatefulWidget {
  const MaxSaleProduct({
   
   
    required this.year,
    required this.month,

  });

  

  final String year;
  final String month;

  @override
  State<MaxSaleProduct> createState() => _MaximumSaleProductState();
}

class _MaximumSaleProductState extends State<MaxSaleProduct> {
  final db = DatabaseModel();
  List<dynamic>? sales;

  @override
  void initState() {
    super.initState();
    fetchSales();
  }

  Future<void> fetchSales() async {
    var result = await 
        db.MaximumsaleProduct(widget.year, widget.month);
    
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
      return 
          Column(
              children: [
                Text(sales![0].productName.toString()),
                Text(sales![0].totalSale.toString()),
              ],
            );
         
    }
  }
}