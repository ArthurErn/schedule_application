class ScheduleEntity {
  ScheduleEntity({
    required this.dataHora,
    required this.nome,
    required this.valor,
    required this.tempoServico,
    required this.nomeServico,
    required this.descricaoCompleta,
    required this.situacao,
    required this.idUsuarioServico,
    required this.idAgendamento,
    required this.idUsuario,
  });
  late final String dataHora;
  late final String nome;
  late final dynamic valor;
  late final dynamic tempoServico;
  late final String nomeServico;
  late final String descricaoCompleta;
  late final String situacao;
  late final dynamic idUsuarioServico;
  late final dynamic idAgendamento;
  late final dynamic idUsuario;
  
  ScheduleEntity.fromJson(Map<String, dynamic> json){
    dataHora = json['data_hora'];
    nome = json['nome'];
    valor = json['valor'];
    tempoServico = json['tempo_servico'];
    nomeServico = json['nome_servico'];
    descricaoCompleta = json['descricao_completa'];
    situacao = json['situacao'];
    idUsuarioServico = json['id_usuario_servico'];
    idAgendamento = json['id_agendamento'];
    idUsuario = json['id_usuario'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['data_hora'] = dataHora;
    _data['nome'] = nome;
    _data['valor'] = valor;
    _data['tempo_servico'] = tempoServico;
    _data['nome_servico'] = nomeServico;
    _data['descricao_completa'] = descricaoCompleta;
    _data['situacao'] = situacao;
    _data['id_usuario_servico'] = idUsuarioServico;
    _data['id_agendamento'] = idAgendamento;
    _data['id_usuario'] = idUsuario;
    return _data;
  }
}