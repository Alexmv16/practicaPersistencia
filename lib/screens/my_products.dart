
import 'package:flutter/cupertino.dart';
import 'package:persistencia/screens/bd_persistence.dart';
import 'package:flutter/material.dart';

class MyProducts extends StatefulWidget {
  const MyProducts({Key? key}) : super(key: key);

  @override
  State<MyProducts> createState() => _MyProductsState();
}

class _MyProductsState extends State<MyProducts> {
  late int _numProducts;
  late String _products;

  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _idController = TextEditingController();

  @override
  void initState() {
    _numProducts = 0;
    super.initState();
  }

  @override
  void dispose() {
    BdManager.close(); // free db resources
    _productNameController.dispose();
    _stockController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('PRODUCTS', style: TextStyle(fontSize: 25.0)),
                ),
                _textField("Product Name", _productNameController),
                _textField("Stock", _stockController),
                _textField("Price", _priceController),
                _textField("Id", _idController),
                _buttonBar(),
                FutureBuilder<List>(
                  future: BdManager.getAll(),
                  builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError || snapshot.data!.isEmpty) {
                        _products = 'No products in DB';
                      } else {
                        _products =
                            snapshot.data!.join('\n'); // concat all data list elements
                      }
                      return Column(children: <Widget>[
                        Text(
                          _products,
                          style: const TextStyle(fontSize: 16.0),
                        ),
                      ]);
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _textField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }

  Widget _buttonBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: _insertProduct,
            child: const Text('Insert product'),
          ),
          ElevatedButton(
            onPressed: _deleteId,
            child: const Text('Delete id'),
          ),
          ElevatedButton(
            onPressed: _showProduct,
            child: const Text('Show Id'),
          ),
          ElevatedButton(
            onPressed: _deleteDb,
            child: const Text('DeleteDB'),
          ),
        ],
      ),
    );
  }

  // operations
  void _insertProduct() {
    String productName = _productNameController.text;
    int stock = int.tryParse(_stockController.text) ?? 0;
    double price = double.tryParse(_priceController.text) ?? 0.0;

    BdManager.insert(productName, stock, price);
    setState(() {});
  }

  void _deleteAll() async {
    if (await BdManager.deleteAll(3) == 0) {
      _showSnackbar('There are no products to delete');
    }

    setState(() {});
  }

  void _deleteId() async {
    if (await BdManager.deleteId(int.tryParse(_idController.text) ?? 0) == 0) {
      _showSnackbar('Product id not found in DB');
    }

    setState(() {});
  }



  void _showProduct() async {
    final prod = await BdManager.getProduct(int.tryParse(_idController.text) ?? 0);
    (prod.isEmpty)
        ? _showSnackbar('Product id not found in DB')
        : _showSnackbar(prod.toString());
  }

  void _deleteDb() async {
    await BdManager.deleteDb();
    _showSnackbar('DB file deleted');
    setState(() => _numProducts = 0);
  }

  void _showSnackbar(String msg) {
    SnackBar snackBar = SnackBar(
      content: Text('$msg'),
      backgroundColor: Theme.of(context).primaryColor,
    );
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}