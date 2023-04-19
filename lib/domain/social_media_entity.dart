class SocialMediaEntity {
  SocialMediaEntity({
    required this.whatsapp,
    required this.instagram,
    required this.facebook,
    required this.youtube,
    required this.tiktok,
    required this.twitter,
    required this.linkedin,
    required this.outra,
  });
  late final String whatsapp;
  late final String instagram;
  late final String facebook;
  late final String youtube;
  late final String tiktok;
  late final String twitter;
  late final String linkedin;
  late final String outra;
  
  SocialMediaEntity.fromJson(Map<String, dynamic> json){
    whatsapp = json['whatsapp'];
    instagram = json['instagram'];
    facebook = json['facebook'];
    youtube = json['youtube'];
    tiktok = json['tiktok'];
    twitter = json['twitter'];
    linkedin = json['linkedin'];
    outra = json['outra'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['whatsapp'] = whatsapp;
    data['instagram'] = instagram;
    data['facebook'] = facebook;
    data['youtube'] = youtube;
    data['tiktok'] = tiktok;
    data['twitter'] = twitter;
    data['linkedin'] = linkedin;
    data['outra'] = outra;
    return data;
  }
}