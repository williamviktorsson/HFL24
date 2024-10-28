import 'package:uuid/uuid.dart';

extension type Id._(String id) {
  Id({required this.id});

  Id.unique() : id = Uuid().v4();
}

mixin Identifiable {
  Id get id;

  @override
  bool operator ==(Object other) {
    // TODO: check super equals
    return super==other && other is Identifiable && other.id == id;
  }
}

extension IdConversion on String {
  Id toId() => Id(id: this);
}

extension NumberParsing on String {
  int? tryParseInt() => int.tryParse(this);
}
