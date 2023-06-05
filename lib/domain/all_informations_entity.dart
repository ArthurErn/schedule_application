class AllInformationsEntity {
  String nome = '';
  int idEmpresa = 0;
  int cep = 0;
  String ruaAvenida = '';
  int numero = 0;
  String complemento = '';
  String bairro = '';
  String cidade = '';
  String estado = '';
  String pais = '';
  
  AllInformationsEntity.fromJsonAddress(Map<String, dynamic> json){
    cep = json['cep'];
    ruaAvenida = json['rua_avenida'];
    numero = json['numero'];
    complemento = json['complemento'];
    bairro = json['bairro'];
    cidade = json['cidade'];
    estado = json['estado'];
    pais = json['pais'];
  }

  AllInformationsEntity.fromJsonName(Map<String, dynamic> json){
    nome = json['nome'];
    idEmpresa = json['id_empresa'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id_empresa'] = idEmpresa;
    data['nome'] = nome;
    data['cep'] = cep;
    data['rua_avenida'] = ruaAvenida;
    data['numero'] = numero;
    data['complemento'] = complemento;
    data['bairro'] = bairro;
    data['cidade'] = cidade;
    data['estado'] = estado;
    data['pais'] = pais;
    return data;
  }
}