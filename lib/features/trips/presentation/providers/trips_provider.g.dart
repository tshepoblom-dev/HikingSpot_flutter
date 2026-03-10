// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trips_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$tripDetailsHash() => r'd370eabbf5e4845fee1de8cd49b3643e4c284c81';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [tripDetails].
@ProviderFor(tripDetails)
const tripDetailsProvider = TripDetailsFamily();

/// See also [tripDetails].
class TripDetailsFamily extends Family<AsyncValue<TripResponse>> {
  /// See also [tripDetails].
  const TripDetailsFamily();

  /// See also [tripDetails].
  TripDetailsProvider call(
    int tripId,
  ) {
    return TripDetailsProvider(
      tripId,
    );
  }

  @override
  TripDetailsProvider getProviderOverride(
    covariant TripDetailsProvider provider,
  ) {
    return call(
      provider.tripId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'tripDetailsProvider';
}

/// See also [tripDetails].
class TripDetailsProvider extends AutoDisposeFutureProvider<TripResponse> {
  /// See also [tripDetails].
  TripDetailsProvider(
    int tripId,
  ) : this._internal(
          (ref) => tripDetails(
            ref as TripDetailsRef,
            tripId,
          ),
          from: tripDetailsProvider,
          name: r'tripDetailsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$tripDetailsHash,
          dependencies: TripDetailsFamily._dependencies,
          allTransitiveDependencies:
              TripDetailsFamily._allTransitiveDependencies,
          tripId: tripId,
        );

  TripDetailsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.tripId,
  }) : super.internal();

  final int tripId;

  @override
  Override overrideWith(
    FutureOr<TripResponse> Function(TripDetailsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TripDetailsProvider._internal(
        (ref) => create(ref as TripDetailsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        tripId: tripId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<TripResponse> createElement() {
    return _TripDetailsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TripDetailsProvider && other.tripId == tripId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, tripId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TripDetailsRef on AutoDisposeFutureProviderRef<TripResponse> {
  /// The parameter `tripId` of this provider.
  int get tripId;
}

class _TripDetailsProviderElement
    extends AutoDisposeFutureProviderElement<TripResponse> with TripDetailsRef {
  _TripDetailsProviderElement(super.provider);

  @override
  int get tripId => (origin as TripDetailsProvider).tripId;
}

String _$tripSearchStateHash() => r'7677b2f4c2a2805ce4e14686bfe7db5c9895c8f1';

/// See also [TripSearchState].
@ProviderFor(TripSearchState)
final tripSearchStateProvider =
    AutoDisposeNotifierProvider<TripSearchState, TripSearchParams>.internal(
  TripSearchState.new,
  name: r'tripSearchStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$tripSearchStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TripSearchState = AutoDisposeNotifier<TripSearchParams>;
String _$tripResultsHash() => r'34655d4d03d0b57c80564f6a4753c8571ab61247';

/// See also [TripResults].
@ProviderFor(TripResults)
final tripResultsProvider = AutoDisposeNotifierProvider<TripResults,
    AsyncValue<PagedResult<TripResponse>>>.internal(
  TripResults.new,
  name: r'tripResultsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$tripResultsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TripResults
    = AutoDisposeNotifier<AsyncValue<PagedResult<TripResponse>>>;
String _$myTripsHash() => r'490ca0ca01b74980eb4021178df4314cd927ffbf';

/// See also [MyTrips].
@ProviderFor(MyTrips)
final myTripsProvider =
    AutoDisposeAsyncNotifierProvider<MyTrips, List<TripResponse>>.internal(
  MyTrips.new,
  name: r'myTripsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$myTripsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MyTrips = AutoDisposeAsyncNotifier<List<TripResponse>>;
String _$createTripVMHash() => r'9c7501f1f1634409d5af4695137aadfc1333a372';

/// See also [CreateTripVM].
@ProviderFor(CreateTripVM)
final createTripVMProvider = AutoDisposeNotifierProvider<CreateTripVM,
    AsyncValue<TripResponse?>>.internal(
  CreateTripVM.new,
  name: r'createTripVMProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$createTripVMHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CreateTripVM = AutoDisposeNotifier<AsyncValue<TripResponse?>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
