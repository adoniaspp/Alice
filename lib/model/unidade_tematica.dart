
import 'package:alice/alice.dart';
import 'questao.dart';

class UnidadeTematica extends ManagedObject<_UnidadeTematica> implements _UnidadeTematica{}

class _UnidadeTematica {
  @primaryKey
  int id;

  String descricao;

  DateTime dataCadastro;

  DateTime dataAtualizacao;

  ManagedSet<Questao> questoes;

  bool situacao;
}