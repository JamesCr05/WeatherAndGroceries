import 'package:flutter/material.dart';
import 'database.dart';
import 'package:metric/reusable_drawer.dart';

class Groceries extends StatefulWidget {
  const Groceries({Key? key}) : super(key: key);

  @override
  State<Groceries> createState() => _GroceriesState();
}

class _GroceriesState extends State<Groceries> {
  String? input;

  insertDatabase(double amount, String unit, String item) {
    IngredientsDatabaseHelper.instance.insertIngredient({
      IngredientsDatabaseHelper.colAmount: amount,
      IngredientsDatabaseHelper.colUnit: unit,
      IngredientsDatabaseHelper.colItem: item,
    });
  }

  updateDatabase(snap, int index, double amount, String unit, String item) {
    IngredientsDatabaseHelper.instance.update({
      IngredientsDatabaseHelper.colId: snap.data![index]
          [IngredientsDatabaseHelper.colId],
      IngredientsDatabaseHelper.colAmount: amount,
      IngredientsDatabaseHelper.colUnit: unit,
      IngredientsDatabaseHelper.colItem: item,
    });
  }

  deleteDatabase(snap, index) {
    IngredientsDatabaseHelper.instance
        .delete(snap.data![index][IngredientsDatabaseHelper.colId]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const ReusableDrawer(),
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.lightbulb),
            onPressed: () {
              Navigator.pushNamed(context, '/recipes');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: IngredientsDatabaseHelper.instance.queryAll(),
          builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snap) {
            if (snap.hasData) {
              return ListView.builder(
                itemCount: snap.data!.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: UniqueKey(),
                    onDismissed: (direction) {
                      deleteDatabase(snap, index);
                    },
                    child: Card(
                      child: ListTile(
                        title: Row(
                          children: [
                            if (snap.data![index]
                                        [IngredientsDatabaseHelper.colAmount]
                                    .truncateToDouble() ==
                                snap.data![index]
                                    [IngredientsDatabaseHelper.colAmount])
                              Text(
                                '${snap.data![index][IngredientsDatabaseHelper.colAmount].toStringAsFixed(0)} ',
                              ),
                            if (!(snap.data![index]
                                        [IngredientsDatabaseHelper.colAmount]
                                    .truncateToDouble() ==
                                snap.data![index]
                                    [IngredientsDatabaseHelper.colAmount]))
                              Text(
                                '${snap.data![index][IngredientsDatabaseHelper.colAmount]} ',
                              ),
                            if (snap.data![index]
                                        [IngredientsDatabaseHelper.colUnit] !=
                                    '' &&
                                snap.data![index]
                                        [IngredientsDatabaseHelper.colAmount] !=
                                    1)
                              Text(
                                '${snap.data![index][IngredientsDatabaseHelper.colUnit]}s of ',
                              ),
                            if (snap.data![index]
                                        [IngredientsDatabaseHelper.colUnit] !=
                                    '' &&
                                snap.data![index]
                                        [IngredientsDatabaseHelper.colAmount] ==
                                    1)
                              Text(
                                '${snap.data![index][IngredientsDatabaseHelper.colUnit]} of ',
                              ),
                            Text(
                              snap.data![index]
                                  [IngredientsDatabaseHelper.colItem],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                double amount = 0;
                String unit = '';
                String item = '';
                return AlertDialog(
                  title: const Text('Add Item'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        onChanged: (value) {
                          amount = double.parse(value);
                        },
                        decoration: const InputDecoration(
                          hintText: 'Amount',
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      StatefulBuilder(
                        builder: (context, setState) {
                          return SizedBox(
                            width: 500,
                            child: DropdownButton<String>(
                              value: input,
                              hint: const Text('Unit'),
                              underline: Container(
                                height: 2,
                              ),
                              onChanged: (String? value) {
                                setState(() {
                                  input = value!;
                                  unit = value!;
                                });
                              },
                              items: const <DropdownMenuItem<String>>[
                                DropdownMenuItem(
                                  value: '',
                                  child: Text('no unit'),
                                ),
                                DropdownMenuItem(
                                  value: 'kilogram',
                                  child: Text('kilogram'),
                                ),
                                DropdownMenuItem(
                                  value: 'gram',
                                  child: Text('gram'),
                                ),
                                DropdownMenuItem(
                                  value: 'liter',
                                  child: Text('liter'),
                                ),
                                DropdownMenuItem(
                                  value: 'milliliter',
                                  child: Text('milliliter'),
                                ),
                                DropdownMenuItem(
                                  value: 'meter',
                                  child: Text('meter'),
                                ),
                                DropdownMenuItem(
                                  value: 'centimeter',
                                  child: Text('centimeter'),
                                ),
                                DropdownMenuItem(
                                  value: 'millimeter',
                                  child: Text('millimeter'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextField(
                        onChanged: (value) {
                          item = value;
                        },
                        decoration: const InputDecoration(
                          hintText: 'Item',
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          input = null;
                        });
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          input = null;
                          if (amount.toString().length +
                                  unit.length +
                                  item.length <=
                              40) {
                            insertDatabase(amount, unit, item);
                          }
                        });
                        Navigator.pop(context);
                      },
                      child: const Text('Save'),
                    ),
                  ],
                );
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
