import 'package:fuzzy/fuzzy.dart';

/// Length of the keys which are menat for human consumption
const int globalKeyLength = 6;

/// Minimum length of any rental
const Duration minimumRentalPeriod = Duration(days: 1);

/// Settings for the fuzzy-search used to search for items in the UI
FuzzyOptions fuzzySearchOptions = FuzzyOptions(
  distance: 90,
  findAllMatches: true,
  isCaseSensitive: false,
  matchAllTokens: true,
  minMatchCharLength: 3,
  shouldNormalize: true,
  threshold: 0.8,
  tokenize: true,
);