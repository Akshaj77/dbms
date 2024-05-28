class Todo {
  final int id;
  final String title;

  final String createdAt;
  final String? updatedAt;

  Todo({
    required this.id,
    required this.title,
    required this.createdAt,
    this.updatedAt,
  });

  factory Todo.fromSqfliteDatabase(Map<String,dynamic> map) => Todo(
    id: map['id']?.toInt() ?? 0,
    title: map['title'] ?? ' ',
    createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at']).toIso8601String(),
    updatedAt: map['updated_at'] != null ? DateTime.fromMillisecondsSinceEpoch(map['updated_at']).toIso8601String() : null,
  );
  

}

class Product {
  final int productId;
  final String productName;
  final int price;

  Product({
    required this.productId,
    required this.productName,
    required this.price,
  });

  factory Product.fromSqfliteDatabase(Map<String,dynamic> map) => Product(
    productId: map['Product_ID']?.toInt() ?? 0,
    productName: map['Product_Name'] ?? ' ',
    price: map['Price']?.toInt() ?? 0,
  );
}

class Inventory {
  
  final int productId;
  final int quantity;

  Inventory({
    
    required this.productId,
    required this.quantity,
  });

  factory Inventory.fromSqfliteDatabase(Map<String,dynamic> map) => Inventory(
   
    productId: map['Product_ID']?.toInt() ?? 0,
    quantity: map['Quantity']?.toInt() ?? 0,
  );
}

class Customer {
  final String customerNumber;
  final String customerName;

  Customer({
    required this.customerNumber,
    required this.customerName,
  });

  factory Customer.fromSqfliteDatabase(Map<String,dynamic> map) => Customer(
    customerNumber: map['Customer_Number'] ?? ' ',
    customerName: map['Customer_Name'] ?? ' ',
  ); 
}

class Order {
  final int orderId;
  final String cudtomerNumber;
  final String orderDate;
  final int totalAmount;


  Order({
    required this.orderId,
    required this.cudtomerNumber,
    required this.orderDate,
    required this.totalAmount,
  });

  factory Order.fromSqfliteDatabase(Map<String,dynamic> map) => Order(
    orderId: map['Order_ID']?.toInt() ?? 0,
    cudtomerNumber: map['Customer_Number'] ?? ' ',
    orderDate: DateTime.fromMillisecondsSinceEpoch(map['Order_Date']).toIso8601String(),
    totalAmount: map['Total_Amount']?.toInt() ?? 0,
  );
}


class OrderItems {
  final int orderItemId;
  final int orderId;
  final int productId;
  final int quantity;
  final int priceUnit;

  OrderItems({
    required this.orderItemId,
    required this.orderId,
    required this.productId,
    required this.quantity,
    required this.priceUnit,
  });

  factory OrderItems.fromSqfliteDatabase(Map<String,dynamic> map) => OrderItems(
    orderItemId: map['Order_Item_ID']?.toInt() ?? 0,
    orderId: map['Order_ID']?.toInt() ?? 0,
    productId: map['Product_ID']?.toInt() ?? 0,
    quantity: map['Quantity']?.toInt() ?? 0,
    priceUnit: map['Price_Unit']?.toInt() ?? 0,
  );
}

class Payments {
  final int paymentId;
  final int orderId;
  final String paymentDate;
  final int amount;

  Payments({
    required this.paymentId,
    required this.orderId,
    required this.paymentDate,
    required this.amount,
  });

  factory Payments.fromSqfliteDatabase(Map<String,dynamic> map) => Payments(
    paymentId: map['Payment_ID']?.toInt() ?? 0,
    orderId: map['Order_ID']?.toInt() ?? 0,
    paymentDate: DateTime.fromMillisecondsSinceEpoch(map['Payment_Date']).toIso8601String(),
    amount: map['Amount']?.toInt() ?? 0,
  );
}

class ProductDetails{

  final String productName;
 
   final int quantity;

   final int productID;
   

  ProductDetails({
    
    required this.productName,
   
    required this.quantity,

    required this.productID,
    
  
  });

  factory ProductDetails.fromSqfliteDatabase(Map<String,dynamic> map) => ProductDetails(
   
    productName: map['Product_Name'] ?? ' ',
 
    quantity: map['Quantity_Available'] != null ?int.parse(map['Quantity_Available'].toString()):0,

    productID: map['Product_ID']?.toInt() ?? 0,
   
   
  );
    
}

class ProductHistory {
  final int orderId;
  final String customerName;
  final String orderDate;
  final String productName;
  final double quantity;
  final double pricePerUnit;
  final double totalAmount;

  ProductHistory({
    required this.orderId,
    required this.customerName,
    required this.orderDate,
    required this.productName,
    required this.quantity,
    required this.pricePerUnit,
    required this.totalAmount,
  });

  factory ProductHistory.fromSqfliteDatabase(Map<String,dynamic> map) => ProductHistory(
    orderId: map['Order_ID']?.toInt() ?? 0,
    customerName: map['Customer_Name'] ?? ' ',
    orderDate: map['Order_Date'] ?? '',
    productName: map['Product_Name'] ?? ' ',
    quantity: double.parse(map['Quantity'].toString()),
    pricePerUnit: double.parse(map['Price_Per_Unit'].toString()),
    totalAmount: double.parse(map['Total_Price'].toString()),
);
}

class SaleMonth{
    final int totalSale;

    SaleMonth({
      required this.totalSale,
    });

    factory SaleMonth.fromSqfliteDatabase(Map<String,dynamic> map) => SaleMonth(
      // totalSale:  map['Total_Sale'] != null ? double.parse(map['Total_Sale'].toString()) : 0.0,
      totalSale: map['Total_Sale']?.toInt() ?? 0,
    );

}

class SaleCustomer {
  final String customerName;
  final int totalSale;

  SaleCustomer({
    required this.customerName,
    required this.totalSale,
  });

  factory SaleCustomer.fromSqfliteDatabase(Map<String,dynamic> map) => SaleCustomer(
    customerName: map['Customer_Name'] ?? ' ',
    totalSale: map['Total_Sale']?.toInt() ?? 0,
  );
}

class MaximumSaleProduct{
  final String productName;
  final int totalSale;

  MaximumSaleProduct({
    required this.productName,
    required this.totalSale,
  });

  factory MaximumSaleProduct.fromSqfliteDatabase(Map<String,dynamic> map) => MaximumSaleProduct(
    productName: map['Product_Name'] ?? ' ',
    totalSale: map['Total_Sale']?.toInt() ?? 0,
  );
}

class DebtDetails{
  int debtId;
  String customerName;
  int amount;
  String dueDate;

  DebtDetails({
    required this.debtId,
    required this.customerName,
    required this.amount,
    required this.dueDate,
  });

  factory DebtDetails.fromSqfliteDatabase(Map<String,dynamic> map) => DebtDetails(
    debtId: map['Debt_ID']?.toInt() ?? 0,
    customerName: map['Customer_Name'] ?? ' ',
    amount: map['Amount_Due']?.toInt() ?? 0,
    dueDate: map['Due_Date'] ?? '',
  );

}