import 'package:alice/alice.dart';

class TipoQuestao extends ManagedObject<_TipoQuestao> implements _TipoQuestao{}

class _TipoQuestao{

  @primaryKey
  int id;

  String descricao;

  ManagedSet<Questao> questoes;

}