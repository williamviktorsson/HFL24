import 'package:cli_shared/cli_shared.dart';

class Validator {
// check that nullable string is number
  static bool isInteger(String? value) {
    return switch (value?.tryParseInt()) {
      (int _) => true,
      _ => false,
    };
  }

  static bool isString(String? value) {
    return switch (value) {
      (String string) when string.isNotEmpty => true,
      _ => false,
    };
  }

  static bool isIndex(String? value, Iterable list) {
    return switch (value?.tryParseInt()) {
      (int index) when index >= 1 && index < list.length + 1 => true,
      _ => false
    };
  }
}
