class UserServiceEntity {
  UserServiceEntity({
    required this.idUsuarioServico,
    required this.nome,
    required this.nomeServico,
    required this.tempoServico,
    required this.valor,
  });
  late final int idUsuarioServico;
  late final String nome;
  late final String nomeServico;
  late final dynamic tempoServico;
  late final dynamic valor;
  
  UserServiceEntity.fromJson(Map<String, dynamic> json){
    idUsuarioServico = json['id_usuario_servico'];
    nome = json['nome'];
    nomeServico = json['nome_servico'];
    tempoServico = json['tempo_servico'];
    valor = json['valor'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id_usuario_servico'] = idUsuarioServico;
    _data['nome'] = nome;
    _data['nome_servico'] = nomeServico;
    _data['tempo_servico'] = tempoServico;
    _data['valor'] = valor;
    return _data;
  }
}