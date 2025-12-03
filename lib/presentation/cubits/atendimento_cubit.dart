import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/atendimento_model.dart';
import '../../data/repositories/atendimento_repository.dart';
import 'atendimento_state.dart';

class AtendimentoCubit extends Cubit<AtendimentoState> {
  final AtendimentoRepository _repository;
  String? _currentFilter;

  AtendimentoCubit(this._repository) : super(AtendimentoInitial());

  Future<void> loadAtendimentos({String? filtroStatus}) async {
    emit(AtendimentoLoading());
    try {
      _currentFilter = filtroStatus;

      List<AtendimentoModel> atendimentos;

      if (filtroStatus != null && filtroStatus != 'todos') {
        atendimentos = await _repository.getAtendimentosByStatus(filtroStatus);
      } else {
        atendimentos = await _repository.getAllAtendimentos();
      }

      emit(AtendimentoLoaded(atendimentos, filtroStatus: filtroStatus));
    } catch (e) {
      emit(AtendimentoError('Erro ao carregar atendimentos: $e'));
    }
  }

  Future<void> createAtendimento(AtendimentoModel atendimento) async {
    try {
      await _repository.createAtendimento(atendimento);
      await loadAtendimentos(filtroStatus: _currentFilter);
      emit(AtendimentoOperationSuccess('Atendimento criado com sucesso!'));
    } catch (e) {
      emit(AtendimentoError('Erro ao criar atendimento: $e'));
    }
  }

  Future<void> updateAtendimento(AtendimentoModel atendimento) async {
    try {
      await _repository.updateAtendimento(atendimento);
      await loadAtendimentos(filtroStatus: _currentFilter);
      emit(AtendimentoOperationSuccess('Atendimento atualizado com sucesso!'));
    } catch (e) {
      emit(AtendimentoError('Erro ao atualizar atendimento: $e'));
    }
  }

  Future<void> deleteAtendimento(int id) async {
    try {
      await _repository.softDeleteAtendimento(id);
      await loadAtendimentos(filtroStatus: _currentFilter);
      emit(AtendimentoOperationSuccess('Atendimento excluído com sucesso!'));
    } catch (e) {
      emit(AtendimentoError('Erro ao excluir atendimento: $e'));
    }
  }

  Future<void> activateAtendimento(int id) async {
    try {
      await _repository.activateAtendimento(id);
      await loadAtendimentos(filtroStatus: _currentFilter);
      emit(AtendimentoOperationSuccess('Atendimento ativado com sucesso!'));
    } catch (e) {
      emit(AtendimentoError('Erro ao ativar atendimento: $e'));
    }
  }

  Future<void> iniciarAtendimento(int id) async {
    try {
      await _repository.iniciarAtendimento(id);
      await loadAtendimentos(filtroStatus: _currentFilter);
      emit(AtendimentoOperationSuccess('Atendimento iniciado!'));
    } catch (e) {
      emit(AtendimentoError('Erro ao iniciar atendimento: $e'));
    }
  }

  Future<void> finalizarAtendimento(
    int id,
    String? imagemPath,
    String? observacoes,
  ) async {
    try {
      await _repository.finalizarAtendimento(id, imagemPath, observacoes);
      await loadAtendimentos(filtroStatus: _currentFilter);
      emit(AtendimentoOperationSuccess('Atendimento finalizado com sucesso!'));
    } catch (e) {
      emit(AtendimentoError('Erro ao finalizar atendimento: $e'));
    }
  }
}
