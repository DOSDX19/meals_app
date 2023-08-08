import 'package:flutter/material.dart';
import 'package:meals/data/dummy_data.dart';

import 'package:meals/screens/categories.dart';
import 'package:meals/screens/filters.dart';
import 'package:meals/screens/meals.dart';
import 'package:meals/models/meal.dart';
import 'package:meals/widgets/main_drawer.dart';

const kInitialFilters = {
  Filter.glutenFree: false,
  Filter.lactosFree: false,
  Filter.vegetarianFree: false,
  Filter.veganFree: false
};

class TabsScreen extends StatefulWidget {
  const TabsScreen({Key key}) : super(key: key);

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  var _selectPageIndex = 0;
  final List<Meal> _favoriteMeals = [];

  var _selectedFilters = kInitialFilters;

  void _showMessageInfo(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _toggleMealFavoriteStatus(Meal meal) {
    final isExist = _favoriteMeals.contains(meal);

    if (isExist) {
      setState(() {
        _favoriteMeals.remove(meal);
      });
      _showMessageInfo('Meal is longer a favorite!');
    } else {
      setState(() {
        _favoriteMeals.add(meal);
      });
      _showMessageInfo('Marked as a favorite!');
    }
  }

  void _selectPage(index) {
    setState(() {
      _selectPageIndex = index;
    });
  }

  void _setScreen(String identifier) async {
    Navigator.of(context).pop();

    if (identifier == "filters") {
      final result = await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
          builder: ((context) => FiltersScreen(
                currentFilters: _selectedFilters,
              )),
        ),
      );

      setState(() {
        _selectedFilters = result ?? kInitialFilters;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableMeals = dummyMeals.where((meal) {
      if (_selectedFilters[Filter.glutenFree] && !meal.isGlutenFree) {
        return false;
      }
      if (_selectedFilters[Filter.lactosFree] && !meal.isLactoseFree) {
        return false;
      }
      if (_selectedFilters[Filter.vegetarianFree] && !meal.isVegetarian) {
        return false;
      }
      if (_selectedFilters[Filter.veganFree] && !meal.isVegan) {
        return false;
      }
      return true;
    }).toList();

    Widget activePage = CategoriesScreen(
      onToggleFavorite: _toggleMealFavoriteStatus,
      availableMeals: availableMeals,
    );
    var pageTitle = 'Categories';

    if (_selectPageIndex == 1) {
      activePage = MealsScreen(
        meals: _favoriteMeals,
        onToggleFavorite: _toggleMealFavoriteStatus,
      );
      pageTitle = 'Your favorites';
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitle),
      ),
      drawer: MainDrawer(
        onSelectScreen: _setScreen,
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectPageIndex,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.set_meal), label: 'Categories'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.star,
              ),
              label: 'Farorites')
        ],
      ),
    );
  }
}
