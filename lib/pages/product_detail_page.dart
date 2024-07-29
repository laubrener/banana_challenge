import 'package:banana_challenge/models/products_model.dart';
import 'package:banana_challenge/services/product_service.dart';
import 'package:banana_challenge/widgets/btn.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductPage extends StatefulWidget {
  final int prodId;
  const ProductPage({Key? key, required this.prodId}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage>
    with TickerProviderStateMixin {
  ProductService productService = ProductService();

  @override
  void initState() {
    productService = Provider.of<ProductService>(context, listen: false);
    _loadProduct();
    super.initState();
  }

  @override
  void dispose() {
    // productService.dispose();
    super.dispose();
  }

  void _loadProduct() async {
    await productService.getProductDetail(widget.prodId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Product product = productService.productDetail;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title ?? ''),
      ),
      body: product.images == null //no es la forma, no funciona
          ? const Center(
              child: CircularProgressIndicator(
              color: Colors.grey,
            ))
          : Container(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 250,
                    width: double.infinity,
                    // color: Colors.greenAccent,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 10),
                        // color: Colors.pinkAccent,
                        // height: 190,
                        width: 190,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                offset: const Offset(0, 5),
                                blurRadius: 5,
                              )
                            ]),
                        child: product.images == null
                            ? Image.asset('assets/images/no-image.jpg')
                            : Image.network(product.images?[index] ?? '',
                                fit: BoxFit.contain),
                      ),
                      itemCount: product.images?.length,
                    ),
                  ),
                  Text(
                    product.description ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'USD ${product.price}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Btn(text: 'Agregar al carrito', onPressed: () {})
                ],
              ),
            ),
    );
  }
}
