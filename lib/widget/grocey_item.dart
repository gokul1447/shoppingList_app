

import 'package:flutter/material.dart';
//import 'package:grocery/data/dummy_items.dart';
import 'package:grocery/models/grocery_item.dart';
import 'package:grocery/widget/newitem.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});


  @override
  State<GroceryList> createState() => _GroceryListState();

}

class _GroceryListState extends State<GroceryList> {
    final List<GroceryItem> groceryItems = [];


  void _addItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (ctx) => const NewItem(),
      ),
    );
    if(newItem==null) {
      return;
    }
    setState(() {
      
      groceryItems.add(newItem);
    });


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [IconButton(onPressed: _addItem, icon: const Icon(Icons.add))],
      ),
      body: ListView.builder(
        itemCount: groceryItems.length,
        itemBuilder: (ctx, index) => ListTile(
          title: Text(groceryItems[index].name),
          leading: Container(
            width: 24,
            height: 24,
            color: groceryItems[index].category.color,
          ),
          trailing: Text(
            groceryItems[index].quantity.toString(),
          ),
        ),
      ),
    );
  }
}
