import 'package:bloc_test/bloc_test.dart';
import 'package:logger/logger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rentables/rentables.dart';

/// Mocking the database manager
class MockManager extends Mock implements DatabaseManager {}

void main() {
  group('Reservations Bloc tests', (){
    Logger.level = Level.debug;

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

    var mockManagerRemote = MockManager();
      when(mockManagerRemote.putReservations([testResRemote]))
      .thenAnswer((_) => Future.value());

    when(mockManagerRemote.getReservations(testItemRemote.id))
    .thenAnswer((_) => Future.value([testResRemote]));

    when(mockManagerRemote.getItems([testItemRemote.id]))
        .thenAnswer((_) => Future.value([testItemRemote]));

    var _resRepLocal = 
    Repository(localDatabaseManager: mockManagerLocal);
    var _resRepRemote = 
    Repository(remoteDatabaseManager: mockManagerRemote);

    blocTest(
    'Initialize Bloc',
    build: () => ReservationBlock(repository: _resRepLocal),
    expect: [ReservationsLoading()],
    );

    blocTest(
    'Loading from Cage -> Loaded',
    build: () => ReservationBlock(repository: _resRepLocal),
    act: (bloc) => bloc.add(LoadReservationsFromCage(testItemLocal)),
    expect: [ReservationsLoading(), ReservationsLoaded([testResLocal])],
    );
    
    blocTest(
    'Loading from Cage -> Loaded - Error',
    build: () => ReservationBlock(repository: _resRepRemote),
    act: (bloc) => bloc.add(LoadReservationsFromCage(testItemRemote)),
    expect: [ReservationsLoading(), ReservationsNotLoaded()],
    );

    blocTest(
    'Loading from Server -> Loaded',
    build: () => ReservationBlock(repository: _resRepRemote),
    act: (bloc) => bloc.add(LoadReservationsFromServer(testItemRemote)),
    expect: [ReservationsLoading(), ReservationsLoaded([testResRemote])],
    );

    blocTest(
    'Loading from Server -> Loaded - Error',
    build: () => ReservationBlock(repository: _resRepLocal),
    act: (bloc) => bloc.add(LoadReservationsFromServer(testItemLocal)),
    expect: [ReservationsLoading(), ReservationsNotLoaded()],
    );

    blocTest(
    'Add Reservation -> Loaded',
    build: () => ReservationBlock(repository: _resRepLocal),
    act: (bloc){
      bloc.add(LoadReservationsFromCage(testItemLocal));
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
      bloc.add(LoadReservationsFromCage(testItemLocal));
      bloc.add(AddReservation(testResLocal));
      return;
      },
    expect: [ReservationsLoading(), ReservationsLoaded([testResLocal]), 
    ReservationsInvalid()],
    );

    blocTest(
    'Update Reservation -> Loaded',
    build: () => ReservationBlock(repository: _resRepLocal),
    act: (bloc){
      bloc.add(LoadReservationsFromCage(testItemLocal));
      bloc.add(AddReservation(testResRemote));
      bloc.add(UpdateReservation(testResLocalUpdate, testing: true));
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
      bloc.add(LoadReservationsFromCage(testItemLocal));
      bloc.add(AddReservation(testResRemote));
      bloc.add(UpdateReservation(testResLocal));
      return;
      },
    expect: [ReservationsLoading(), ReservationsLoaded([testResLocal]), 
    ReservationsLoaded([testResLocal, testResRemote]),
    ReservationsInvalid()],
    );

    blocTest(
    'Delete Category -> Loaded',
    build: () => ReservationBlock(repository: _resRepLocal),
    act: (bloc){
      bloc.add(LoadReservationsFromCage(testItemLocal));
      bloc.add(AddReservation(testResRemote));
      bloc.add(DeleteReservation(testResLocal));
      return;
      },
    expect: [ReservationsLoading(), ReservationsLoaded([testResLocal]), 
    ReservationsLoaded([testResLocal, testResRemote]),
    ReservationsLoaded([testResRemote])],
    );
  });
}