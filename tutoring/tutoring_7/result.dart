sealed class Result<T, E> {
  const Result();

  factory Result.success({required T value}) => Success(data: value);
  factory Result.failure({required E reason}) => Failure(reason: reason);
}

class Success<T, E> extends Result<T, E> {
  final T data;
  const Success({required this.data});
}

class Failure<T, E> extends Result<T, E> {
  final E reason;
  const Failure({required this.reason});
}

typedef ResultValue = int;

void main(List<String> arguments) {
  final r = Result<ResultValue, String>.success(value: 17);
  final f = Result<ResultValue, String>.failure(reason: "Can't do this");

  switch (r) {
    case Success(data: var data):
      print("Success, value '${data}'");
    case Failure():
      print("Failure, reason '${r.reason}'");
  }

  print(switch (f) {
    Success(data: var d) => "Success, value '${d}'",
    Failure(reason: var r) => "Failure, reason '${r}'",
  });
}
