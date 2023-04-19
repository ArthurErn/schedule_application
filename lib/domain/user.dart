class UserEntity {
  UserEntity({
    required this.idUsuario,
    required this.nome,
    required this.idPermissao
  });
  late final int idUsuario;
  late final String nome;
  late final int idPermissao;
  
  UserEntity.fromJson(Map<String, dynamic> json){
    idUsuario = json['id_usuario'];
    nome = json['nome'];
    idPermissao = json['id_permissao'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id_usuario'] = idUsuario;
    data['nome'] = nome;
    data['id_permissao'] = idPermissao;
    return data;
  }
}