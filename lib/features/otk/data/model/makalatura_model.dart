import 'dart:convert';

MakalaturaModel makalaturaModelFromJson(String str) => MakalaturaModel.fromJson(json.decode(str));

String makalaturaModelToJson(MakalaturaModel data) => json.encode(data.toJson());

class MakalaturaModel {

    int? page;
    int? count;
    int? totalPages;
    String? next;
    dynamic previous;
    List<Makalatura>? results;

    MakalaturaModel({
        this.page,
        this.count,
        this.totalPages,
        this.next,
        this.previous,
        this.results,
    });

    MakalaturaModel copyWith({
        int? page,
        int? count,
        int? totalPages,
        String? next,
        dynamic previous,
        List<Makalatura>? results,
    }) => 
        MakalaturaModel(
            page: page ?? this.page,
            count: count ?? this.count,
            totalPages: totalPages ?? this.totalPages,
            next: next ?? this.next,
            previous: previous ?? this.previous,
            results: results ?? this.results,
        );

    factory MakalaturaModel.fromJson(Map<String, dynamic> json) => MakalaturaModel(
        page: json["page"],
        count: json["count"],
        totalPages: json["total_pages"],
        next: json["next"],
        previous: json["previous"],
        results: json["results"] == null ? [] : List<Makalatura>.from(json["results"]!.map((x) => Makalatura.fromJson(x))),
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

class Makalatura {
    int? id;
    String? carNumber;
    String? driverName;
    String? supplier;
    int? weightIn;
    String? carImage;
    int? discountPercent;
    int? discountWeight;
    String? otkComment;
    DateTime? createdAt;
    bool? isDiscountApproved;

    Makalatura({
        this.id,
        this.carNumber,
        this.driverName,
        this.supplier,
        this.weightIn,
        this.carImage,
        this.discountPercent,
        this.discountWeight,
        this.otkComment,
        this.createdAt,
        this.isDiscountApproved,
    });

    Makalatura copyWith({
        int? id,
        String? carNumber,
        String? driverName,
        String? supplier,
        int? weightIn,
        String? carImage,
        int? discountPercent,
        int? discountWeight,
        String? otkComment,
        DateTime? createdAt,
        bool? isDiscountApproved,
    }) => 
        Makalatura(
            id: id ?? this.id,
            carNumber: carNumber ?? this.carNumber,
            driverName: driverName ?? this.driverName,
            supplier: supplier ?? this.supplier,
            weightIn: weightIn ?? this.weightIn,
            carImage: carImage ?? this.carImage,
            discountPercent: discountPercent ?? this.discountPercent,
            discountWeight: discountWeight ?? this.discountWeight,
            otkComment: otkComment ?? this.otkComment,
            createdAt: createdAt ?? this.createdAt,
            isDiscountApproved: isDiscountApproved ?? this.isDiscountApproved,
        );

    factory Makalatura.fromJson(Map<String, dynamic> json) => Makalatura(
        id: json["id"],
        carNumber: json["car_number"],
        driverName: json["driver_name"],
        supplier: json["supplier"],
        weightIn: json["weight_in"],
        carImage: json["car_image"],
        discountPercent: json["discount_percent"],
        discountWeight: json["discount_weight"],
        otkComment: json["otk_comment"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        isDiscountApproved: json["is_discount_approved"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "car_number": carNumber,
        "driver_name": driverName,
        "supplier": supplier,
        "weight_in": weightIn,
        "car_image": carImage,
        "discount_percent": discountPercent,
        "discount_weight": discountWeight,
        "otk_comment": otkComment,
        "created_at": createdAt?.toIso8601String(),
        "is_discount_approved": isDiscountApproved,
    };
}
