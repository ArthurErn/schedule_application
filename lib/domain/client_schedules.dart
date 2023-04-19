class ClientSchedulesEntity {
  ClientSchedulesEntity({
    required this.dataHora,
    required this.cliente,
    required this.valor,
    required this.tempoServico,
    required this.nomeServico,
    required this.descricaoCompleta,
    required this.situacao,
  });
  late final String dataHora;
  late final String cliente;
  late final dynamic valor;
  late final dynamic tempoServico;
  late final String nomeServico;
  late final String descricaoCompleta;
  late final String situacao;
  
  ClientSchedulesEntity.fromJson(Map<String, dynamic> json){
    dataHora = json['data_hora'];
    cliente = json['cliente'];
    valor = json['valor'];
    tempoServico = json['tempo_servico'];
    nomeServico = json['nome_servico'];
    descricaoCompleta = json['descricao_completa'];
    situacao = json['situacao'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['data_hora'] = dataHora;
    data['cliente'] = cliente;
    data['valor'] = valor;
    data['tempo_servico'] = tempoServico;
    data['nome_servico'] = nomeServico;
    data['descricao_completa'] = descricaoCompleta;
    data['situacao'] = situacao;
    return data;
  }
}