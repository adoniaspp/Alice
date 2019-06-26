import 'package:alice/alice.dart';

class QuestaoObjetiva extends ManagedObject<_QuestaoObjetiva> implements _QuestaoObjetiva{}

class _QuestaoObjetiva{

  @primaryKey
  int id;

  ManagedSet<Alternativa> alternativas;

  @Relate(#questaoObjetiva)
  Questao questao;

}