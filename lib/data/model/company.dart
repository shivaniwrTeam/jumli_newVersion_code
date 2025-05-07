class Company {
  String? companyName;

  String? companyEmail;

  String? companyTel1;
  String? companyTel2;

  Company(
      {this.companyName,

      this.companyEmail,

      this.companyTel1,
      this.companyTel2});

  Company.fromJson(Map<String, dynamic> json) {
    companyName = json['company_name'];

    companyEmail = json['company_email'];

    companyTel1 = json['company_tel1'];
    companyTel2 = json['company_tel2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['company_name'] = companyName;

    data['company_email'] = companyEmail;

    data['company_tel1'] = companyTel1;
    data['company_tel2'] = companyTel2;
    return data;
  }
}
