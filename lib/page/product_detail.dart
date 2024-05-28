


import 'package:dbms/database/database_models.dart';
import 'package:dbms/database/database_services.dart';
import 'package:dbms/widget/create_todo_widget.dart';
// import 'package:dbms/widget/create_product_widget.dart';
import 'package:flutter/material.dart';
import '../screens/model_serializers.dart';
import 'package:intl/intl.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({super.key});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {

  Future<List<dynamic>>? futureObject;
  final db = DatabaseModel();
  // final database = DatabaseService().database;

  @override
  void initState() {
    super.initState();
    fetchproducts();
  }

  void fetchproducts(){
    setState(() {
      futureObject =  db.fetchProductDetails();
      
    },);
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Product Details'),
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
            final products = snapshot.data!;
            // final products = [];
            return products.isEmpty 
              ? const Center(
                  child: Text(
                    'No Products Available', 
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
                  ),
                )
              : ListView.separated(
                  separatorBuilder: (context,index ) => const Divider(height: 24),
                  itemBuilder: (context, index) {
                    final product = products[index];
                    print(product);
                    return Card(
                      child: ListTile(
                        title: Text(
                          '${product.productName} ',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                        ),
                        subtitle: Text('${product.quantity.toString()} available ',
                        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15.0),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            await db.deleteProduct(product.productID);
                            fetchproducts();
                          },
                        ),
                      ),
                    );
                  },
                  itemCount: products.length,
                );
          }
        },
      ),
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (_) => CreateProductWidget(
            onSubmit: (productName, price, quantityAvailable) async {
              await db.createProduct(
                productName: productName,
                price: double.parse(price),
                quantityAvailable: int.parse(quantityAvailable),
              );
              if (!mounted) return;
              fetchproducts();
              Navigator.of(context).pop();
            },
          ),
        );
      },
      child: Icon(Icons.add),
    ),
  );
}}