import 'dart:convert';

HolidaysData holidaysFromJson(String str) =>
    HolidaysData.fromJson(json.decode(str));

String holidaysToJson(HolidaysData data) => json.encode(data.toJson());

class HolidaysData {
  int id;
  String startDate;
  String endDate;
  String? petitionComment;
  String? responseComment;
  bool? accepted;

  HolidaysData({
    required this.id,
    required this.startDate,
    required this.petitionComment,
    required this.responseComment,
    required this.endDate,
    this.accepted,
  });

  static List<HolidaysData> fromJsonList(List<dynamic> jsonList) {
    List<HolidaysData> toList = [];
    jsonList.forEach((element) {
      HolidaysData listCheking = HolidaysData.fromJson(element);
      toList.add(listCheking);
    });

    return toList;
  }

  factory HolidaysData.fromJson(Map<String, dynamic> json) => HolidaysData(
        id: json["id"],
        startDate: json["startDate"],
        endDate: json["endDate"],
        petitionComment: json["petitionComment"],
        responseComment: json["responseComment"],
        accepted: json["accepted"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "startDate": startDate,
        "endDate": endDate,
        "petitionComment": petitionComment,
        "responseComment": responseComment,
        "accepted": accepted,
      };
}


