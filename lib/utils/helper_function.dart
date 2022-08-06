import 'package:intl/intl.dart';

String getFormatterDate(DateTime dt, {String format = 'dd/MM/yyyy  HH:mm'}) =>
    DateFormat(format).format(dt);
