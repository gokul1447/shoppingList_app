import 'package:flutter/material.dart';
import 'package:grocery/models/category.dart';
import 'package:grocery/models/grocery_item.dart';

import '../data/categories.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  _NewItemState createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  final _formkey = GlobalKey<FormState>();
  var _enteredText='';
  var _enteredQuantity=1;
  var _selectedCategory=categories[Categories.vegetables]!;

  
  void _saveItem() {
    if(_formkey.currentState!.validate()) {
      _formkey.currentState!.save();
      Navigator.pop(context,GroceryItem(id: DateTime.now().toString(), 
      name: _enteredText, quantity: _enteredQuantity, category: _selectedCategory));

    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('data'),
      ),
      body: Padding(
        padding:const EdgeInsets.all(12),
        child: Form(
          key: _formkey,


            child: Column(
          children: [
            TextFormField(
              maxLength: 50,
              decoration: const InputDecoration(label: Text('name')),
              validator: (value){ if(value==null || value.isEmpty) 
                return 'Must be filled';
              
             return null;
              },
              onSaved: (value) {
                _enteredText=value!;
                
              },
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(label: Text('quantity')),
                     validator: (value){ if(value==null) {
                return 'Must be filled';
              }
             return null;
              },
              onSaved: (value) {
                _enteredQuantity=int.parse(value!);
              },
                    
                    initialValue: '1',
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: DropdownButtonFormField(
                    value: _selectedCategory,
                    items: [
                    for (final category in categories.entries)
                      DropdownMenuItem(
                        value: category.value,
                        child: Row(
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              color: category.value.color,
                            ),
                            const SizedBox(width: 6),
                            Text(category.value.title),
                          ],
                        ),
                      ),
                  ], onChanged: (value) {
                    setState(() {
                      _selectedCategory=value!;
                    });
                  }),
                )
              ],
            ),
            const SizedBox(height: 15),
            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      _formkey.currentState!.reset();
                    },
                    child: const Text('Reset'),
                  ),
                  ElevatedButton(
                    onPressed: _saveItem,
                    child: const Text('Add Item'),
                  )
                ],
            )

          ],
        ),
        
        ),
      ),
    );
  }
}
