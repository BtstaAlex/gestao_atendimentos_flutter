import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/atendimento_model.dart';
import '../cubits/atendimento_cubit.dart';

class FormAtendimentoScreen extends StatefulWidget {
  final AtendimentoModel? atendimento;

  const FormAtendimentoScreen({super.key, this.atendimento});

  @override
  State<FormAtendimentoScreen> createState() => _FormAtendimentoScreenState();
}

class _FormAtendimentoScreenState extends State<FormAtendimentoScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _tituloController;
  late TextEditingController _descricaoController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tituloController =
        TextEditingController(text: widget.atendimento?.titulo ?? '');
    _descricaoController =
        TextEditingController(text: widget.atendimento?.descricao ?? '');
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.atendimento != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Editar Atendimento' : 'Novo Atendimento'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  TextFormField(
                    controller: _tituloController,
                    decoration: const InputDecoration(
                      labelText: 'Título',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira um título';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descricaoController,
                    decoration: const InputDecoration(
                      labelText: 'Descrição',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 5,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira uma descrição';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _saveAtendimento,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                    ),
                    child: Text(isEdit ? 'Atualizar' : 'Criar'),
                  ),
                ],
              ),
            ),
    );
  }

  Future<void> _saveAtendimento() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final atendimento = AtendimentoModel(
        id: widget.atendimento?.id,
        titulo: _tituloController.text,
        descricao: _descricaoController.text,
        status: widget.atendimento?.status ?? 'ativo',
        ativo: widget.atendimento?.ativo ?? true,
        dataCriacao: widget.atendimento?.dataCriacao ?? DateTime.now(),
        imagemPath: widget.atendimento?.imagemPath,
        observacoes: widget.atendimento?.observacoes,
        dataFinalizacao: widget.atendimento?.dataFinalizacao,
      );

      try {
        if (widget.atendimento != null) {
          await context.read<AtendimentoCubit>().updateAtendimento(atendimento);
        } else {
          await context.read<AtendimentoCubit>().createAtendimento(atendimento);
        }

        if (mounted) {
          Navigator.pop(context, true); 
        }
      } catch (e) {
        if (mounted) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao salvar: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}
