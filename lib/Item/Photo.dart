class Photo {
  int id, countforphoto;
  String name,photo_name, image_name;

  Photo(this.id, this.photo_name, this.countforphoto, this.image_name);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'photo_name': photo_name,
      'countforphoto': countforphoto,
      'image_name': image_name,
    };
    return map;
  }

  Photo.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    photo_name = map['photo_name'];
    countforphoto = map['countforphoto'];
    image_name = map['image_name'];
  }
}
