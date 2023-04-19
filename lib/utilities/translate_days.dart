translateDaysOfWeek(String day){
    switch (day) {
      case 'Monday':
        return 'Seg';
      case 'Tuesday':
        return 'Ter';
      case 'Wednesday':
        return 'Qua';
      case 'Thursday':
        return 'Qui';
      case 'Friday':
        return 'Sex';
      case 'Saturday':
        return 'Sáb';
      case 'Sunday':
        return 'Dom';
      default:
        return 'Erro';
    }
  }

translateDaysOfWeekFull(String day){
    switch (day) {
      case 'Monday':
        return 'Segunda-feira';
      case 'Tuesday':
        return 'Terça-feira';
      case 'Wednesday':
        return 'Quarta-feira';
      case 'Thursday':
        return 'Quinta-feira';
      case 'Friday':
        return 'Sexta-feira';
      case 'Saturday':
        return 'Sábado';
      case 'Sunday':
        return 'Domingo';
      default:
        return 'Erro';
    }
  }