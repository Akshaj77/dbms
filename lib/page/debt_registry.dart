import 'package:dbms/database/database_models.dart';
import 'package:flutter/material.dart';

class DebtRegistry extends StatefulWidget {
  @override
  _DebtRegistryState createState() => _DebtRegistryState();
}

class _DebtRegistryState extends State<DebtRegistry> {
  Future<List<dynamic>>? debts;

  final db = DatabaseModel();

  @override
  void initState() {
    super.initState();
    debts = db.fetchDebtsWithCustomerDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Debt Registry'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: debts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Padding(
              padding: EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Container(
                      margin: EdgeInsets.only(bottom: 8.0),
                    child: Card(
                      elevation: 5,
                      child: ListTile(
                        title: Text(
                          snapshot.data![index].customerName,
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          'Due Date: ${snapshot.data![index].dueDate}',
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        trailing: Text(
                          snapshot.data![index].amount>=0?'Due: ${snapshot.data![index].amount.toStringAsFixed(2)}': 'Advance: ${snapshot.data![index].amount.abs().toStringAsFixed(2)}',
                          style: TextStyle(
                            color: snapshot.data![index].amount>=0? Colors.redAccent:Colors.greenAccent,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );

                },
              ),
            );
          }
        },
      ),
    );
  }
}

