class ServiceEntity {
  ServiceEntity({
    required this.idServico,
    required this.nomeServico,
    required this.descricao,
    required this.tempoServico,
    required this.valor,
  });
  late final dynamic idServico;
  late final String nomeServico;
  late final String descricao;
  late final dynamic tempoServico;
  late final dynamic valor;
  
  ServiceEntity.fromJson(Map<String, dynamic> json){
    idServico = json['id_servico'];
    nomeServico = json['nome_servico'];
    descricao = json['descricao'];
    tempoServico = json['tempo_servico'];
    valor = json['valor'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id_servico'] = idServico;
    _data['nome_servico'] = nomeServico;
    _data['descricao'] = descricao;
    _data['tempo_servico'] = tempoServico;
    _data['valor'] = valor;
    return _data;
  }
}