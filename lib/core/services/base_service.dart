class BaseService {
  final _callbacks = <int, Function(dynamic)>{};

  int registerNotifyer(Function(dynamic) callback) {
    final hash = callback.hashCode;
    _callbacks[hash] = callback;
    return hash;
  }

  void disposeListener(int? hash) {
    if (_callbacks.keys.contains(hash)) {
      _callbacks.remove(hash);
    }
  }

  void notifyListeners({dynamic argument}) {
    _callbacks.forEach((key, value) {
      value.call(argument);
    });
  }
}
