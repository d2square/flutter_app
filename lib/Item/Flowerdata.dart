class Flowerdata {
  int id;
  String flowerName;
  String flowerImageURL;

  Flowerdata({
    this.id,
    this.flowerName,
    this.flowerImageURL
  });

  factory Flowerdata.fromJson(Map<String, dynamic> json) {
    return Flowerdata(
        id: json['id'],
        flowerName: json['flower_name'],
        flowerImageURL: json['flower_image_url']

    );
  }
}