class AtendimentoModel {
  final int? id;
  final String titulo;
  final String descricao;
  final String status;
  final bool ativo;
  final String? imagemPath;
  final String? observacoes;
  final DateTime dataCriacao;
  final DateTime? dataFinalizacao;

  AtendimentoModel({
    this.id,
    required this.titulo,
    required this.descricao,
    required this.status,
    this.ativo = true,
    this.imagemPath,
    this.observacoes,
    required this.dataCriacao,
    this.dataFinalizacao,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'status': status,
      'ativo': ativo ? 1 : 0,
      'imagemPath': imagemPath,
      'observacoes': observacoes,
      'dataCriacao': dataCriacao.toIso8601String(),
      'dataFinalizacao': dataFinalizacao?.toIso8601String(),
    };
  }

  factory AtendimentoModel.fromMap(Map<String, dynamic> map) {
    return AtendimentoModel(
      id: map['id'],
      titulo: map['titulo'],
      descricao: map['descricao'],
      status: map['status'],
      ativo: map['ativo'] == 1,
      imagemPath: map['imagemPath'],
      observacoes: map['observacoes'],
      dataCriacao: DateTime.parse(map['dataCriacao']),
      dataFinalizacao: map['dataFinalizacao'] != null
          ? DateTime.parse(map['dataFinalizacao'])
          : null,
    );
  }

  AtendimentoModel copyWith({
    int? id,
    String? titulo,
    String? descricao,
    String? status,
    bool? ativo,
    String? imagemPath,
    String? observacoes,
    DateTime? dataCriacao,
    DateTime? dataFinalizacao,
  }) {
    return AtendimentoModel(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descricao: descricao ?? this.descricao,
      status: status ?? this.status,
      ativo: ativo ?? this.ativo,
      imagemPath: imagemPath ?? this.imagemPath,
      observacoes: observacoes ?? this.observacoes,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      dataFinalizacao: dataFinalizacao ?? this.dataFinalizacao,
    );
  }
}
