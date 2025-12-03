import '../../data/models/atendimento_model.dart';

abstract class AtendimentoState {}

class AtendimentoInitial extends AtendimentoState {}

class AtendimentoLoading extends AtendimentoState {}

class AtendimentoLoaded extends AtendimentoState {
  final List<AtendimentoModel> atendimentos;
  final String? filtroStatus;

  AtendimentoLoaded(this.atendimentos, {this.filtroStatus});
}

class AtendimentoError extends AtendimentoState {
  final String message;

  AtendimentoError(this.message);
}

class AtendimentoOperationSuccess extends AtendimentoState {
  final String message;

  AtendimentoOperationSuccess(this.message);
}
