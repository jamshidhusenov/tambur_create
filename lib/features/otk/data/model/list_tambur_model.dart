// To parse this JSON data, do
//
//     final listTamburModel = listTamburModelFromJson(jsonString);

import 'dart:convert';

ListTamburModel listTamburModelFromJson(String str) => ListTamburModel.fromJson(json.decode(str));
Tambur tamburFromString(String str) => Tambur.fromJson(json.decode(str));
String listTamburModelToJson(ListTamburModel data) => json.encode(data.toJson());

class ListTamburModel {
    int? page;
    int? count;
    int? totalPages;
    dynamic next;
    dynamic previous;
    List<Tambur>? results;

    ListTamburModel({
        this.page,
        this.count,
        this.totalPages,
        this.next,
        this.previous,
        this.results,
    });

    ListTamburModel copyWith({
        int? page,
        int? count,
        int? totalPages,
        dynamic next,
        dynamic previous,
        List<Tambur>? results,
    }) => 
        ListTamburModel(
            page: page ?? this.page,
            count: count ?? this.count,
            totalPages: totalPages ?? this.totalPages,
            next: next ?? this.next,
            previous: previous ?? this.previous,
            results: results ?? this.results,
        );

    factory ListTamburModel.fromJson(Map<String, dynamic> json) => ListTamburModel(
        page: json["page"],
        count: json["count"],
        totalPages: json["total_pages"],
        next: json["next"],
        previous: json["previous"],
        results: json["results"] == null ? [] : List<Tambur>.from(json["results"]!.map((x) => Tambur.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "page": page,
        "count": count,
        "total_pages": totalPages,
        "next": next,
        "previous": previous,
        "results": results == null ? [] : List<dynamic>.from(results!.map((x) => x.toJson())),
    };
}

class Tambur {
    int? id;
    String? tamburNumber;
    String? shift;
    String? radius;
    int? format;
    String? brand;
    List<dynamic>? dampness;
    List<dynamic>? densities;
    List<dynamic>? thicknesses;
    List<dynamic>? burstStrengths;
    List<dynamic>? punctureResistances;
    DateTime? createdAt;
    DateTime? updatedAt;
    String? createdBy;
    String? updatedBy;

    Tambur({
        this.id,
        this.tamburNumber,
        this.shift,
        this.radius,
        this.format,
        this.brand,
        this.dampness,
        this.densities,
        this.thicknesses,
        this.burstStrengths,
        this.punctureResistances,
        this.createdAt,
        this.updatedAt,
        this.createdBy,
        this.updatedBy,
    });

    Tambur copyWith({
        int? id,
        String? tamburNumber,
        String? shift,
        String? radius,
        int? format,
        String? brand,
        List<dynamic>? dampness,
        List<dynamic>? densities,
        List<dynamic>? thicknesses,
        List<dynamic>? burstStrengths,
        List<dynamic>? punctureResistances,
        DateTime? createdAt,
        DateTime? updatedAt,
        String? createdBy,
        String? updatedBy,
    }) => 
        Tambur(
            id: id ?? this.id,
            tamburNumber: tamburNumber ?? this.tamburNumber,
            shift: shift ?? this.shift,
            radius: radius ?? this.radius,
            format: format ?? this.format,
            brand: brand ?? this.brand,
            dampness: dampness ?? this.dampness,
            densities: densities ?? this.densities,
            thicknesses: thicknesses ?? this.thicknesses,
            burstStrengths: burstStrengths ?? this.burstStrengths,
            punctureResistances: punctureResistances ?? this.punctureResistances,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
            createdBy: createdBy ?? this.createdBy,
            updatedBy: updatedBy ?? this.updatedBy,
        );

    factory Tambur.fromJson(Map<String, dynamic> json) => Tambur(
        id: json["id"],
        tamburNumber: json["tambur_number"],
        shift: json["shift"],
        radius: json["radius"],
        format: json["format"],
        brand: json["brand"],
        dampness: json["dampness"] == null ? [] : List<dynamic>.from(json["dampness"]!.map((x) => x)),
        densities: json["densities"] == null ? [] : List<dynamic>.from(json["densities"]!.map((x) => x)),
        thicknesses: json["thicknesses"] == null ? [] : List<dynamic>.from(json["thicknesses"]!.map((x) => x)),
        burstStrengths: json["burst_strengths"] == null ? [] : List<dynamic>.from(json["burst_strengths"]!.map((x) => x)),
        punctureResistances: json["puncture_resistances"] == null ? [] : List<dynamic>.from(json["puncture_resistances"]!.map((x) => x)),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "tambur_number": tamburNumber,
        "shift": shift,
        "radius": radius,
        "format": format,
        "brand": brand,
        "dampness": dampness == null ? [] : List<dynamic>.from(dampness!.map((x) => x)),
        "densities": densities == null ? [] : List<dynamic>.from(densities!.map((x) => x)),
        "thicknesses": thicknesses == null ? [] : List<dynamic>.from(thicknesses!.map((x) => x)),
        "burst_strengths": burstStrengths == null ? [] : List<dynamic>.from(burstStrengths!.map((x) => x)),
        "puncture_resistances": punctureResistances == null ? [] : List<dynamic>.from(punctureResistances!.map((x) => x)),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "created_by": createdBy,
        "updated_by": updatedBy,
    };
}
