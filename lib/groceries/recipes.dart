import 'package:flutter/material.dart';
import 'database.dart';
import 'package:url_launcher/url_launcher.dart';

class Recipes extends StatefulWidget {
  const Recipes({Key? key}) : super(key: key);

  @override
  State<Recipes> createState() => _RecipesState();
}

class _RecipesState extends State<Recipes> {
  _launchRecipe1() async {
    final Uri url = Uri.parse(
      'https://docs.google.com/document/d/1_IJvzSoPEuKVFw-v8Clj9CAdlI6bfgc8WT6VTU1BQgg/edit',
    );
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('The link could not be opened.');
    }
  }

  _launchRecipe2() async {
    final Uri url = Uri.parse(
      'https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.1290.pdf#page=2',
    );
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('The link could not be opened.');
    }
  }

  _launchRecipe3() async {
    final Uri url = Uri.parse(
      'https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.1290.pdf#page=3',
    );
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('The link could not be opened.');
    }
  }

  _launchRecipe4() async {
    final Uri url = Uri.parse(
      'https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.1290.pdf#page=4',
    );
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('The link could not be opened.');
    }
  }

  _launchRecipe5() async {
    final Uri url = Uri.parse(
      'https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.1290.pdf#page=5',
    );
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('The link could not be opened.');
    }
  }

  _launchRecipe6() async {
    final Uri url = Uri.parse(
      'https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.1290.pdf#page=6',
    );
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('The link could not be opened.');
    }
  }

  insertDatabase(double amount, String unit, String item) {
    IngredientsDatabaseHelper.instance.insertIngredient({
      IngredientsDatabaseHelper.colAmount: amount,
      IngredientsDatabaseHelper.colUnit: unit,
      IngredientsDatabaseHelper.colItem: item,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: ListView(
          children: [
            Card(
              child: ListTile(
                title: const Text('Edible Cookie Dough Sampler'),
                onTap: () {
                  setState(() {
                    insertDatabase(410, 'gram', 'all-purpose flour');
                    insertDatabase(340, 'gram', 'softened unsalted butter');
                    insertDatabase(330, 'gram', 'light brown sugar');
                    insertDatabase(120, 'gram', 'granulated sugar');
                    insertDatabase(4.8, 'gram', 'salt');
                    insertDatabase(69, 'gram', 'milk');
                    insertDatabase(6.5, 'gram', 'vanilla extract');
                    insertDatabase(82, 'gram', 'semi-sweet chocolate chips');
                    insertDatabase(52, 'gram', 'white chocolate chips');
                    insertDatabase(36, 'gram', 'rainbow sprinkles');
                    insertDatabase(8, '', 'roughly chopped Oreo cookies');
                  });
                  Navigator.pushNamed(context, '/groceries');
                },
                onLongPress: _launchRecipe1,
              ),
            ),
            Card(
              child: ListTile(
                title: const Text('Apple Crisp'),
                onTap: () {
                  setState(() {
                    insertDatabase(6, '', 'apples');
                    insertDatabase(25, 'gram', 'granulated sugar');
                    insertDatabase(5, 'gram', 'cinnamon powder');
                    insertDatabase(5, 'gram', 'vanilla extract');
                    insertDatabase(5, 'gram', 'lemon juice');
                    insertDatabase(100, 'gram', 'old fashioned oats');
                    insertDatabase(210, 'gram', 'light brown sugar');
                    insertDatabase(100, 'gram', 'all-purpose flour');
                    insertDatabase(110, 'gram', 'unsalted butter');
                    insertDatabase(5, 'gram', 'salt');
                  });
                  Navigator.pushNamed(context, '/groceries');
                },
                onLongPress: _launchRecipe2,
              ),
            ),
            Card(
              child: ListTile(
                title: const Text('Banana Bread'),
                onTap: () {
                  setState(() {
                    insertDatabase(260, 'gram', 'all-purpose flour');
                    insertDatabase(200, 'gram', 'sugar');
                    insertDatabase(6, 'gram', 'baking soda');
                    insertDatabase(3, 'gram', 'salt');
                    insertDatabase(225, 'gram', 'banana');
                    insertDatabase(2, '', 'large eggs');
                    insertDatabase(100, 'gram', 'vegetable oil');
                    insertDatabase(55, 'gram', 'whole milk');
                    insertDatabase(5, 'gram', 'vanilla extract');
                    insertDatabase(100, 'gram', 'chocolate chips');
                  });
                  Navigator.pushNamed(context, '/groceries');
                },
                onLongPress: _launchRecipe3,
              ),
            ),
            Card(
              child: ListTile(
                title: const Text('Chocolate Chip Cookies'),
                onTap: () {
                  setState(() {
                    insertDatabase(360, 'gram', 'all-purpose flour');
                    insertDatabase(5, 'gram', 'baking soda');
                    insertDatabase(5, 'gram', 'salt');
                    insertDatabase(230, 'gram', 'softened unsalted butter');
                    insertDatabase(200, 'gram', 'granulated sugar');
                    insertDatabase(200, 'gram', 'light brown sugar');
                    insertDatabase(10, 'gram', 'vanilla extract');
                    insertDatabase(2, '', 'large eggs');
                    insertDatabase(350, 'gram', 'chocolate chips');
                  });
                  Navigator.pushNamed(context, '/groceries');
                },
                onLongPress: _launchRecipe4,
              ),
            ),
            Card(
              child: ListTile(
                title: const Text('Macaroni and Cheese'),
                onTap: () {
                  setState(() {
                    insertDatabase(450, 'gram', 'dry elbow pasta');
                    insertDatabase(10, 'gram', 'salt');
                    insertDatabase(110, 'gram', 'unsalted butter');
                    insertDatabase(60, 'gram', 'all-purpose flutter');
                    insertDatabase(1000, 'gram', 'whole milk');
                    insertDatabase(370, 'gram', 'shredded cheddar cheese');
                    insertDatabase(110, 'gram', 'shredded parmesan cheese');
                    insertDatabase(1, 'gram', 'paprika');
                    insertDatabase(1, 'gram', 'pepper');
                    insertDatabase(10, 'gram', 'salt');
                  });
                  Navigator.pushNamed(context, '/groceries');
                },
                onLongPress: _launchRecipe5,
              ),
            ),
            Card(
              child: ListTile(
                title: const Text('Waffles'),
                onTap: () {
                  setState(() {
                    insertDatabase(250, 'gram', 'all-purpose flour');
                    insertDatabase(15, 'gram', 'white sugar');
                    insertDatabase(8, 'gram', 'baking powder');
                    insertDatabase(3, 'gram', 'baking soda');
                    insertDatabase(5, 'gram', 'salt');
                    insertDatabase(4, '', 'large eggs');
                    insertDatabase(250, 'gram', 'milk');
                    insertDatabase(250, 'gram', 'plain yogurt');
                    insertDatabase(80, 'gram', 'melted unsalted butter');
                    insertDatabase(5, 'gram', 'vanilla extract');
                  });
                  Navigator.pushNamed(context, '/groceries');
                },
                onLongPress: _launchRecipe6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
