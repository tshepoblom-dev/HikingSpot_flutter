// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$myDriverProfileHash() => r'25e21fc7250351c2483ef14061064c783c215cd9';

/// See also [myDriverProfile].
@ProviderFor(myDriverProfile)
final myDriverProfileProvider =
    AutoDisposeFutureProvider<DriverResponse?>.internal(
  myDriverProfile,
  name: r'myDriverProfileProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$myDriverProfileHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MyDriverProfileRef = AutoDisposeFutureProviderRef<DriverResponse?>;
String _$publicDriverProfileHash() =>
    r'e8f3898e3aa0b2daf452c13d665b3b7fb19de82e';

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

/// See also [publicDriverProfile].
@ProviderFor(publicDriverProfile)
const publicDriverProfileProvider = PublicDriverProfileFamily();

/// See also [publicDriverProfile].
class PublicDriverProfileFamily extends Family<AsyncValue<DriverResponse>> {
  /// See also [publicDriverProfile].
  const PublicDriverProfileFamily();

  /// See also [publicDriverProfile].
  PublicDriverProfileProvider call(
    int driverProfileId,
  ) {
    return PublicDriverProfileProvider(
      driverProfileId,
    );
  }

  @override
  PublicDriverProfileProvider getProviderOverride(
    covariant PublicDriverProfileProvider provider,
  ) {
    return call(
      provider.driverProfileId,
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
  String? get name => r'publicDriverProfileProvider';
}

/// See also [publicDriverProfile].
class PublicDriverProfileProvider
    extends AutoDisposeFutureProvider<DriverResponse> {
  /// See also [publicDriverProfile].
  PublicDriverProfileProvider(
    int driverProfileId,
  ) : this._internal(
          (ref) => publicDriverProfile(
            ref as PublicDriverProfileRef,
            driverProfileId,
          ),
          from: publicDriverProfileProvider,
          name: r'publicDriverProfileProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$publicDriverProfileHash,
          dependencies: PublicDriverProfileFamily._dependencies,
          allTransitiveDependencies:
              PublicDriverProfileFamily._allTransitiveDependencies,
          driverProfileId: driverProfileId,
        );

  PublicDriverProfileProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.driverProfileId,
  }) : super.internal();

  final int driverProfileId;

  @override
  Override overrideWith(
    FutureOr<DriverResponse> Function(PublicDriverProfileRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PublicDriverProfileProvider._internal(
        (ref) => create(ref as PublicDriverProfileRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        driverProfileId: driverProfileId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<DriverResponse> createElement() {
    return _PublicDriverProfileProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PublicDriverProfileProvider &&
        other.driverProfileId == driverProfileId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, driverProfileId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PublicDriverProfileRef on AutoDisposeFutureProviderRef<DriverResponse> {
  /// The parameter `driverProfileId` of this provider.
  int get driverProfileId;
}

class _PublicDriverProfileProviderElement
    extends AutoDisposeFutureProviderElement<DriverResponse>
    with PublicDriverProfileRef {
  _PublicDriverProfileProviderElement(super.provider);

  @override
  int get driverProfileId =>
      (origin as PublicDriverProfileProvider).driverProfileId;
}

String _$driverProfileVMHash() => r'e3d8202bed0c8bc41f404ede09b2aa5906bd2b93';

/// See also [DriverProfileVM].
@ProviderFor(DriverProfileVM)
final driverProfileVMProvider = AutoDisposeNotifierProvider<DriverProfileVM,
    AsyncValue<DriverResponse?>>.internal(
  DriverProfileVM.new,
  name: r'driverProfileVMProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$driverProfileVMHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DriverProfileVM = AutoDisposeNotifier<AsyncValue<DriverResponse?>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
