import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rentables/rentables.dart';

/// Mocking the items bloc
class MockItemBloc extends Mock implements ItemBloc {}

void main() {
  BlocSupervisor.delegate = RentableBlocDelegate();
  group('Filter Bloc tests', (){
    Logger.level = Level.debug;

    var _searchParameters = {
      'abz7ki8d': {
        searchParameters.category: 'aonb8iks',
        searchParameters.searchTerm: 'Sterni Overall'},
      'l09nd81h': {
        searchParameters.category: 'hu9nd71k',
        searchParameters.searchTerm: 'Big brown bear'}
    };

    var mockItemBloc = MockItemBloc();

    when(mockItemBloc.add(LoadItemSearchParameters()))
        .thenAnswer((_) => ItemsSearchParametersLoaded(_searchParameters));

    when(mockItemBloc.state)
        .thenAnswer((_) => ItemsSearchParametersLoaded(_searchParameters));


    blocTest(
      'Initialize Bloc',
      build: () => FilteredItemsBloc(itemBloc: mockItemBloc),
      expect: [FilteredItemsLoaded(filteredItemIds: ['abz7ki8d', 'l09nd81h'],
          categoryIds: ['aonb8iks', 'hu9nd71k'],
          searchString: '')],
    );

    blocTest(
      'UpdateItems -> FilteredItemsLoaded',
      build: () => FilteredItemsBloc(itemBloc: mockItemBloc),
      act: (bloc) => bloc.add(UpdateItems([])),
      expect: [FilteredItemsLoaded(filteredItemIds: ['abz7ki8d', 'l09nd81h'],
          categoryIds: ['aonb8iks', 'hu9nd71k'],
          searchString: '')],
    );

    blocTest(
      'UpdateFilter -> FilteredItemsLoaded with result',
      build: () => FilteredItemsBloc(itemBloc: mockItemBloc),
      act: (bloc) => bloc.add(UpdateFilter(categoryIds: ['aonb8iks'],
          searchString: 'Overall')),
      expect: [FilteredItemsLoaded(filteredItemIds: ['abz7ki8d', 'l09nd81h'],
          categoryIds: ['aonb8iks', 'hu9nd71k'],
          searchString: ''),
        FilteredItemsLoaded(filteredItemIds: ['abz7ki8d'],
          categoryIds: ['aonb8iks'],
          searchString: 'Overall')],
    );

    blocTest(
      'UpdateFilter -> FilteredItemsLoaded with no result from searchstring',
      build: () => FilteredItemsBloc(itemBloc: mockItemBloc),
      act: (bloc) => bloc.add(UpdateFilter(categoryIds: ['aonb8iks'],
          searchString: 'brown bear')),
      expect: [FilteredItemsLoaded(filteredItemIds: ['abz7ki8d', 'l09nd81h'],
          categoryIds: ['aonb8iks', 'hu9nd71k'],
          searchString: ''),
        FilteredItemsLoaded(filteredItemIds: [],
          categoryIds: ['aonb8iks'],
          searchString: 'brown bear')],
    );

    blocTest(
      'UpdateFilter -> FilteredItemsLoaded with no result from category ID',
      build: () => FilteredItemsBloc(itemBloc: mockItemBloc),
      act: (bloc) => bloc.add(UpdateFilter(categoryIds: ['hu9nd71k'],
          searchString: 'Overall')),
      expect: [FilteredItemsLoaded(filteredItemIds: ['abz7ki8d', 'l09nd81h'],
          categoryIds: ['aonb8iks', 'hu9nd71k'],
          searchString: ''),
        FilteredItemsLoaded(filteredItemIds: [],
          categoryIds: ['aonb8iks'],
          searchString: 'Overall')],
    );

  });
}

