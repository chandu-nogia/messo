class LandingModel {
    LandingModel({
        required this.lovexaMallBannerFullUrl,
        required this.landingCustomBanner,
        required this.categories,
    });

    final String? lovexaMallBannerFullUrl;
    final LandingCustomBanner? landingCustomBanner;
    final List<Category> categories;

    factory LandingModel.fromJson(Map<String, dynamic> json){ 
        return LandingModel(
            lovexaMallBannerFullUrl: json["lovexa_mall_banner_full_url"],
            landingCustomBanner: json["landing_custom_banner"] == null ? null : LandingCustomBanner.fromJson(json["landing_custom_banner"]),
            categories: json["categories"] == null ? [] : List<Category>.from(json["categories"]!.map((x) => Category.fromJson(x))),
        );
    }

}

class Category {
    Category({
        required this.id,
        required this.name,
        required this.bannerFullUrl,
        required this.translations,
    });

    final int? id;
    final String? name;
    final String? bannerFullUrl;
    final List<dynamic> translations;

    factory Category.fromJson(Map<String, dynamic> json){ 
        return Category( 

            id: json["id"],
            name: json["name"],
            bannerFullUrl: json["banner_full_url"],
            translations: json["translations"] == null ? [] : List<dynamic>.from(json["translations"]!.map((x) => x)),
        );
    }

}

class LandingCustomBanner {
    LandingCustomBanner({
        required this.resourceType,
        required this.resourceId,
        required this.bannerFullUrl,
    });

    final String? resourceType;
    final String? resourceId;
    final String? bannerFullUrl;

    factory LandingCustomBanner.fromJson(Map<String, dynamic> json){ 
        return LandingCustomBanner(
            resourceType: json["resource_type"],
            resourceId: json["resource_id"],
            bannerFullUrl: json["banner_full_url"],
        );
    }

}
