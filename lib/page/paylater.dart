import 'package:dbms/database/database_models.dart';
import 'package:flutter/material.dart';

class PayLaterPage extends StatefulWidget {
  @override
  _PayLaterPageState createState() => _PayLaterPageState();
}

class _PayLaterPageState extends State<PayLaterPage> {
  String phoneNumber = '';
  List<Map<String, dynamic>> products = [];
  bool payLater = false;


  final db = DatabaseModel();
  Future<List<dynamic>>? futureObject;
  List<String>? selectedProductName;
  TextEditingController nameController  = TextEditingController();
  TextEditingController quantityController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
fetchproducts();

  }

 
  // final database = DatabaseService().database;

  

  void fetchproducts(){
    setState(() {
      futureObject =  db.fetchProductDetails();
    },);
  }


  Future<void> placeOrderAndCreateDebt () async {
    // Convert product name and quantity to a map
    

    // Place order logic here
    // print('Phone Number: $phoneNumber');
    // print('Order: $order');
    // print('Pay Later: $payLater');
    // products.removeAt(0);

  print(products);
    await 
        db.placeOrderAndCreateDebt(phoneNumber, products,payLater);

  }

  @override
   Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Place Order'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Enter Phone Number:', style: TextStyle(fontSize: 18.0)),
            TextField(
              onChanged: (value) {
                setState(() {
                  phoneNumber = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                
                  return Card(
                    elevation: 5,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text('Enter Product:', style: TextStyle(fontSize: 18.0)),
                          TextField(
                            onChanged: (value) {
                              setState(() {
                                products[index]['productName'] = (value) ;
                              });
                            },
                          ),
                          SizedBox(height: 16.0),
                          Text('Enter Quantity:', style: TextStyle(fontSize: 18.0)),
                          TextField(
                            onChanged: (value) {
                              setState(() {
                                products[index]['quantity'] = int.tryParse(value) ?? 0;
                              });
                            },
                          ),
                          SizedBox(height: 16.0),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  products.isEmpty? products.add({'productName': '', 'quantity': 0}):
                  products.add({'productName': nameController.text, 'quantity': quantityController.text});
                });
              },
              child: Text('Add Another Product'),
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Text('Pay Later:', style: TextStyle(fontSize: 18.0)),
                Checkbox(
                  value: payLater,
                  onChanged: (value) {
                    setState(() {
                      payLater = value ?? false;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  products = products;
                });
                print(products);
                placeOrderAndCreateDebt();
                AlertDialog(
                  title: Text('Order Placed'),
                  content: Text('Order has been placed successfully'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
                // Navigator.pop(context);
              },
              child: Text('Place Order'),
            ),
          ],
        ),
      ),
       floatingActionButton: FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            String phoneNumber = '';
            String depositAmount = '';

            return AlertDialog(
              title: Text('Deposit'),
              content: Column(
                children: [
                  TextField(
                    onChanged: (value) {
                      phoneNumber = value;
                    },
                    decoration: InputDecoration(
                      hintText: 'Phone Number',
                    ),
                  ),
                  TextField(
                    onChanged: (value) {
                      depositAmount = value;
                    },
                    decoration: InputDecoration(
                      hintText: 'Deposit Amount',
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await db.deposit(phoneNumber, double.parse(depositAmount));
                  },
                  child: Text('OK'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
              ],
            );
          },
        );
      },
      child: Icon(Icons.add),
    ),
    
    );
  }
}
