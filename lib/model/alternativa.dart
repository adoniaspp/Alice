
import 'package:alice/alice.dart';
import 'questao.dart';

class Alternativa extends ManagedObject<_Alternativa> implements _Alternativa{}

class _Alternativa{

  @primaryKey
  int id;

  @Validate.present(onInsert: true)
  String descricao;

  bool resposta;

  bool situacao;

  DateTime dataCadastro;

  DateTime dataAtualizacao;

  @Relate(#alternativas)
  Questao questao;

}
