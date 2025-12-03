import '../datasources/database_helper.dart';
import '../models/atendimento_model.dart';

class AtendimentoRepository {
  final DatabaseHelper _databaseHelper;

  AtendimentoRepository(this._databaseHelper);

  Future<int> createAtendimento(AtendimentoModel atendimento) async {
    return await _databaseHelper.create(atendimento);
  }

  Future<AtendimentoModel?> getAtendimento(int id) async {
    return await _databaseHelper.read(id);
  }

  Future<List<AtendimentoModel>> getAllAtendimentos() async {
    return await _databaseHelper.readAll();
  }

  Future<List<AtendimentoModel>> getAtendimentosByStatus(String status) async {
    return await _databaseHelper.readByStatus(status);
  }

  Future<int> updateAtendimento(AtendimentoModel atendimento) async {
    return await _databaseHelper.update(atendimento);
  }

  Future<int> deleteAtendimento(int id) async {
    return await _databaseHelper.delete(id);
  }

  Future<int> softDeleteAtendimento(int id) async {
    return await _databaseHelper.softDelete(id);
  }

  Future<int> activateAtendimento(int id) async {
    return await _databaseHelper.activate(id);
  }

  Future<int> finalizarAtendimento(
    int id,
    String? imagemPath,
    String? observacoes,
  ) async {
    final atendimento = await getAtendimento(id);
    if (atendimento == null) return 0;

    final updated = atendimento.copyWith(
      status: 'finalizado',
      imagemPath: imagemPath,
      observacoes: observacoes,
      dataFinalizacao: DateTime.now(),
    );

    return await updateAtendimento(updated);
  }

  Future<int> iniciarAtendimento(int id) async {
    final atendimento = await getAtendimento(id);
    if (atendimento == null) return 0;

    final updated = atendimento.copyWith(status: 'em_andamento');
    return await updateAtendimento(updated);
  }
}
