import 'dart:ffi';

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
    if (newItem == null) {
      return;
    }
    setState(() {
      groceryItems.add(newItem);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(child: Text('No items added yet.'));
    void _removeItem(GroceryItem item) {
      setState(() {
        groceryItems.remove(item);
      });
    }

    if (groceryItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: groceryItems.length,
        itemBuilder: (ctx, index) => Dismissible(
          background: Container(
            color: const Color.fromARGB(255, 109, 13, 6),
          ),
          onDismissed: (direction) {
            _removeItem(groceryItems[index]);
            ScaffoldMessenger.of(context)
            
                .showSnackBar(const SnackBar(content: Text('Item deleted')));
                
          },
          key: ValueKey(groceryItems[index].id),
          child: ListTile(
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

    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Groceries'),
          actions: [
            IconButton(onPressed: _addItem, icon: const Icon(Icons.add))
          ],
        ),
        body: content);
  }
}
