import 'package:intl/intl.dart';

mixin class MIntl {
  NumberFormat get currencyFormatWithoutCurrency {
    return NumberFormat.currency(decimalDigits: 2, symbol: '');
  }

  NumberFormat get currencyFormat {
    return NumberFormat.currency(decimalDigits: 2, symbol: '\$');
  }

  NumberFormat get currentFormatWithoutDecimals {
    return NumberFormat.currency(decimalDigits: 0, symbol: '\$');
  }

  NumberFormat get mileageFormat {
    return NumberFormat.decimalPattern();
  }
 }
