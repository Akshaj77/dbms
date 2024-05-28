import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import '../database/database_services.dart';
import '../screens/model_serializers.dart';

class DatabaseModel{
  final tableName = "villa";


Future<void> createTable(Database db) async {
  await db.execute('''
    CREATE TABLE IF NOT EXISTS $tableName (
      "id" INTEGER NOT NULL ,
      "title" TEXT NOT NULL,
      "created_at" INTEGER NOT NULL DEFAULT (cast(strftime('%s','now') as int)),
      "updated_at" INTEGER,
      PRIMARY KEY("id" AUTOINCREMENT)
    )
  ''');
}

Future<int> create({required String title}) async {
  final database = await DatabaseService().database;
  return await database.rawInsert(
    '''
INSERT INTO $tableName (title,created_at) VALUES (?,?)
 ''',
[title,DateTime.now().millisecondsSinceEpoch],
  );
}

// Future<List<dynamic>> fetchAll(String fetchTable,String className) async{
//   final database = await DatabaseService().database;
//   final data  = await database.rawQuery(
//     // ''' SELECT * from $fetchTable ORDER BY COALESCE(updated_at,created_at) DESC ''',
//     ''' SELECT * from $fetchTable''',
   
//   );
//    return data.map((todo ) => Product.fromSqfliteDatabase(todo)).toList();
// }
Future<List<T>> fetchAll<T>(String fetchTable, T Function(Map<String, dynamic>) fromDatabase) async {
  final database = await DatabaseService().database;
  final data  = await database.rawQuery(
    ''' SELECT * from $fetchTable''',
  );
  return data.map((item) => fromDatabase(item)).toList();
}

Future<List<dynamic>> fetchProductDetails() async {
  final database = await DatabaseService().database;
  final data  = await database.rawQuery(
    ''' SELECT p.Product_ID,p.Product_Name, i.Quantity_Available
FROM Products p
LEFT JOIN Inventory i ON p.Product_ID = i.Product_ID;
''',
  );
  //  data.map((item) => fromDatabase(item)).toList();
  // print(data);
  return data.map((item) => ProductDetails.fromSqfliteDatabase(item)).toList();
}

Future<Todo> fetchById(int id) async{
  final database = await DatabaseService().database;
  final todo = await database.rawQuery(
    '''SELECT * from $tableName WHERE id = ?''',[id]
  );
  return Todo.fromSqfliteDatabase(todo.first);
}




Future<List<dynamic >> fetchProductHistory() async {
  final database = await DatabaseService().database;
  final data  = await database.rawQuery(
    ''' SELECT 
    o.Order_ID,
    c.Customer_Name AS Customer_Name,
    o.Order_Date,
    p.Product_Name,
    oi.Quantity,
    oi.Price_Per_Unit,
    oi.Quantity * oi.Price_Per_Unit AS Total_Price
FROM 
    Orders o
JOIN 
    Customers c ON o.Phone_Number = c.Phone_Number
JOIN 
    Order_Items oi ON o.Order_ID = oi.Order_ID
JOIN 
    Products p ON oi.Product_ID = p.Product_ID
ORDER BY 
    o.Order_Date DESC;

''',
  );
  print(data);
  //  data.map((item) => fromDatabase(item)).toList();
  // print(data);
  print(data.map((history) => ProductHistory.fromSqfliteDatabase(history)).toList());
  return data.map((history) => ProductHistory.fromSqfliteDatabase(history)).toList();
}


Future<List<dynamic>> fetchSaleforMonth(String year, String month) async {
  final database = await DatabaseService().database;
  final List<Map<String, dynamic>> result = await database.rawQuery('''
    SELECT SUM(Amount) as TotalSales
    FROM Payments
    WHERE 
      strftime('%Y', Transaction_Date) = ? AND
      strftime('%m', Transaction_Date) = ?
  ''', [year, month.padLeft(2, '0')]);
var monthlySale =  result.map((item) => SaleMonth.fromSqfliteDatabase(item)).toList();
  // print(data);
  return monthlySale;
 
}

// Future<List<dynamic>> fetchSaleforMonth(String year,String month) async {
//   final database = await DatabaseService().database;
//   final data  = await database.rawQuery(
//     ''' SELECT 
//     SUM(o.Total_Amount) AS Total_Sale
// FROM 
//     Orders o
// WHERE 
//     strftime('%Y', o.Order_Date) = ?
//     AND strftime('%m', o.Order_Date) = ?;

Future<void> deposit(String customerId, double depositAmount) async {
  final db = await DatabaseService().database;

  await db.rawUpdate(
    '''
UPDATE Debts 
SET Amount_Due = Amount_Due - ? 
WHERE Phone_Number = ?
    ''',
    [depositAmount, customerId],
  );
}

Future<void> placeOrderAndCreateDebt(String phoneNumber, List<Map<String, dynamic>> products, bool payLater) async {
  final database = await DatabaseService().database;

  await database.transaction((txn) async {
    // Insert the new order into the Orders table
    int orderId = await txn.rawInsert(
      '''
INSERT INTO Orders (Phone_Number, Order_Date) VALUES (?, ?)
      ''',
      [phoneNumber,  DateFormat('yyyy-MM-dd').format(DateTime.now()).toString()],
    );

    double totalAmount = 0.0;

    // Loop through each product in the order
    for (var product in products) {
      // Fetch the Product_ID and Price from the Products table
      List<Map<String, dynamic>> result = await txn.rawQuery(
        '''
SELECT Product_ID, Price FROM Products WHERE Product_Name = ?
        ''',
        [product['productName']],
      );

      int productId = result[0]['Product_ID'];
      int price = result[0]['Price'];

      // Insert the product into the Order_Items table
      await txn.rawInsert(
        '''
INSERT INTO Order_Items (Order_ID, Product_ID, Quantity, Price_Per_Unit)
VALUES (?, ?, ?, ?)
        ''',
        [orderId, productId, product['quantity'], price],
      );
//        await txn.rawInsert(
//     '''
// INSERT INTO Order_Items (Order_ID, Product_ID, Quantity, Price_Per_Unit)
// VALUES (?, ?, ?, ?)
//     ''',
//     [orderId, productId, product['quantity'], price],
//   );


      // Update the inventory
      await txn.rawUpdate(
        '''
UPDATE Inventory 
SET Quantity_Available = Quantity_Available - ? 
WHERE Product_ID = ?
        ''',
        [product['quantity'], productId],
      );

      totalAmount += price * product['quantity'];
    }

    if (payLater) {
      // Insert the debt into the Debts table
      await txn.rawUpdate(
        '''
UPDATE Debts 
SET Amount_Due = Amount_Due + ?, Due_Date = ?, Order_ID = ?
WHERE Phone_Number = ?
  
        ''', 
        [  totalAmount, DateFormat('yyyy-MM-dd').format(DateTime.now().add(Duration(days: 30))).toString(),orderId,phoneNumber],
      );
       List<Map<String, dynamic>> debts = await txn.rawQuery('SELECT * FROM Debts WHERE Order_ID = ?', [orderId]);
      print('Debts for Order_ID $orderId: $debts');
   
    } else {
      // Insert the payment into the Payments table
      await txn.rawInsert(
        '''
INSERT INTO Payments (Order_ID, Amount, Payment_Method, Status, Transaction_Date) VALUES (?, ?, ?, ?, ?)
        ''',
        [orderId, totalAmount, 'Cash', 'Paid', DateTime.now().toString()],
      );
       // Debug print to check Payments table
      List<Map<String, dynamic>> payments = await txn.rawQuery('SELECT * FROM Payments WHERE Order_ID = ?', [orderId]);
      print('Payments for Order_ID $orderId: $payments');
    }
  });
}


// ''',
// [year,month],
//   );
//   var monthlySale =  data.map((item) => SaleMonth.fromSqfliteDatabase(item)).toList();
//   // print(data);
//   return monthlySale;
// }





Future<List<dynamic>> fetchSaleforaCustomer(String CustomerPhoneNum) async {
  final database = await DatabaseService().database;
  final data  = await database.rawQuery(
    ''' SELECT SUM(Payments.Amount) as TotalSales
    FROM Orders
    INNER JOIN Payments ON Orders.Order_ID = Payments.Order_ID
    WHERE Orders.Phone_Number = ?


''',
[CustomerPhoneNum]
  );
  //  data.map((item) => fromDatabase(item)).toList();
  var raw = data.map((item) => SaleCustomer.fromSqfliteDatabase(item)).toList();
  // print(data.first);
  return raw;
}


Future<dynamic> MaximumsaleProduct(String year,String month)  async {
  final database = await DatabaseService().database;
  final data  = await database.rawQuery(
    ''' SELECT 
    p.Product_Name,
    SUM(oi.Quantity * oi.Price_Per_Unit) AS Total_Sale
FROM 
    Orders o
JOIN 
    Order_Items oi ON o.Order_ID = oi.Order_ID
JOIN 
    Products p ON oi.Product_ID = p.Product_ID
WHERE 
    strftime('%Y', o.Order_Date) = ?
    AND strftime('%m', o.Order_Date) = ?
GROUP BY 
    p.Product_Name
ORDER BY 
    Total_Sale DESC
LIMIT 1;



''',
[year, month],
  );
  //  data.map((item) => fromDatabase(item)).toList();
  print(data);
  return data.map((item) => MaximumSaleProduct.fromSqfliteDatabase(item)).toList();
}
//have to return the first

Future<void> deleteProduct(int productId) async {
  final database = await DatabaseService().database;

  // Delete the product from the Products table
 await database.transaction((txn) async {
    // Delete the product from the Products table
    await txn.rawDelete(
      '''DELETE FROM Products WHERE Product_ID = ?''',
      [productId],
    ); 
});

  // If you don't have a foreign key constraint with ON DELETE CASCADE,
  // you'll need to manually delete the related information from each table.
  // For example, if you have an Order_Items table that includes a Product_ID column,
  // you can delete the related order items like this:
  // await database.rawDelete(
  //   '''DELETE FROM Order_Items WHERE Product_ID = ?''',
  //   [productId],
  // );
}
// }

Future<List<Map<String, dynamic>>> fetchAllProducts() async {
  final database = await DatabaseService().database;
  final List<Map<String, dynamic>> maps = await database.rawQuery('SELECT * FROM Products');
  return maps;
}

Future<void> createProduct({required String productName, required double price, required int quantityAvailable}) async {
  try {
    final database = await DatabaseService().database;

    await database.transaction((txn) async {
      // Insert the new product into the Products table
      int productId = await txn.rawInsert(
        '''
    INSERT INTO Products (Product_Name, Price) VALUES (?, ?)
        ''',
        [productName, price],
      );
    
      // Insert the quantity available into the Inventory table
      await txn.rawInsert(
        '''
    INSERT INTO Inventory (Product_ID, Quantity_Available) VALUES (?, ?)
        ''',
        [productId, quantityAvailable],
      );

      
    });
    List<dynamic> dumm = await fetchProductDetails();
      print("Dummy length: "+dumm.length.toString());


  
    List<Map> products = await database.rawQuery('''
SELECT p.Product_Name, i.Quantity_Available
FROM Products p
LEFT JOIN Inventory i ON p.Product_ID = i.Product_ID;

''');
     print('All products:');
    products.forEach((product) {
      print(product);
    });

    // Fetch and print all inventory
    List<Map> inventory = await database.rawQuery('SELECT * FROM Inventory');
    print('All inventory:');
    inventory.forEach((item) {
      print(item);
    });

  
      
  

  } catch (e,s) {
    print('Error while creating product: $e');
    print('Stack trace: $s');
  }
}

Future<int> addPayment({required String paymentType, required double amount}) async {
  final database = await DatabaseService().database;
  return await database.rawInsert(
    '''
    INSERT INTO payments (payment_type, amount) VALUES (?, ?)
    ''',
    [paymentType, amount],
  );
}

Future<List<Map<String, dynamic>>> fetchAllPayments() async {
  final database = await DatabaseService().database;
  final List<Map<String, dynamic>> maps = await database.rawQuery('SELECT * FROM payments');
  return maps;}


Future<List<dynamic>> fetchDebtsWithCustomerDetails() async {
  final database = await DatabaseService().database;
  final data  = await database.rawQuery(
    ''' SELECT d.Debt_ID, c.Customer_Name, d.Amount_Due, d.Due_Date
FROM Debts d
JOIN Customers c ON d.Phone_Number = c.Phone_Number;
''',
  );
  // print(data);
  return data.map((item) => DebtDetails.fromSqfliteDatabase(item)).toList();
}



}
