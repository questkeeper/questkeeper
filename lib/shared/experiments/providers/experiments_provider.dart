import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'experiments_provider.g.dart';

enum Experiments {
  spacesUnassignedDisabled,
  spacesTodayViewEnabled,
}

@riverpod
class ExperimentsManager extends _$ExperimentsManager {
  static const _prefPrefix = 'experiment_';
  late final SharedPreferences _prefs;

  @override
  FutureOr<Set<Experiments>> build() async {
    _prefs = await SharedPreferences.getInstance();
    return _loadExperiments();
  }

  Set<Experiments> _loadExperiments() {
    return Experiments.values
        .where((exp) => _prefs.getBool('$_prefPrefix${exp.name}') ?? false)
        .toSet();
  }

  Future<void> enableExperiment(Experiments experiment) async {
    await _prefs.setBool('$_prefPrefix${experiment.name}', true);
    state = AsyncData(_loadExperiments());
  }

  Future<void> disableExperiment(Experiments experiment) async {
    await _prefs.setBool('$_prefPrefix${experiment.name}', false);
    state = AsyncData(_loadExperiments());
  }

  bool isEnabled(Experiments experiment) {
    return state.valueOrNull?.contains(experiment) ?? false;
  }
}
