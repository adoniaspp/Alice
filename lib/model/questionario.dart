
import 'package:alice/alice.dart';
import 'questionario_questao.dart';

class Questionario extends ManagedObject<_Questionario> implements _Questionario{}

class _Questionario{

  @primaryKey
  int id;

  String descricao;

  bool situacao;

  ManagedSet<QuestionarioQuestao> questionarioQuestoes;

}