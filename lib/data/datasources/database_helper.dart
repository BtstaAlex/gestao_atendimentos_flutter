import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/atendimento_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('atendimentos.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const intType = 'INTEGER NOT NULL';

    await db.execute('''
      CREATE TABLE atendimentos (
        id $idType,
        titulo $textType,
        descricao $textType,
        status $textType,
        ativo $intType,
        imagemPath TEXT,
        observacoes TEXT,
        dataCriacao $textType,
        dataFinalizacao TEXT
      )
    ''');
  }

  Future<int> create(AtendimentoModel atendimento) async {
    final db = await database;
    return await db.insert('atendimentos', atendimento.toMap());
  }

  Future<AtendimentoModel?> read(int id) async {
    final db = await database;
    final maps = await db.query(
      'atendimentos',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return AtendimentoModel.fromMap(maps.first);
    }
    return null;
  }

  Future<List<AtendimentoModel>> readAll() async {
    final db = await database;
    const orderBy = 'dataCriacao DESC';
    final result = await db.query(
      'atendimentos',
      where: 'ativo = 1',
      orderBy: orderBy,
    );
    return result.map((json) => AtendimentoModel.fromMap(json)).toList();
  }

  Future<List<AtendimentoModel>> readByStatus(String status) async {
    final db = await database;
    final result = await db.query(
      'atendimentos',
      where: 'status = ? AND ativo = 1',
      whereArgs: [status],
      orderBy: 'dataCriacao DESC',
    );
    return result.map((json) => AtendimentoModel.fromMap(json)).toList();
  }

  Future<int> update(AtendimentoModel atendimento) async {
    final db = await database;
    return db.update(
      'atendimentos',
      atendimento.toMap(),
      where: 'id = ?',
      whereArgs: [atendimento.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await database;
    return await db.delete(
      'atendimentos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> softDelete(int id) async {
    final db = await database;
    return await db.update(
      'atendimentos',
      {'ativo': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> activate(int id) async {
    final db = await database;
    return await db.update(
      'atendimentos',
      {'ativo': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}
