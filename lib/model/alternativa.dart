
import 'package:alice/alice.dart';
import 'questao.dart';

class Alternativa extends ManagedObject<_Alternativa> implements _Alternativa{}

class _Alternativa{

  @primaryKey
  int id;

  String descricao;

  @Relate(#alternativas)
  Questao questao;
}
