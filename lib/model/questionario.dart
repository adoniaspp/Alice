
import 'package:alice/alice.dart';
import 'questionario_questao.dart';

class Questionario extends ManagedObject<_Questionario> implements _Questionario{}

class _Questionario{

  @primaryKey
  int id;

  @Column(nullable: false)
  @Validate.present(onInsert: true, onUpdate: false)
  String descricao;

  bool situacao;

  ManagedSet<QuestionarioQuestao> questionarioQuestoes;

}