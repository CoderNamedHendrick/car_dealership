part of 'ui_state.dart';

class _MutexRequest {
  final Completer<void> completer = Completer();
}

class _Atom {
  int _semaphore = 1;
  final _waiting = <_MutexRequest>[];

  bool get isLocked => _semaphore <= 0;
}

@visibleForTesting
class UiStateMutex {
  final _atoms = <String, _Atom>{};

  bool get atomsCleared => _atoms.isEmpty;

  _Atom _atom(String id) {
    if (_atoms[id] == null) throw StateError('failed to create atom');

    return _atoms[id]!;
  }

  Future<R> protect<R>(Future<R> Function() criticalSection) async {
    return await _protectWriteForId(criticalSection, R.toString());
  }

  Future<R> _protectWriteForId<R>(
      Future<R> Function() criticalSection, String id) async {
    _atoms.putIfAbsent(id, () => _Atom());
    await _waitWithId(id);
    try {
      return await criticalSection();
    } finally {
      _signalWithId(id);
    }
  }

  Future<void> _waitWithId(String id) async {
    final job = _MutexRequest();
    // if atom is locked
    if (!_jobAcquiredWithId(job, id)) {
      _atom(id)._waiting.add(job);
    }

    return job.completer.future;
  }

  void _signalWithId(String id) {
    _atom(id)._semaphore++; // unlock

    while (_atom(id)._waiting.isNotEmpty) {
      final nextJob = _atom(id)._waiting.first;
      // if the next job completes
      if (_jobAcquiredWithId(nextJob, id)) {
        _atom(id)._waiting.removeAt(0); // remove the entry
      } else {
        break;
      }
    }

    // dispose atom from memory after finishing
    if (_atom(id)._waiting.isEmpty && !_atom(id).isLocked) {
      _atoms.removeWhere((atomId, atom) => atomId == id);
    }
  }

  bool _jobAcquiredWithId(_MutexRequest job, String id) {
    assert(0 <= _atom(id)._semaphore);

    // atom is unlocked
    if (!_atom(id).isLocked) {
      _atom(id)._semaphore--; // lock mutex
      job.completer.complete();
      return true;
    }
    return false;
  }
}
