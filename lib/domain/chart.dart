class ChartEntity {
  ChartEntity({
    required this.mes,
    required this.totalAgendamentos,
    required this.valorTotal,
  });
  late String mes;
  late dynamic totalAgendamentos;
  late dynamic valorTotal;
  
  ChartEntity.fromJson(Map<String, dynamic> json){
    mes = json['mes'];
    totalAgendamentos = json['total_agendamentos'];
    valorTotal = json['valor_total'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['mes'] = mes;
    data['total_agendamentos'] = totalAgendamentos;
    data['valor_total'] = valorTotal;
    return data;
  }
}