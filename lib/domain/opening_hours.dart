class OpeningHours {
  OpeningHours({
    required this.sequencial,
    required this.horaInicial,
    required this.horaSaidaIntervalo,
    required this.horaRetornoIntervalo,
    required this.horaFechamento,
    required this.emAtendimento,
  });
  late int sequencial;
  late String horaInicial;
  late String horaSaidaIntervalo;
  late String horaRetornoIntervalo;
  late String horaFechamento;
  late bool emAtendimento;
  
  OpeningHours.fromJson(Map<String, dynamic> json){
    sequencial = json['sequencial'];
    horaInicial = json['hora_inicial'];
    horaSaidaIntervalo = json['hora_saida_intervalo'];
    horaRetornoIntervalo = json['hora_retorno_intervalo'];
    horaFechamento = json['hora_fechamento'];
    emAtendimento = json['em_atendimento'];
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['sequencial'] = sequencial;
    data['hora_inicial'] = horaInicial;
    data['hora_saida_intervalo'] = horaSaidaIntervalo;
    data['hora_retorno_intervalo'] = horaRetornoIntervalo;
    data['hora_fechamento'] = horaFechamento;
    data['em_atendimento'] = emAtendimento;
    return data;
  }
}