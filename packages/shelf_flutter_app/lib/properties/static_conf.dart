final class StaticConf {
  const StaticConf({
    this.fileSystemPath = 'app',
    this.defaultDocument = 'index.html',
    this.onNotFoundPathUseDefaultDocument = true,
    this.compress = true,
  });

  final String fileSystemPath;
  final String defaultDocument;

  final bool onNotFoundPathUseDefaultDocument;
  final bool compress;
}
