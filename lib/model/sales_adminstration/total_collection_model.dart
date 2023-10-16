class TotalCollectionModel {
  double? collection;
  String? name;

  TotalCollectionModel(this.collection, this.name);

  TotalCollectionModel.fromJson(Map<String, dynamic> totalCollection) {
    collection = totalCollection['collection'].toString() == "null"
        ? 0.0
        : double.parse(totalCollection['collection']);
    name = totalCollection['name'].toString() == "null"
        ? ""
        : totalCollection['name'].toString();
  }
}
