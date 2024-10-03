main() {
  
  var personRepo = PersonRepository();

  while(true){

    // 1. prompt options
    // 2. input selection
    // 3.1 prompt new options
    // 3.2 prompt action instructions
    // 4. input data for action
    // repeat??

  }

}

// models first

class Person {}

class Vehicle {}

// repos to store persons

abstract class Repository<T> {
  List<T> items = [];

  // crud operations

  create(T item) {
    items.add(item);
  }
}

class PersonRepository extends Repository<Person> {

}

class VehicleRepository extends Repository<Vehicle> {

}