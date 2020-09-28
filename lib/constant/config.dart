class Config {
  // mainet: 0, testnet: 1
  static final Config _instance = Config._internal();
  factory Config() => _instance;
  static const bool remoteLog = false;
  static const int logLevel = 0;
  static const String logServer = "https://log.mermer.cc/";
  static const String _network = "testnet";

  bool _isTestnet;
  bool get isTestnet => _isTestnet;
  int get network => _isTestnet ? 1 : 0;
  Config._internal() : _isTestnet = true;
  void setTestnet(bool v) => _instance._isTestnet = v;
}
