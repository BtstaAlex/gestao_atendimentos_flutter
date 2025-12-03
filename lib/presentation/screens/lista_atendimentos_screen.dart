import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/atendimento_model.dart';
import '../cubits/atendimento_cubit.dart';
import '../cubits/atendimento_state.dart';
import 'form_atendimento_screen.dart';
import 'realizar_atendimento_screen.dart';

class ListaAtendimentosScreen extends StatefulWidget {
  const ListaAtendimentosScreen({super.key});

  @override
  State<ListaAtendimentosScreen> createState() =>
      _ListaAtendimentosScreenState();
}

class _ListaAtendimentosScreenState extends State<ListaAtendimentosScreen> {
  String _filtroSelecionado = 'todos';

  @override
  void initState() {
    super.initState();
    context.read<AtendimentoCubit>().loadAtendimentos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestão de Atendimentos'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filtrar',
            onSelected: (value) {
              setState(() => _filtroSelecionado = value);
              context.read<AtendimentoCubit>().loadAtendimentos(
                    filtroStatus: value == 'todos' ? null : value,
                  );
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'todos', child: Text('Todos')),
              const PopupMenuItem(value: 'ativo', child: Text('Ativos')),
              const PopupMenuItem(
                  value: 'em_andamento', child: Text('Em Andamento')),
              const PopupMenuItem(
                  value: 'finalizado', child: Text('Finalizados')),
            ],
          ),
        ],
      ),
      body: BlocConsumer<AtendimentoCubit, AtendimentoState>(
        listener: (context, state) {
          if (state is AtendimentoError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }
          if (state is AtendimentoOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is AtendimentoLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AtendimentoLoaded) {
            if (state.atendimentos.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.assignment_outlined,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Nenhum atendimento encontrado',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Clique no + para criar um novo',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                await context.read<AtendimentoCubit>().loadAtendimentos(
                      filtroStatus: _filtroSelecionado == 'todos'
                          ? null
                          : _filtroSelecionado,
                    );
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: state.atendimentos.length,
                itemBuilder: (context, index) {
                  final atendimento = state.atendimentos[index];
                  return _buildAtendimentoCard(context, atendimento);
                },
              ),
            );
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Bem-vindo ao Gestão de Atendimentos'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<AtendimentoCubit>().loadAtendimentos();
                  },
                  child: const Text('Carregar Atendimentos'),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToForm(context),
        tooltip: 'Novo Atendimento',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildAtendimentoCard(
      BuildContext context, AtendimentoModel atendimento) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
      elevation: 2,
      child: ListTile(
        leading: _buildStatusIcon(atendimento.status),
        title: Text(
          atendimento.titulo,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              atendimento.descricao,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Criado em: ${_formatDate(atendimento.dataCriacao)}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ),
                if (atendimento.imagemPath != null)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.image,
                            size: 12, color: Colors.blue.shade700),
                        const SizedBox(width: 2),
                        Text(
                          'Foto',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton(
          icon: const Icon(Icons.more_vert),
          itemBuilder: (context) {
            List<PopupMenuEntry<String>> items = [
              const PopupMenuItem(
                value: 'ver',
                child: Row(
                  children: [
                    Icon(Icons.visibility, size: 20),
                    SizedBox(width: 8),
                    Text('Ver'),
                  ],
                ),
              ),
            ];

            if (atendimento.status == 'ativo') {
              items.add(const PopupMenuItem(
                value: 'iniciar',
                child: Row(
                  children: [
                    Icon(Icons.play_arrow, size: 20),
                    SizedBox(width: 8),
                    Text('Iniciar'),
                  ],
                ),
              ));
            }

            if (atendimento.status == 'em_andamento') {
              items.add(const PopupMenuItem(
                value: 'realizar',
                child: Row(
                  children: [
                    Icon(Icons.assignment_turned_in, size: 20),
                    SizedBox(width: 8),
                    Text('Realizar'),
                  ],
                ),
              ));
            }

            items.add(const PopupMenuItem(
              value: 'editar',
              child: Row(
                children: [
                  Icon(Icons.edit, size: 20),
                  SizedBox(width: 8),
                  Text('Editar'),
                ],
              ),
            ));

            if (atendimento.ativo) {
              items.add(const PopupMenuItem(
                value: 'excluir',
                child: Row(
                  children: [
                    Icon(Icons.delete, size: 20, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Excluir', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ));
            } else {
              items.add(const PopupMenuItem(
                value: 'ativar',
                child: Row(
                  children: [
                    Icon(Icons.check_circle, size: 20, color: Colors.green),
                    SizedBox(width: 8),
                    Text('Ativar', style: TextStyle(color: Colors.green)),
                  ],
                ),
              ));
            }

            return items;
          },
          onSelected: (value) => _handleMenuAction(context, value, atendimento),
        ),
      ),
    );
  }

  Widget _buildStatusIcon(String status) {
    IconData icon;
    Color color;

    switch (status) {
      case 'ativo':
        icon = Icons.circle;
        color = Colors.blue;
        break;
      case 'em_andamento':
        icon = Icons.play_circle;
        color = Colors.orange;
        break;
      case 'finalizado':
        icon = Icons.check_circle;
        color = Colors.green;
        break;
      default:
        icon = Icons.help;
        color = Colors.grey;
    }

    return Icon(icon, color: color, size: 32);
  }

  void _handleMenuAction(
      BuildContext context, String action, AtendimentoModel atendimento) {
    switch (action) {
      case 'ver':
        _showAtendimentoDetails(context, atendimento);
        break;
      case 'iniciar':
        context.read<AtendimentoCubit>().iniciarAtendimento(atendimento.id!);
        break;
      case 'realizar':
        _navigateToRealizarAtendimento(context, atendimento);
        break;
      case 'editar':
        _navigateToForm(context, atendimento: atendimento);
        break;
      case 'excluir':
        _confirmDelete(context, atendimento.id!);
        break;
      case 'ativar':
        context.read<AtendimentoCubit>().activateAtendimento(atendimento.id!);
        break;
    }
  }

  void _showAtendimentoDetails(
      BuildContext context, AtendimentoModel atendimento) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        atendimento.titulo,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow('Descrição', atendimento.descricao),
                      _buildDetailRow(
                          'Status', _getStatusText(atendimento.status)),
                      _buildDetailRow(
                          'Criado em', _formatDate(atendimento.dataCriacao)),
                      if (atendimento.dataFinalizacao != null)
                        _buildDetailRow('Finalizado em',
                            _formatDate(atendimento.dataFinalizacao!)),
                      if (atendimento.observacoes != null) ...[
                        const SizedBox(height: 8),
                        _buildDetailRow(
                            'Observações', atendimento.observacoes!),
                      ],
                      if (atendimento.imagemPath != null) ...[
                        const SizedBox(height: 16),
                        const Text(
                          'Imagem do Atendimento',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          constraints: const BoxConstraints(
                            maxHeight: 300,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(atendimento.imagemPath!),
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 150,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.broken_image,
                                            size: 40, color: Colors.grey),
                                        SizedBox(height: 8),
                                        Text('Erro ao carregar imagem'),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 45),
                  ),
                  child: const Text('Fechar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          const SizedBox(height: 2),
          Text(value),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: const Text('Deseja realmente excluir este atendimento?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AtendimentoCubit>().deleteAtendimento(id);
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _navigateToForm(BuildContext context,
      {AtendimentoModel? atendimento}) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => FormAtendimentoScreen(atendimento: atendimento),
      ),
    );

    if (result == true && mounted) {
      context.read<AtendimentoCubit>().loadAtendimentos(
            filtroStatus:
                _filtroSelecionado == 'todos' ? null : _filtroSelecionado,
          );
    }
  }

  Future<void> _navigateToRealizarAtendimento(
      BuildContext context, AtendimentoModel atendimento) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            RealizarAtendimentoScreen(atendimento: atendimento),
      ),
    );

    if (result == true && mounted) {
      context.read<AtendimentoCubit>().loadAtendimentos(
            filtroStatus:
                _filtroSelecionado == 'todos' ? null : _filtroSelecionado,
          );
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'ativo':
        return 'Ativo';
      case 'em_andamento':
        return 'Em Andamento';
      case 'finalizado':
        return 'Finalizado';
      default:
        return status;
    }
  }
}
