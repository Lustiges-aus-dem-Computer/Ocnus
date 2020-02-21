import 'dart:typed_data';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rentables/rentables.dart';

/// Mocking the filter bloc
class MockFilterBloc extends Mock implements FilteredItemsBloc {}
/// Mocking the repository
class MockRepository extends Mock implements Repository {}

void main() {
  BlocSupervisor.delegate = RentableBlocDelegate();
  group('Thumbnails Bloc tests', (){
    Logger.level = Level.debug;

    var mockFilterBloc = MockFilterBloc();

    when(mockFilterBloc.state)
        .thenAnswer((_) => FilteredItemsLoaded(
      filteredItemIds: ['aunk89hr', '97j3ntz8', '798j27hu',
        '9knbz14f', 'op09snz7'],
      searchString: 'Search',
      categoryIds: ['uionjd87']
    ));

    var thumbnails = Uint8List(2);

    var mockRepository = MockRepository();

    when(mockRepository.loadThumbnails(['aunk89hr', '97j3ntz8', '798j27hu',
      '9knbz14f'])).thenAnswer((_)
    => Future.value([thumbnails, thumbnails,
      thumbnails, thumbnails]));

    when(mockRepository.loadThumbnails(['aunk89hr', '97j3ntz8', '798j27hu',
      '9knbz14f', 'op09snz7'])).thenAnswer((_)
    => Future.value([thumbnails, thumbnails,
      thumbnails, thumbnails, thumbnails]));

    blocTest(
      'Initialize Bloc',
      build: () => ThumbnailsBloc(filteredItemsBloc: mockFilterBloc,
      repository: mockRepository),
      expect: [ThumbnailsLoaded(
          thumbnails: Future.value([thumbnails, thumbnails,
            thumbnails, thumbnails]), nItems: 4)],
    );

    blocTest(
      'Load one additional thumbnail',
      build: () => ThumbnailsBloc(filteredItemsBloc: mockFilterBloc,
          repository: mockRepository),
      act: (bloc) => bloc.add(LoadThumbnails(1)),
      expect: [
        ThumbnailsLoaded(
            thumbnails: Future.value([thumbnails, thumbnails,
              thumbnails, thumbnails]), nItems: 4),
        ThumbnailsLoaded(
          thumbnails: Future.value([thumbnails, thumbnails,
            thumbnails, thumbnails, thumbnails]), nItems: 5)],
    );
  });
}

