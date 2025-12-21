// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ProfileManager)
const profileManagerProvider = ProfileManagerProvider._();

final class ProfileManagerProvider
    extends $AsyncNotifierProvider<ProfileManager, Profile> {
  const ProfileManagerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'profileManagerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$profileManagerHash();

  @$internal
  @override
  ProfileManager create() => ProfileManager();
}

String _$profileManagerHash() => r'2a07ad739593da496df5898ac7b9ec91aa42e196';

abstract class _$ProfileManager extends $AsyncNotifier<Profile> {
  FutureOr<Profile> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<Profile>, Profile>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<Profile>, Profile>,
        AsyncValue<Profile>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
