import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
//import 'package:grocery/data/dummy_items.dart';
import 'package:grocery/models/grocery_item.dart';
import 'package:grocery/widget/newitem.dart';

import '../data/categories.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> groceryItems = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    final url =
        Uri.https('grocery-9eb02-default-rtdb.firebaseio.com', 'datas.json');
    final response = await http.get(url);
    final Map<String, dynamic> listData = json.decode(response.body);
    final List<GroceryItem> _loadedItems = [];
    for (final item in listData.entries) {
      final category = categories.entries
          .firstWhere(
              (catItem) => catItem.value.title == item.value['category'])
          .value;
      _loadedItems.add(
        GroceryItem(
          id: item.key,
          name: item.value['name'],
          quantity: item.value['quantity'],
          category: category,
        ),
      );
    }
    setState(() {
      groceryItems = _loadedItems;
    });
  }

  void _addItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (ctx) => const NewItem(),
      ),
    );
    _loadItems();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(child: Text('No items added yet.'));
    void undo(int index, GroceryItem item) {
    setState(() {
      groceryItems.insert(index, item);
    });
  }
    void _removeItem(GroceryItem item) {
      final index = groceryItems.indexOf(item);
      setState(() {
        groceryItems.remove(item);
      });

      final url = Uri.https(
          'grocery-9eb02-default-rtdb.firebaseio.com', 'datas/${item.id}.json');
      http.delete(url);
      
    }

    if (groceryItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: groceryItems.length,
        itemBuilder: (ctx, index) => Dismissible(
          background: Container(
            color: const Color.fromARGB(255, 109, 13, 6),
          ),
          onDismissed: (direction) {
            final removedItem = groceryItems[index];
    final removedItemIndex = index;
            _removeItem(groceryItems[index]);
            ScaffoldMessenger.of(context).showSnackBar( SnackBar(
                action: SnackBarAction(
                    label: 'undo',
                    onPressed: () {
                        undo(removedItemIndex, removedItem);
                    }
                      
                    ),
                content: Text('Item deleted')));
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
