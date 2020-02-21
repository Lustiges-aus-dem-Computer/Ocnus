import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  BlocSupervisor.delegate = RentableBlocDelegate();
  group('Reservations Bloc tests', (){
    Logger.level = Level.debug;

    var _validAnswers = [Answer('google.com')];
    var _invalidAnswers = [null];

    var _validPacket = DnsPacket(_validAnswers, isResponse: true);
    var _invalidPacket= DnsPacket(_invalidAnswers, isResponse: false);

    var validMockDNS = MockDNS();
    when(validMockDNS.lookupPacket('google.com'))
        .thenAnswer((_) => Future.value(_validPacket));

    var invalidMockDNS = MockDNS();
    when(invalidMockDNS.lookupPacket('google.com'))
        .thenAnswer((_) => Future.value(_invalidPacket));

    var offlineConnect = Connectivity(client: invalidMockDNS);

    var testItemLocal = Item(
        created: DateTime.now(),
        modified: DateTime.now(),
        id: LocalIdGenerator().getId(),
        title: 'Local',
        size: 'L',
        type: 'm',
        description: 'This is a test-item',
        images: [],
    );

    var testItemRemote = Item(
        created: DateTime.now(),
        modified: DateTime.now(),
        id: LocalIdGenerator().getId(),
        title: 'Remote',
        size: 'L',
        type: 'm',
        description: 'This is a test-item',
        images: [],
    );

    var testResLocal = Reservation(
        created: DateTime.now(),
        modified: DateTime.now(),
        id: LocalIdGenerator().getId(),
        employee: 'Jürgen Zuhause',
        itemId: testItemLocal.id,
        customerName: 'Ernst August',
        customerMail: 'ernst_august@neuland.de',
        customerPhone: '+49 3094 988 78 00',
        startDate: DateTime.utc(2020, 01, 01),
        endDate: DateTime.utc(2020, 01, 04)
    );

    var testResLocalConflict = Reservation(
        created: DateTime.now(),
        modified: DateTime.now(),
        id: LocalIdGenerator().getId(),
        employee: 'Jürgen Zuhause',
        itemId: testItemLocal.id,
        customerName: 'Ernst August',
        customerMail: 'ernst_august@neuland.de',
        customerPhone: '+49 3094 988 78 00',
        startDate: DateTime.utc(2020, 01, 02),
        endDate: DateTime.utc(2020, 01, 06)
    );

    var testResRemote = Reservation(
        created: DateTime.now(),
        modified: DateTime.now(),
        id: LocalIdGenerator().getId(),
        employee: 'Jürgen in der großen Welt',
        itemId: testItemRemote.id,
        customerName: 'Ernst August',
        customerMail: 'ernst_august@neuland.de',
        customerPhone: '+49 3094 988 78 00',
        startDate: DateTime.utc(2021, 01, 01),
        endDate: DateTime.utc(2021, 01, 04)
    );

    var testResLocalUpdate = Reservation(
        created: DateTime.now(),
        modified: DateTime.now(),
        id: LocalIdGenerator().getId(),
        employee: 'Jürgen hat was Neues',
        itemId: testItemLocal.id,
        customerName: 'Ernst August',
        customerMail: 'ernst_august@neuland.de',
        customerPhone: '+49 3094 988 78 00',
        startDate: DateTime.utc(2022, 01, 01),
        endDate: DateTime.utc(2022, 01, 04)
    );

    testItemLocal = testItemLocal.copyWith(reservations: [testResLocal.id]);
    testItemRemote = testItemRemote.copyWith(reservations: [testResRemote.id]);

    /// Ensure the Updated reservation has a different modified date
    Future.delayed(Duration(milliseconds: 50));

    testResLocalUpdate = testResLocal.copyWith();

    var mockManagerLocal = MockManager();
    when(mockManagerLocal.putReservations([testResLocal]))
      .thenAnswer((_) => Future.value());

    when(mockManagerLocal.getReservations(testItemLocal.id))
      .thenAnswer((_) => Future.value([testResLocal]));

    when(mockManagerLocal.getItems([testItemLocal.id]))
        .thenAnswer((_) => Future.value([testItemLocal]));

    when(mockManagerLocal.getItems([testItemRemote.id]))
        .thenAnswer((_) => Future.value([testItemRemote]));

    when(mockManagerLocal.getItems())
        .thenAnswer((_) => Future.value([testItemLocal]));

    var mockManagerLocalError= MockManager();
    when(mockManagerLocalError.putReservations([testResLocal]))
        .thenAnswer((_) => throw Exception('Error'));

    when(mockManagerLocalError.putReservations([testResRemote]))
        .thenAnswer((_) => throw Exception('Error'));

    when(mockManagerLocalError.putReservations([testResLocalUpdate]))
        .thenAnswer((_) => throw Exception('Error'));

    when(mockManagerLocalError.getReservations(testItemLocal.id))
        .thenAnswer((_) => Future.value([testResLocal]));

    when(mockManagerLocalError.deleteReservations([testResLocal.id]))
        .thenAnswer((_) => throw Exception('Error'));

    when(mockManagerLocalError.deleteReservations([testResRemote.id]))
        .thenAnswer((_) => throw Exception('Error'));

    when(mockManagerLocalError.getItems([testItemLocal.id]))
        .thenAnswer((_) => Future.value([testItemLocal]));

    when(mockManagerLocalError.getItems([testItemRemote.id]))
        .thenAnswer((_) => Future.value([testItemRemote]));

    when(mockManagerLocalError.getItems())
        .thenAnswer((_) => Future.value([testItemLocal]));

    var mockManagerLocalLoadError= MockManager();
    when(mockManagerLocalLoadError.getItems([testItemLocal.id]))
        .thenAnswer((_) => throw Exception('Error'));
    when(mockManagerLocalLoadError.getReservations(testItemLocal.id))
        .thenAnswer((_) => throw Exception('Error'));

    var _resRepLocalError =
    Repository(
        connectivity: offlineConnect,
        localDatabaseManager: mockManagerLocalError);
    var _resRepLocal = 
    Repository(
        connectivity: offlineConnect,
        localDatabaseManager: mockManagerLocal);
    var _itemRepLocalLoadError =
    Repository(
        connectivity: offlineConnect,
        localDatabaseManager: mockManagerLocalLoadError);

    blocTest(
    'Initialize Bloc',
    build: () => ReservationBlock(repository: _resRepLocal),
    expect: [ReservationsLoading()],
    );

    blocTest(
    'Loading from Cage -> Loaded',
    build: () => ReservationBlock(repository: _resRepLocal),
    act: (bloc) => bloc.add(LoadReservations(testItemLocal)),
    expect: [ReservationsLoading(), ReservationsLoaded([testResLocal])],
    );
    
    blocTest(
    'Loading from Cage -> Loaded - Error',
    build: () => ReservationBlock(repository: _itemRepLocalLoadError),
    act: (bloc) => bloc.add(LoadReservations(testItemLocal)),
    expect: [ReservationsLoading(), ReservationsNotLoaded()],
    );

    blocTest(
    'Add Reservation -> Loaded',
    build: () => ReservationBlock(repository: _resRepLocal),
    act: (bloc){
      bloc.add(LoadReservations(testItemLocal));
      bloc.add(AddReservation(testResRemote));
      return;
      },
    expect: [ReservationsLoading(), ReservationsLoaded([testResLocal]), 
    ReservationsLoaded([testResLocal, testResRemote])],
    );

    blocTest(
    'Add Reservation -> Invalid',
    build: () => ReservationBlock(repository: _resRepLocal),
    act: (bloc){
      bloc.add(LoadReservations(testItemLocal));
      bloc.add(AddReservation(testResLocalConflict));
      return;
      },
    expect: [ReservationsLoading(), ReservationsLoaded([testResLocal]), 
    ReservationsInvalid()],
    );

    blocTest(
      'Add Reservation -> Failed',
      build: () => ReservationBlock(repository: _resRepLocalError),
      act: (bloc){
        bloc.add(LoadReservations(testItemLocal));
        bloc.add(AddReservation(testResRemote));
        return;
      },
      expect: [ReservationsLoading(), ReservationsLoaded([testResLocal]),
        ReservationsUpdateFailed()],
    );

    blocTest(
    'Update Reservation -> Loaded',
    build: () => ReservationBlock(repository: _resRepLocal),
    act: (bloc){
      bloc.add(LoadReservations(testItemLocal));
      bloc.add(AddReservation(testResRemote));
      bloc.add(UpdateReservation(testResLocalUpdate));
      return;
      },
    expect: [ReservationsLoading(), ReservationsLoaded([testResLocal]), 
    ReservationsLoaded([testResLocal, testResRemote]),
    ReservationsLoaded([testResLocalUpdate, testResRemote])],
    );

    blocTest(
    'Update Reservation -> Invalid',
    build: () => ReservationBlock(repository: _resRepLocal),
    act: (bloc){
      bloc.add(LoadReservations(testItemLocal));
      bloc.add(AddReservation(testResRemote));
      bloc.add(UpdateReservation(testResLocalConflict));
      return;
      },
    expect: [ReservationsLoading(), ReservationsLoaded([testResLocal]), 
    ReservationsLoaded([testResLocal, testResRemote]),
    ReservationsInvalid()],
    );

    blocTest(
      'Update Reservation -> Failed',
      build: () => ReservationBlock(repository: _resRepLocalError),
      act: (bloc){
        bloc.add(LoadReservations(testItemLocal));
        bloc.add(UpdateReservation(testResLocalUpdate));
        return;
      },
      expect: [ReservationsLoading(), ReservationsLoaded([testResLocal]),
        ReservationsUpdateFailed()],
    );

    blocTest(
    'Delete Reservation -> Loaded',
    build: () => ReservationBlock(repository: _resRepLocal),
    act: (bloc){
      bloc.add(LoadReservations(testItemLocal));
      bloc.add(AddReservation(testResRemote));
      bloc.add(DeleteReservation(testResLocal));
      return;
      },
    expect: [ReservationsLoading(), ReservationsLoaded([testResLocal]), 
    ReservationsLoaded([testResLocal, testResRemote]),
    ReservationsLoaded([testResRemote])],
    );

    blocTest(
      'Delete Reservation -> Failed',
      build: () => ReservationBlock(repository: _resRepLocalError),
      act: (bloc){
        bloc.add(LoadReservations(testItemLocal));
        bloc.add(DeleteReservation(testResLocal));
        return;
      },
      expect: [ReservationsLoading(), ReservationsLoaded([testResLocal]),
        ReservationsUpdateFailed()],
    );
  });
}