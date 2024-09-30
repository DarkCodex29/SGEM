import 'dart:convert';

class EntidadUsuarioAzure {
  String odataContext;
  List<dynamic> businessPhones;
  String displayName;
  String givenName;
  dynamic jobTitle;
  dynamic mail;
  dynamic mobilePhone;
  dynamic officeLocation;
  dynamic preferredLanguage;
  String surname;
  String userPrincipalName;
  String id;

  EntidadUsuarioAzure({
    required this.odataContext,
    required this.businessPhones,
    required this.displayName,
    required this.givenName,
    required this.jobTitle,
    required this.mail,
    required this.mobilePhone,
    required this.officeLocation,
    required this.preferredLanguage,
    required this.surname,
    required this.userPrincipalName,
    required this.id,
  });

  EntidadUsuarioAzure copyWith({
    String? odataContext,
    List<dynamic>? businessPhones,
    String? displayName,
    String? givenName,
    dynamic jobTitle,
    dynamic mail,
    dynamic mobilePhone,
    dynamic officeLocation,
    dynamic preferredLanguage,
    String? surname,
    String? userPrincipalName,
    String? id,
  }) =>
      EntidadUsuarioAzure(
        odataContext: odataContext ?? this.odataContext,
        businessPhones: businessPhones ?? this.businessPhones,
        displayName: displayName ?? this.displayName,
        givenName: givenName ?? this.givenName,
        jobTitle: jobTitle ?? this.jobTitle,
        mail: mail ?? this.mail,
        mobilePhone: mobilePhone ?? this.mobilePhone,
        officeLocation: officeLocation ?? this.officeLocation,
        preferredLanguage: preferredLanguage ?? this.preferredLanguage,
        surname: surname ?? this.surname,
        userPrincipalName: userPrincipalName ?? this.userPrincipalName,
        id: id ?? this.id,
      );

  factory EntidadUsuarioAzure.fromMap(Map<String, dynamic> json) =>
      EntidadUsuarioAzure(
        odataContext: json["@odata.context"],
        businessPhones:
            List<dynamic>.from(json["businessPhones"].map((x) => x)),
        displayName: json["displayName"],
        givenName: json["givenName"],
        jobTitle: json["jobTitle"],
        mail: json["mail"],
        mobilePhone: json["mobilePhone"],
        officeLocation: json["officeLocation"],
        preferredLanguage: json["preferredLanguage"],
        surname: json["surname"],
        userPrincipalName: json["userPrincipalName"],
        id: json["id"],
      );

  Map<String, dynamic> toMap() => {
        "@odata.context": odataContext,
        "businessPhones": List<dynamic>.from(businessPhones.map((x) => x)),
        "displayName": displayName,
        "givenName": givenName,
        "jobTitle": jobTitle,
        "mail": mail,
        "mobilePhone": mobilePhone,
        "officeLocation": officeLocation,
        "preferredLanguage": preferredLanguage,
        "surname": surname,
        "userPrincipalName": userPrincipalName,
        "id": id,
      };

  factory EntidadUsuarioAzure.fromJson(String str) =>
      EntidadUsuarioAzure.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());
}
