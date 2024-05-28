import 'package:dbms/database/database_models.dart';
import 'package:dbms/screens/model_serializers.dart';
import 'package:flutter/material.dart';


class OrderHistory extends StatefulWidget {
  const OrderHistory({super.key});

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {

   Future<List<dynamic>>? futureObject;
  final db = DatabaseModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchHistory();
  }

   void fetchHistory(){
    setState(() {
      futureObject = db.fetchProductHistory();
      // db.fetchSaleforMonth('2024','3');
      // db.fetchSaleforaCustomer('9876543210');
    },);
  }



 @override
Widget build(BuildContext context) {
  print(futureObject);
  return Scaffold(
    appBar: AppBar(
      title: const Text('Order History'),
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: FutureBuilder<List<dynamic>>(
        future: futureObject, 
        builder: (context,snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }
          else {
            final history = snapshot.data!;
            return history.isEmpty 
              ? const Center(
                  child: Text(
                    'No Order History', 
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
                  ),
                )
              : ListView.separated(
                  separatorBuilder: (context,index ) => const Divider(height: 24),
                  itemBuilder: (context, index) {
                    final record = history[index];
                    print(record);
                    return Card(
                      child: ListTile(
                        title: Text(
                          '${record.productName} ${record.customerName} ${record.quantity}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(record.orderDate.toString()),
                        trailing: Text(
                          record.totalAmount.toString(),
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.green[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: history.length,
                );
          }
        },
      ),
    ),
    // floatingActionButton: FloatingActionButton(
    //   onPressed: () {
    //     // Add your logic here for the FloatingActionButton onPressed event
    //   },
    //   child: Icon(Icons.add),
    // ),
  );
}}