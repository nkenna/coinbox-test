import 'package:logger/logger.dart';

class AppLogger {
  AppLogger._privateConstructor();
  static final AppLogger instance = AppLogger._privateConstructor();
  Logger? appLogger;

  Future<void> initializeAppLogger() async{
    PrettyPrinter prettyPrinter = PrettyPrinter(
        printTime: true
    );
    appLogger = Logger(
        printer: prettyPrinter,
        filter: null,
        output: null
    );
  }

  logError(msg){
    appLogger!.e(msg);
  }

  logInfo(msg){
    appLogger!.i(msg);
  }

  logWarning(msg){
    appLogger!.w(msg);
  }

  logDebugMsg(msg){
    appLogger!.d(msg);
  }

  logVerbose(msg){
    appLogger!.t(msg);
  }


}