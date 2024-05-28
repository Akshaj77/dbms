import 'package:dbms/database/database_models.dart';
import 'package:dbms/page/debt_registry.dart';
import 'package:dbms/page/features_page.dart';
import 'package:dbms/page/order_history.dart';
import 'package:dbms/page/paylater.dart';
import 'package:dbms/page/product_detail.dart';
import 'package:dbms/screens/model_serializers.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {

  int _currentIndex = 0;
  final _pageController = PageController();


  final db = DatabaseModel();
  List<dynamic>? sales,salesforMonth,salesforCustomer;

  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _monthController = TextEditingController();
  TextEditingController _yearController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchSales('2024','03');
    fetchSalesforMonth('2024','3 ' );
    fetchSalesforCustomer('0123456789');
  }

  Future<void> fetchSales(String year,String month) async {
    var result = await 
        db.MaximumsaleProduct(year, month);
    
      print(result);
      setState(() {
        sales = result;
      });
  }

  Future<void> fetchSalesforMonth(String year,String month) async {
    var result = await 
        db.fetchSaleforMonth(year, month);
    
      print(result);
      setState(() {
        salesforMonth = result;
      });
  }

  Future<void> fetchSalesforCustomer(String phoneNumber) async {
    var result = await 
        db.fetchSaleforaCustomer(phoneNumber);
    
      print(result);
      setState(() {
        salesforCustomer = result;
      });
  }


@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop App',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          ProductDetail(),
          OrderHistory(),
          
          DebtRegistry(),
          PayLaterPage(),
         
          
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          _pageController.animateToPage(index, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
        },
        selectedLabelStyle: TextStyle(color: Colors.black), 
  unselectedLabelStyle: TextStyle(color: Colors.black), 
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home, color: Colors.black), label: 'Products' ),
          BottomNavigationBarItem(icon: Icon(Icons.history, color: Colors.black), label: 'History'),
          
          BottomNavigationBarItem(icon: Icon(Icons.money_off, color: Colors.black), label: 'Debts'),
          BottomNavigationBarItem(icon: Icon(Icons.payment, color: Colors.black), label: 'Order'),
         
        ],
      ),
    );
  }
}

// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(
//       title: const Text('Shop App',
//       style: TextStyle(
//         fontSize: 20.0,
//         fontWeight: FontWeight.bold,)
//       ),
//     ),
//     body: SingleChildScrollView(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: <Widget>[
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductDetail()));
//               },
//               child: const Text('Product Detail',
//               style: TextStyle(
//                 fontSize: 20.0,
//                 fontWeight: FontWeight.bold,
//               ),
//               ),
//             ),
//             SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderHistory()));
//               },
//               child: const Text('Order History',
//               style: TextStyle(
//                 fontSize: 20.0,
//                 fontWeight: FontWeight.bold,
//               ),
//               ),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(context, MaterialPageRoute(builder: (context) =>  DebtRegistry()));
//               },
//               child: const Text('Debt Registry',
//               style: TextStyle(
//                 fontSize: 20.0,
//                 fontWeight: FontWeight.bold,
//               ),
//               ),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(context, MaterialPageRoute(builder: (context) => PayLaterPage()));
//               },
//               child: const Text('Pay Later',
//               style: TextStyle(
//                 fontSize: 20.0,
//                 fontWeight: FontWeight.bold,
//               ),
//               ),
//             ),
//             SizedBox(height: 20),
//               TextField(
//               controller: _yearController,
//               decoration: InputDecoration(
//                 labelText: 'Enter Year',
//               ),
//             ),
//             TextField(
//               controller: _monthController,
//               decoration: InputDecoration(
//                 labelText: 'Enter Month',
//               ),
//             ),
//             TextField(
//               controller: _phoneNumberController,
//               decoration: InputDecoration(
//                 labelText: 'Enter Phone Number',
//               ),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 fetchSales(_yearController.text, _monthController.text);
//                 fetchSalesforMonth(_yearController.text, _monthController.text);
//                 fetchSalesforCustomer(_phoneNumberController.text);
//               },
               
//               child: const Text('Fetch Data',
//               style: TextStyle(
//                 fontSize: 20.0,
//                 fontWeight: FontWeight.bold,
//               ),
//               ),
//             ),
//               SizedBox(height: 10),
//             salesforMonth == null 
//               ? CircularProgressIndicator()
//               : Card(
//                   child: ListTile(
//                     title: Text('Sales for the month: ${salesforMonth![0].totalSale.toString()}',
//                     style: TextStyle(
//                       fontSize: 20.0,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     ),
//                   ),
//                 ),
//             SizedBox(height: 10),
//             salesforCustomer == null 
//               ? CircularProgressIndicator()
//               : Card(
//                   child: ListTile(
//                     title: Text('Sales for the customer(Ram): ${salesforCustomer![0].totalSale.toString()}',
//                     style: TextStyle(
//                       fontSize: 20.0,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     ),
//                   ),
//                 ),
//             SizedBox(height: 10),
//             sales == null 
//               ? CircularProgressIndicator()
//               : Card(
//                   child: ListTile(
//                     title: sales!.isEmpty?CircularProgressIndicator() :Text('Product with Maximum Sales: ${sales![0].productName.toString()} with total sales of ${sales![0].totalSale}',
//                     style: TextStyle(
//                       fontSize: 20.0,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     ),
//                   ),
//                 ),
                
//             //      ElevatedButton(
//             //   onPressed: () {
//             //     // Add your logic here for adding data
//             //   },
//             //   child: const Text('Add Data',
//             //   style: TextStyle(
//             //     fontSize: 20.0,
//             //     fontWeight: FontWeight.bold,
//             //   ),
//             //   ),
//             // ),
//             // SizedBox(height: 10),
//             // ElevatedButton(
//             //   onPressed: () {
//             //     // Add your logic here for deleting data
//             //   },
//             //   child: const Text('Delete Data',
//             //   style: TextStyle(
//             //     fontSize: 20.0,
//             //     fontWeight: FontWeight.bold,
//             //   ),
//             //   ),
//             // ),
//             // SizedBox(height: 10),
//             // ElevatedButton(
//             //   onPressed: () {
//             //     // Add your logic here for updating data
//             //   },
//             //   child: const Text('Update Data',
//             //   style: TextStyle(
//             //     fontSize: 20.0,
//             //     fontWeight: FontWeight.bold,
//             //   ),
//             //   ),
//             // ),
//           ],
//         ),
//       ),
//     ),
//   );
// }}