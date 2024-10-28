//

import 'package:uuid/uuid.dart';

extension type Id._(String id) implements String {
  Id({required this.id});
  Id.unique() : id = Uuid().v4();
  Id.fromJson(Map<String, dynamic> json) : id = json['id'];
}

mixin Identifiable {
  Id get id;

  @override
  bool operator ==(other) => other is Identifiable && id == other.id;
}

extension IdConversion on String {
  Id toId() => Id(id: this);
}

extension NumberParsing on String {
  int? tryParseInt() {
    return int.tryParse(this);
  }
}
