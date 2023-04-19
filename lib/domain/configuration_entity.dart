class ConfigurationEntity {
  ConfigurationEntity({
    required this.idConfiguracao,
    required this.intervaloAtendimento,
  });
  late final int idConfiguracao;
  late final int intervaloAtendimento;
  
  ConfigurationEntity.fromJson(Map<String, dynamic> json){
    idConfiguracao = json['id_configuracao'];
    intervaloAtendimento = json['intervalo_atendimento'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id_configuracao'] = idConfiguracao;
    data['intervalo_atendimento'] = intervaloAtendimento;
    return data;
  }
}