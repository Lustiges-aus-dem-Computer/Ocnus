import 'dart:typed_data';
import 'package:bloc_test/bloc_test.dart';
import 'package:logger/logger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rentables/rentables.dart';
import 'package:rentables/src/services/connectivity.dart';

/// Mocking the DNS service
class MockDNS extends Mock {
  /// Mocked DNS package returned from the server
  Future<DnsPacket> lookupPacket(String _);
}

class Answer{
  String name;
  Answer(this.name);
}

class DnsPacket{
  bool isResponse;
  List<Answer> answers;

  DnsPacket(this.answers, {this.isResponse});
}

/// Mocking the database manager
class MockManager extends Mock implements DatabaseManager {}

void main() {
  group('Detail Images Bloc tests', ()
  {
    Logger.level = Level.debug;

    var _validAnswers = [Answer('google.com')];
    var _invalidAnswers = [null];

    var _validPacket = DnsPacket(_validAnswers, isResponse: true);
    var _invalidPacket = DnsPacket(_invalidAnswers, isResponse: false);

    var validMockDNS = MockDNS();
    when(validMockDNS.lookupPacket('google.com'))
        .thenAnswer((_) => Future.value(_validPacket));

    var invalidMockDNS = MockDNS();
    when(invalidMockDNS.lookupPacket('google.com'))
        .thenAnswer((_) => Future.value(_invalidPacket));

    var offlineConnect = Connectivity(client: invalidMockDNS);

    var imageKey = 'uj894nh9';
    var testItem = Item(
        created: DateTime.now(),
        modified: DateTime.now(),
        id: LocalIdGenerator().getId(),
        title: 'Local',
        size: 'L',
        type: 'm',
        description: 'This is a test-item',
        images: [imageKey],
    );
    var imageBytes =  Uint8List(1234);

    var mockManager = MockManager();
    when(mockManager.putItems([testItem]))
        .thenAnswer((_) => Future.value());
    when(mockManager.getItems([testItem.id]))
        .thenAnswer((_) =>
        Future.value([testItem.copyWith(images: [imageKey])]));
    when(mockManager.putImages(keys: [imageKey],
        imageBytes: [imageBytes], thumbnail: false))
        .thenAnswer((_) => Future.value());
    when(mockManager.deleteImages([imageKey], thumbnail: false))
        .thenAnswer((_) => Future.value());
    when(mockManager.getImages([imageKey], thumbnail: false))
      .thenAnswer((_) => Future.value([imageBytes]));

    var mockManagerError = MockManager();
    when(mockManagerError.putItems([testItem]))
        .thenAnswer((_) => throw Exception('Error'));
    when(mockManagerError.putImages(keys: [imageKey],
        imageBytes: [imageBytes], thumbnail: false))
        .thenAnswer((_) => throw Exception('Error'));
    when(mockManagerError.getItems([testItem.id]))
        .thenAnswer((_) =>
        Future.value([testItem.copyWith(images: [imageKey])]));
    when(mockManagerError.deleteImages([imageKey], thumbnail: false))
        .thenAnswer((_) => throw Exception('Error'));
    when(mockManagerError.getImages([imageKey], thumbnail: false))
        .thenAnswer((_) => Future.value([imageBytes]));

    var mockManagerErrorLoad = MockManager();
    when(mockManagerErrorLoad.putItems([testItem]))
        .thenAnswer((_) => throw Exception('Error'));
    when(mockManagerErrorLoad.getItems([testItem.id]))
        .thenAnswer((_) => throw Exception('Error'));
    when(mockManagerErrorLoad.getImages([imageKey], thumbnail: false))
        .thenAnswer((_) => throw Exception('Error'));

    var _imgRepError=
    Repository(
        connectivity: offlineConnect,
        localDatabaseManager: mockManagerError);
    var _imgRepErrorLoad =
    Repository(
        connectivity: offlineConnect,
        localDatabaseManager: mockManagerErrorLoad);
    var _imgRep =
    Repository(
        connectivity: offlineConnect,
        localDatabaseManager: mockManager);

    blocTest(
      'Loading -> Error',
      build: () => DetailImagesBloc(repository: _imgRepErrorLoad),
      act: (bloc) => bloc.add(LoadDetailImages(testItem.id)),
      expect: [DetailImagesLoading(), DetailImagesNotLoaded()],
    );
    blocTest(
      'Loading -> Loaded',
      build: () => DetailImagesBloc(repository: _imgRep),
      act: (bloc) => bloc.add(LoadDetailImages(testItem.id)),
      expect: [DetailImagesLoading(),
        DetailImagesLoaded(detailImagesList: [imageBytes],
            itemId: testItem.id)],
    );
    blocTest(
      'Add Image -> Added',
      build: () => DetailImagesBloc(repository: _imgRep),
      act: (bloc){
        bloc.add(LoadDetailImages(testItem.id));
        bloc.add(AddDetailImage(image: imageBytes, itemId: testItem.id));
        return;
      },
      expect: [DetailImagesLoading(),
        DetailImagesLoaded(detailImagesList: [imageBytes],
            itemId: testItem.id),
        DetailImagesLoaded(detailImagesList: [imageBytes, imageBytes],
            itemId: testItem.id)],
    );
    blocTest(
      'Add Image -> Error',
      build: () => DetailImagesBloc(repository: _imgRepError),
      act: (bloc){
        bloc.add(LoadDetailImages(testItem.id));
        bloc.add(AddDetailImage(image: imageBytes, itemId: testItem.id,
            imIdTest: imageKey));
        return;
      },
      expect: [DetailImagesLoading(),
        DetailImagesLoaded(detailImagesList: [imageBytes],
            itemId: testItem.id),
        DetailImagesUpdateFailed()],
    );
    blocTest(
      'Delete Image -> Deleted',
      build: () => DetailImagesBloc(repository: _imgRep),
      act: (bloc){
        bloc.add(LoadDetailImages(testItem.id));
        bloc.add(DeleteDetailImage(imageId: testItem.images[0],
            itemId: testItem.id));
        return;
      },
      expect: [DetailImagesLoading(),
        DetailImagesLoaded(detailImagesList: [imageBytes],
            itemId: testItem.id),
        DetailImagesLoaded(detailImagesList: [],
            itemId: testItem.id)],
    );
    blocTest(
      'Delete Image -> Error',
      build: () => DetailImagesBloc(repository: _imgRepError),
      act: (bloc){
        bloc.add(LoadDetailImages(testItem.id));
        bloc.add(DeleteDetailImage(imageId: testItem.images[0],
            itemId: testItem.id));
        return;
      },
      expect: [DetailImagesLoading(),
        DetailImagesLoaded(detailImagesList: [imageBytes],
            itemId: testItem.id),
        DetailImagesUpdateFailed()],
    );
  });

}