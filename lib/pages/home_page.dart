import 'package:banana_challenge/models/products_model.dart';
import 'package:banana_challenge/services/product_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  ProductService productService = ProductService();

  @override
  void initState() {
    productService = Provider.of<ProductService>(context, listen: false);
    _loadProducts();
    super.initState();
  }

  void _loadProducts() async {
    await productService.getProducts();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List<Product>? products = productService.productsList;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Challenge 2024'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: products?.length,
        itemBuilder: (context, i) {
          return Card(product: products![i]);
        },
      ),
    );
  }
}

class Card extends StatelessWidget {
  final Product product;
  const Card({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, 5),
              blurRadius: 5,
            )
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Text(
                      product.title ?? '',
                      overflow: TextOverflow.clip,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    product.brand ?? '',
                    style: TextStyle(color: Colors.grey[400]),
                  )
                ],
              ),
              Container(
                child: Text(
                  'USD ${product.price}',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          Text(product.description ?? '',
              overflow: TextOverflow.ellipsis, maxLines: 2),
          Text('Stock: ${product.stock}'),
        ],
      ),
    );
  }
}
