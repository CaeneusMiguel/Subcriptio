import 'dart:convert';

Document documentFromJson(String str) => Document.fromJson(json.decode(str));

String documentToJson(Document data) => json.encode(data.toJson());

class Document {
  int id;
  String nombre;
  String file;
  String createDate;
  bool? isSignTemplate;
  bool? isSigned;
  double? userStartX;
  double? userStartY;
  double? userWidth;
  double? userHeight;

  Document(
      {required this.id,
      required this.nombre,
      required this.file,
      required this.createDate,
      this.userHeight,
      this.userWidth,
      this.isSigned,
      this.isSignTemplate,
      this.userStartX,
      this.userStartY});

  static List<Document> fromJsonList(List<dynamic> jsonList) {
    List<Document> toList = [];
    jsonList.forEach((element) {
      Document document = Document.fromJson(element);
      toList.add(document);
    });

    return toList;
  }

  factory Document.fromJson(Map<String, dynamic> json) => Document(
      id: json["id"],
      nombre: json["name"],
      file: json["file"],
      createDate: json["create_date"],
      userHeight: json["height"]?.toDouble(),
      userWidth: json["width"]?.toDouble(),
      isSigned: json["isSigned"],
      isSignTemplate: json["isSignTemplate"],
      userStartX: json["startX"]?.toDouble(),
      userStartY: json["startY"]?.toDouble());

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "file": file,
        "create_date": createDate,
        "height": userHeight,
        "width": userWidth,
        "isSigned": isSigned,
        "isSignTemplate": isSignTemplate,
        "startX": userStartX,
        "startY": userStartY
      };
}


