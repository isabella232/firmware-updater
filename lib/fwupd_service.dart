import 'dart:async';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:dbus/dbus.dart';
import 'package:dio/dio.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:fwupd/fwupd.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;
import 'package:ubuntu_logger/ubuntu_logger.dart';
import 'package:ubuntu_session/ubuntu_session.dart';
import 'package:upower/upower.dart';

import 'fwupd_x.dart';

final log = Logger('fwupd_service');

class FwupdService {
  FwupdService({
    @visibleForTesting FwupdClient? fwupd,
    @visibleForTesting Dio? dio,
    @visibleForTesting FileSystem? fs,
    @visibleForTesting UbuntuSession? session,
    @visibleForTesting UPowerClient? upower,
  })  : _dio = dio ?? Dio(),
        _fs = fs ?? const LocalFileSystem(),
        _fwupd = fwupd ?? FwupdClient(),
        _session = session ?? UbuntuSession(),
        _upower = upower ?? UPowerClient();

  final Dio _dio;
  final FileSystem _fs;
  final FwupdClient _fwupd;
  final UPowerClient _upower;
  final UbuntuSession _session;
  int? _downloadProgress;
  final _propertiesChanged = StreamController<List<String>>();
  StreamSubscription<List<String>>? _propertiesSubscription;

  FwupdStatus get status =>
      _downloadProgress != null ? FwupdStatus.downloading : _fwupd.status;
  int get percentage => _downloadProgress ?? _fwupd.percentage;
  String get daemonVersion => _fwupd.daemonVersion;

  Stream<FwupdDevice> get deviceAdded => _fwupd.deviceAdded;
  Stream<FwupdDevice> get deviceChanged => _fwupd.deviceChanged;
  Stream<FwupdDevice> get deviceRemoved => _fwupd.deviceRemoved;
  Stream<List<String>> get propertiesChanged => _propertiesChanged.stream;

  Future<void> init() async {
    await _fwupd.connect();
    _propertiesSubscription ??=
        _fwupd.propertiesChanged.listen(_propertiesChanged.add);
    await _upower.connect();
  }

  Future<void> dispose() async {
    _dio.close();
    await _upower.close();
    await _propertiesSubscription?.cancel();
    return _fwupd.close();
  }

  Future<File> _fetchRelease(FwupdRelease release) async {
    final remote = await _fwupd.getRemotes().then((remotes) {
      return remotes.firstWhere((remote) => remote.id == release.remoteId);
    });

    assert(release.locations.isNotEmpty, 'TODO: handle multiple locations');

    late final File file;
    switch (remote.kind) {
      case FwupdRemoteKind.download:
        // TODO:
        // - should the .cab be stored in the cache directory?
        file = await _downloadRelease(release.locations.first);
        break;
      case FwupdRemoteKind.local:
        final cache = p.dirname(remote.filenameCache ?? '');
        file = _fs.file(p.join(cache, release.locations.first));
        break;
      default:
        throw UnimplementedError('Remote kind ${remote.kind} not implemented');
    }
    return file;
  }

  Future<File> _downloadRelease(String url) async {
    final path = p.join(_fs.systemTempDirectory.path, p.basename(url));
    log.debug('download $url to $path');
    try {
      return await _dio.download(url, path, onReceiveProgress: (recvd, total) {
        _setDownloadProgress(100 * recvd ~/ total);
      }).then((response) => _fs.file(path));
    } on DioError catch (e) {
      throw Exception(e.message);
    } finally {
      _setDownloadProgress(null);
    }
  }

  void _setDownloadProgress(int? progress) {
    if (_downloadProgress == progress) return;
    _downloadProgress = progress;
    _propertiesChanged.add(['Percentage']);
  }

  Future<void> activate(FwupdDevice device) {
    log.debug('activate $device');
    return _fwupd.activate(device.id);
  }

  Future<void> clearResults(FwupdDevice device) {
    log.debug('clearResults $device');
    return _fwupd.clearResults(device.id);
  }

  Future<List<FwupdDevice>> getDevices() => _fwupd.getDevices();

  Future<List<FwupdRelease>> getDowngrades(String deviceId) {
    return _fwupd.getDowngrades(deviceId);
  }

  Future<List<FwupdPlugin>> getPlugins() => _fwupd.getPlugins();

  Future<List<FwupdRelease>> getReleases(String deviceId) {
    return _fwupd.getReleases(deviceId);
  }

  Future<List<FwupdRemote>> getRemotes() => _fwupd.getRemotes();

  Future<List<FwupdRelease>> getUpgrades(String deviceId) {
    return _fwupd.getUpgrades(deviceId);
  }

  Future<void> install(
    FwupdDevice device,
    FwupdRelease release, [
    @visibleForTesting
        ResourceHandle Function(RandomAccessFile file)? resourceHandleFromFile,
  ]) async {
    log.debug('install $release');
    log.debug('on $device');
    final file = await _fetchRelease(release);
    resourceHandleFromFile ??= ResourceHandle.fromFile;
    return _fwupd.install(
      device.id,
      resourceHandleFromFile(file.openSync()),
      flags: {
        if (release.isDowngrade) FwupdInstallFlag.allowOlder,
        if (!release.isDowngrade && !release.isUpgrade)
          FwupdInstallFlag.allowReinstall,
      },
    );
  }

  bool get onBattery => _upower.onBattery;

  Future<void> unlock(FwupdDevice device) {
    log.debug('unlock $device');
    return _fwupd.unlock(device.id);
  }

  Future<void> verify(FwupdDevice device) {
    log.debug('verify $device');
    return _fwupd.verify(device.id);
  }

  Future<void> verifyUpdate(FwupdDevice device) {
    log.debug('verifyUpdate $device');
    return _fwupd.verifyUpdate(device.id);
  }

  Future<void> reboot() async {
    try {
      await _session.reboot();
    } on DBusMethodResponseException catch (error) {
      if (error.response.values.firstOrNull?.asString() ==
          'Operation was cancelled') {
        log.debug('reboot cancelled by user');
      } else {
        rethrow;
      }
    }
  }
}
