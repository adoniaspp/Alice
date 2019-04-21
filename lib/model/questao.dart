import 'package:alice/alice.dart';
import 'alternativa.dart';
import 'unidade_tematica.dart';
import 'questionario_questao.dart';

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

  ManagedSet<Alternativa> alternativas;

  @Relate(#questoes)
  UnidadeTematica unidadetematica;

  ManagedSet<QuestionarioQuestao> questionarioQuestoes;



}