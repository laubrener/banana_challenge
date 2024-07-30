import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:banana_challenge/pages/product_detail_page.dart';
import 'package:banana_challenge/models/products_model.dart';
import 'package:banana_challenge/services/product_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  ProductService productService = ProductService();
  TextEditingController searchCtrl = TextEditingController();
  List<Product>? products = [];
  String query = '';
  bool isEmpty = false;

  @override
  void initState() {
    productService = Provider.of<ProductService>(context, listen: false);
    _loadProducts();

    super.initState();
  }

  @override
  void dispose() {
    productService.dispose();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    await productService.getProducts();
    products = productService.productsList;
    query = '';
    isEmpty = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Challenge 2024'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: SearchBar(
              padding: const MaterialStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 10)),
              controller: searchCtrl,
              hintText: 'Buscar producto',
              leading: IconButton(
                icon: const Icon(Icons.search_outlined),
                onPressed: () async {
                  await Provider.of<ProductService>(context, listen: false)
                      .getProductsByQuery(searchCtrl.text);
                  products = productService.productsSearchList;
                  if (products!.isEmpty) {
                    isEmpty = true;
                    query = searchCtrl.text;
                  }
                  searchCtrl.text = '';
                  setState(() {});
                },
              ),
              trailing: [
                IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => searchCtrl.text = '')
              ],
              constraints: const BoxConstraints(maxHeight: 60),
              backgroundColor: const MaterialStatePropertyAll(Colors.white),
              textStyle:
                  const MaterialStatePropertyAll(TextStyle(color: Colors.grey)),
              onChanged: (value) => print(value),
              onTap: () {
                print('ontap: ${searchCtrl.text}');
              },
            ),
          ),
          isEmpty
              ? Container(
                  height: 60,
                  alignment: Alignment.center,
                  child: Text(
                    'No se encontraron resultados para: "$query"',
                    style: const TextStyle(fontSize: 16),
                  ))
              : Container(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadProducts,
              child: ListView.builder(
                itemCount: products?.length,
                itemBuilder: (context, i) {
                  return Card(product: products![i]);
                },
              ),
            ),
          ),
        ],
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
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => ProductPage(
                      prodId: product.id ?? 1,
                    )));
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.all(20),
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
                    const SizedBox(height: 5),
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
            const SizedBox(height: 10),
            Text(product.description ?? '',
                overflow: TextOverflow.ellipsis, maxLines: 2),
            const SizedBox(height: 10),
            Text(
              'Stock: ${product.stock}',
              style: TextStyle(
                  color: (product.stock ?? 0) < 10 ? Colors.red : Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
