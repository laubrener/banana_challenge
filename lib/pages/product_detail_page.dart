import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:banana_challenge/models/products_model.dart';
import 'package:banana_challenge/services/product_service.dart';
import 'package:banana_challenge/widgets/btn.dart';

class ProductPage extends StatefulWidget {
  final int prodId;
  const ProductPage({Key? key, required this.prodId}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage>
    with TickerProviderStateMixin {
  ProductDetailService productService = ProductDetailService();
  PageController pageController = PageController();

  int id = 0;

  @override
  void initState() {
    productService = context.read<ProductDetailService>();
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
    pageController.dispose();
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
                    ProductImages(product: product, controller: pageController),
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
        ignoreGestures: true,
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
    required this.controller,
  });

  final Product product;

  final PageController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: PageView.builder(
        scrollDirection: Axis.horizontal,
        controller: controller,
        itemBuilder: (context, index) => Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          width: 190,
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
