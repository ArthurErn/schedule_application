class AddressEntity {
  AddressEntity({
    required this.cep,
    required this.ruaAvenida,
    required this.numero,
    required this.complemento,
    required this.bairro,
    required this.cidade,
    required this.estado,
    required this.pais,
  });
  late final int cep;
  late final String ruaAvenida;
  late final int numero;
  late final String complemento;
  late final String bairro;
  late final String cidade;
  late final String estado;
  late final String pais;
  
  AddressEntity.fromJson(Map<String, dynamic> json){
    cep = json['cep'];
    ruaAvenida = json['rua_avenida'];
    numero = json['numero'];
    complemento = json['complemento'];
    bairro = json['bairro'];
    cidade = json['cidade'];
    estado = json['estado'];
    pais = json['pais'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
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