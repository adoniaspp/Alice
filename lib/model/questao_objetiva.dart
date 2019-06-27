import 'package:alice/alice.dart';

class QuestaoObjetiva extends ManagedObject<_QuestaoObjetiva> implements _QuestaoObjetiva{}

class _QuestaoObjetiva{

  @primaryKey
  int id;

  bool situacao;

  ManagedSet<Alternativa> alternativas;

  @Relate(#questaoObjetiva)
  Questao questao;

}