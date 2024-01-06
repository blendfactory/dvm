import 'package:http/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dvm_client.g.dart';

@Riverpod(keepAlive: true, dependencies: [])
DvmClient dvmClient(DvmClientRef ref) {
  final dvmClient = DvmClient(Client());
  ref.onDispose(dvmClient.close);
  return dvmClient;
}

/// A [Client] that times out after 3 seconds.
final class DvmClient extends BaseClient {
  DvmClient(this._inner);

  final Client _inner;

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    return _inner.send(request).timeout(const Duration(seconds: 3));
  }

  @override
  void close() => _inner.close();
}
