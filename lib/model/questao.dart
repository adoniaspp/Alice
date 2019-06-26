import 'package:alice/alice.dart';

class Questao extends ManagedObject<_Questao> implements _Questao{}

class _Questao {

  @primaryKey
  int id;

  @Column(nullable: false)
  @Validate.present(onInsert: true, onUpdate: false)
  String enunciado;

  bool situacao;

  DateTime dataCadastro;

  DateTime dataAtualizacao;

  QuestaoObjetiva questaoObjetiva;

  @Relate(#questoes)
  UnidadeTematica unidadetematica;

  @Relate(#questoes)
  TipoQuestao tipoQuestao;

  ManagedSet<QuestionarioQuestao> questionarioQuestoes;



}