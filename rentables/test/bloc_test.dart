import 'package:bloc_test/bloc_test.dart';
import 'package:logger/logger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:rentables/rentables.dart';

/// Mocking the database manager
class MockManager extends Mock implements DatabaseManager {}

void main() {
  group('Category Bloc tests', (){
    Logger.level = Level.debug;

    var testCatLocal = Category(
      color: 'black',
      title: 'Local',
      icon: 'blender',
      location: 'Local',
    );
    var testCatRemote = Category(
      color: 'black',
      title: 'Remote',
      icon: 'blender',
      location: 'Remote',
    );
    var testCatRemoteUpdate = Category(
      color: 'black',
      title: 'Update',
      icon: 'blender',
      location: 'Remote',
    );
    testCatRemoteUpdate.id = testCatRemote.id;
    testCatRemoteUpdate.update();

    var mockManagerLocal = MockManager();
    when(mockManagerLocal.putCategories([testCatLocal]))
      .thenAnswer((_) => Future.value());

    when(mockManagerLocal.getCategories())
      .thenAnswer((_) => Future.value([testCatLocal]));

    var mockManagerRemote = MockManager();
      when(mockManagerRemote.putCategories([testCatRemote]))
      .thenAnswer((_) => Future.value());

    when(mockManagerRemote.getCategories())
    .thenAnswer((_) => Future.value([testCatRemote]));

    var _catRepLocal = 
    CategoryRepository(localDatabaseManager: mockManagerLocal);
    var _catRepRemote = 
    CategoryRepository(remoteDatabaseManager: mockManagerRemote);

    blocTest(
    'Initialize Bloc',
    build: () => CategoryBlock(categoryRepository: _catRepLocal),
    expect: [CategoriesLoading()],
    );

    blocTest(
    'Loading from Cage -> Loaded',
    build: () => CategoryBlock(categoryRepository: _catRepLocal),
    act: (bloc) => bloc.add(LoadCategoriesFromCage()),
    expect: [CategoriesLoading(), CategoriesLoaded([testCatLocal])],
    );

    blocTest(
    'Loading from Cage -> Loaded - Error',
    build: () => CategoryBlock(categoryRepository: _catRepRemote),
    act: (bloc) => bloc.add(LoadCategoriesFromCage()),
    expect: [CategoriesLoading(), CategoriesNotLoaded()],
    );

    blocTest(
    'Loading from Server -> Loaded',
    build: () => CategoryBlock(categoryRepository: _catRepRemote),
    act: (bloc) => bloc.add(LoadCategoriesFromServer()),
    expect: [CategoriesLoading(), CategoriesLoaded([testCatRemote])],
    );

    blocTest(
    'Loading from Server -> Loaded - Error',
    build: () => CategoryBlock(categoryRepository: _catRepLocal),
    act: (bloc) => bloc.add(LoadCategoriesFromServer()),
    expect: [CategoriesLoading(), CategoriesNotLoaded()],
    );

    blocTest(
    'Add Category -> Loaded',
    build: () => CategoryBlock(categoryRepository: _catRepLocal),
    act: (bloc){
      bloc.add(LoadCategoriesFromCage());
      bloc.add(AddCategory(testCatRemote));
      return;
      },
    expect: [CategoriesLoading(), CategoriesLoaded([testCatLocal]), 
    CategoriesLoaded([testCatLocal, testCatRemote])],
    );

    blocTest(
    'Update Category -> Loaded',
    build: () => CategoryBlock(categoryRepository: _catRepLocal),
    act: (bloc){
      bloc.add(LoadCategoriesFromCage());
      bloc.add(AddCategory(testCatRemote));
      bloc.add(UpdateCategory(testCatRemoteUpdate));
      return;
      },
    expect: [CategoriesLoading(), CategoriesLoaded([testCatLocal]), 
    CategoriesLoaded([testCatLocal, testCatRemote]),
    CategoriesLoaded([testCatLocal, testCatRemoteUpdate])],
    );

    blocTest(
    'Delete Category -> Loaded',
    build: () => CategoryBlock(categoryRepository: _catRepLocal),
    act: (bloc){
      bloc.add(LoadCategoriesFromCage());
      bloc.add(AddCategory(testCatRemote));
      bloc.add(DeleteCategory(testCatRemote));
      return;
      },
    expect: [CategoriesLoading(), CategoriesLoaded([testCatLocal]), 
    CategoriesLoaded([testCatLocal, testCatRemote]),
    CategoriesLoaded([testCatLocal])],
    );
  });



  group('Reservations Bloc tests', (){
    Logger.level = Level.debug;

    var testItemLocal = Item(
      title: 'Local',
      size: 'L',
      type: 'm',
      description: 'This is a test-item'
    );

    var testItemRemote = Item(
      title: 'Remote',
      size: 'L',
      type: 'm',
      description: 'This is a test-item'
    );

    var testResLocal = Reservation(
      employee: 'Jürgen Zuhause',
      item: testItemLocal,
      customerName: 'Ernst August',
      customerMail: 'ernst_august@neuland.de',
      customerPhone: '+49 3094 988 78 00',
      startDate: DateTime.utc(2020, 01, 01),
      endDate: DateTime.utc(2020, 01, 04)
    );

    var testResRemote = Reservation(
      employee: 'Jürgen in der großen Welt',
      item: testItemRemote,
      customerName: 'Ernst August',
      customerMail: 'ernst_august@neuland.de',
      customerPhone: '+49 3094 988 78 00',
      startDate: DateTime.utc(2021, 01, 01),
      endDate: DateTime.utc(2021, 01, 04)
    );

    var testResLocalUpdate = Reservation(
      employee: 'Jürgen hat was Neues',
      item: testItemLocal,
      customerName: 'Ernst August',
      customerMail: 'ernst_august@neuland.de',
      customerPhone: '+49 3094 988 78 00',
      startDate: DateTime.utc(2022, 01, 01),
      endDate: DateTime.utc(2022, 01, 04)
    );

    testResLocalUpdate.id = testResLocal.id;
    testResLocalUpdate.update();

    var mockManagerLocal = MockManager();
    when(mockManagerLocal.putReservations([testResLocal]))
      .thenAnswer((_) => Future.value());

    when(mockManagerLocal.getReservations(testItemLocal))
      .thenAnswer((_) => Future.value([testResLocal]));

    var mockManagerRemote = MockManager();
      when(mockManagerRemote.putReservations([testResRemote]))
      .thenAnswer((_) => Future.value());

    when(mockManagerRemote.getReservations(testItemRemote))
    .thenAnswer((_) => Future.value([testResRemote]));

    var _resRepLocal = 
    ReservationRepository(localDatabaseManager: mockManagerLocal);
    var _resRepRemote = 
    ReservationRepository(remoteDatabaseManager: mockManagerRemote);

    blocTest(
    'Initialize Bloc',
    build: () => ReservationBlock(reservationRepository: _resRepLocal),
    expect: [ReservationsLoading()],
    );

    blocTest(
    'Loading from Cage -> Loaded',
    build: () => ReservationBlock(reservationRepository: _resRepLocal),
    act: (bloc) => bloc.add(LoadReservationsFromCage(testItemLocal)),
    expect: [ReservationsLoading(), ReservationsLoaded([testResLocal])],
    );

    blocTest(
    'Loading from Cage -> Loaded - Error',
    build: () => ReservationBlock(reservationRepository: _resRepRemote),
    act: (bloc) => bloc.add(LoadReservationsFromCage(testItemLocal)),
    expect: [ReservationsLoading(), ReservationsNotLoaded()],
    );

    blocTest(
    'Loading from Server -> Loaded',
    build: () => ReservationBlock(reservationRepository: _resRepRemote),
    act: (bloc) => bloc.add(LoadReservationsFromServer(testItemRemote)),
    expect: [ReservationsLoading(), ReservationsLoaded([testResRemote])],
    );

    blocTest(
    'Loading from Server -> Loaded - Error',
    build: () => ReservationBlock(reservationRepository: _resRepLocal),
    act: (bloc) => bloc.add(LoadReservationsFromServer(testItemRemote)),
    expect: [ReservationsLoading(), ReservationsNotLoaded()],
    );

    blocTest(
    'Add Reservation -> Loaded',
    build: () => ReservationBlock(reservationRepository: _resRepLocal),
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
    build: () => ReservationBlock(reservationRepository: _resRepLocal),
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
    build: () => ReservationBlock(reservationRepository: _resRepLocal),
    act: (bloc){
      bloc.add(LoadReservationsFromCage(testItemLocal));
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
    build: () => ReservationBlock(reservationRepository: _resRepLocal),
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
    build: () => ReservationBlock(reservationRepository: _resRepLocal),
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