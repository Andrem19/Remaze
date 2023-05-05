import 'cube.dart';

class Test {
  List<List<Cube>> mazeMap;
  Test({
    required this.mazeMap,
  });
  factory Test.fromMap(Map<String, dynamic> map) {
    return Test(
        mazeMap: map.entries.map((entry) => (entry.value as Map<String, dynamic>).entries.map((item) => Cube.fromMap(item.value)).toList()).toList(),
    );
  }
}
