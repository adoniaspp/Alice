
import 'package:alice/alice.dart';
import 'questao.dart';
import 'questionario.dart';

class QuestionarioQuestao extends ManagedObject<_QuestionarioQuestao> implements _QuestionarioQuestao{}

class _QuestionarioQuestao{

  @primaryKey
  int id;

  @Relate(#questionarioQuestoes)
  Questao questao;

  @Relate(#questionarioQuestoes)
  Questionario questionario;


}