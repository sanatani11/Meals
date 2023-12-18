import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/providers/meals_provider.dart';

enum Filter {
  glutenFree,
  lactoseFree,
  vegitarian,
  vegan,
}

class FiltersNotifier extends StateNotifier<Map<Filter, bool>> {
  FiltersNotifier()
      : super({
          Filter.glutenFree: false,
          Filter.lactoseFree: false,
          Filter.vegitarian: false,
          Filter.vegan: false,
        });
  void setFilter(Filter filter, bool isActive){
    state = {
      ...state, 
      filter : isActive
    };
  }
  void setFilters(Map<Filter, bool>chosenFilter){
    state = chosenFilter;
  }
}

final filtersProvider =
    StateNotifierProvider<FiltersNotifier, Map<Filter, bool>>(
        (ref) => FiltersNotifier());

final filteredMealsProvider = Provider((ref) {
  final meals = ref.watch(mealsProvider);
  final activeFilter = ref.watch(filtersProvider);
  return meals.where((meal){
      if(activeFilter[Filter.glutenFree]! && !meal.isGlutenFree){
        return false;
      }
      if(activeFilter[Filter.lactoseFree]! && !meal.isLactoseFree){
        return false;
      }
      if(activeFilter[Filter.vegitarian]! && !meal.isVegetarian){
        return false;
      }
      if(activeFilter[Filter.vegan]! && !meal.isVegan){
        return false;
      }
      return true;
    }).toList();
});
