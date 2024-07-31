import 'package:banana_challenge/models/products_model.dart';
import 'package:banana_challenge/services/product_service.dart';
import 'package:banana_challenge/widgets/btn.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProductPage extends StatefulWidget {
  final int prodId;
  const ProductPage({Key? key, required this.prodId}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage>
    with TickerProviderStateMixin {
  ProductService productService = ProductService();
  int id = 0;

  @override
  void initState() {
    productService = Provider.of<ProductService>(context, listen: false);
    _loadProduct();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ProductPage oldWidget) {
    _loadProduct();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadProduct() async {
    id = widget.prodId;
    await productService.getProductDetail(widget.prodId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Product product = productService.productDetail;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title ?? ''),
        centerTitle: true,
        actions: const [
          Icon(
            Icons.shopping_cart_outlined,
          ),
          SizedBox(width: 10)
        ],
      ),
      body: product.images == null || product.id != id
          ? const Center(
              child: CircularProgressIndicator(
              color: Colors.grey,
            ))
          : SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ProductImages(product: product),
                    const SizedBox(height: 30),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        product.title ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        product.brand ?? '',
                        style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    RatingWidget(product: product),
                    const SizedBox(height: 10),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        product.description ?? '',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      // color: Colors.green,
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        'USD ${product.price}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Btn(text: 'Agregar al carrito', onPressed: () {})
                  ],
                ),
              ),
            ),
    );
  }
}

class RatingWidget extends StatelessWidget {
  const RatingWidget({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      alignment: Alignment.bottomLeft,
      width: double.infinity,
      height: 20,
      child: RatingBar.builder(
        direction: Axis.horizontal,
        onRatingUpdate: (value) => print(value),
        initialRating: product.rating ?? 0,
        itemCount: 5,
        itemSize: 22,
        allowHalfRating: true,
        unratedColor: Colors.grey[300],
        itemBuilder: (BuildContext context, int i) {
          return const Icon(
            Icons.star,
            color: Colors.amber,
          );
        },
      ),
    );
  }
}

class ProductImages extends StatelessWidget {
  const ProductImages({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: product.images!.length > 1
          ? double.infinity
          : MediaQuery.of(context).size.width * .5,
      // color: Colors.red,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          width: 190,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: const Offset(0, 5),
                  blurRadius: 5,
                )
              ]),
          child: FadeInImage(
            placeholder: const AssetImage('assets/images/no-image.jpg'),
            placeholderFit: BoxFit.cover,
            image: NetworkImage(product.images?[index] ?? ''),
            fit: BoxFit.contain,
          ),
        ),
        itemCount: product.images?.length,
      ),
    );
  }
}
