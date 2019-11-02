import 'package:alice/alice.dart';

class QuestaoObjetivaController extends ResourceController{

  QuestaoObjetivaController(this.context);

  ManagedContext context;

@Operation.post()
Future<Response> criarQuestao() async{

  final bodyMap = request.body.as();
  final questao = await context.transaction((transaction) async {
    //Insere questão no BD
    final queryQuestao = Query<Questao>(transaction)
      ..values.enunciado = bodyMap["enunciado"].toString()
      ..values.situacao = true
      ..values.unidadetematica.id = int.parse(
          bodyMap["unidadetematica"].toString());
    final questao = await queryQuestao.insert();

      //Insere questãoObjetiva no BD
    final queryQuestaoObjetiva = Query<QuestaoObjetiva>(transaction);
    final questaoObjetiva = await queryQuestaoObjetiva.insert();

    //Insere as alternativas das questões no BD
    for (var alternativa in bodyMap["alternativas"]) {
      final alternativaQuery = Query<Alternativa>(transaction)
        ..values.descricao = alternativa[0].toString()
        ..values.resposta = alternativa[1].toString() == "false" ? false : true
        ..values.situacao = true
        ..values.questaoObjetiva.id = questaoObjetiva.id;
      await alternativaQuery.insert();
      return questao;
    }
  });
  return Response.ok(questao);
}

@Operation.get()
Future<Response> listarQuestoes() async{
  final query = Query<Questao>(context)
    ..where((q) => q.situacao).equalTo(true);
  final Query<QuestaoObjetiva> questaoObjetiva = query.join(object: (q) => q.questaoObjetiva);
  final Query<Alternativa> alternativaSubQuery = questaoObjetiva.join(set: (qo) => qo.alternativas)
      ..where((a) => a.situacao).equalTo(true)
      ..returningProperties((a) => [a.id, a.descricao, a.resposta]);
  final questoes = await query.fetch();
  return Response.ok(questoes);
}

@Operation.get('id')
Future<Response> obterQuestao(@Bind.path('id') int questaoId) async{
  var query = Query<Questao>(context)
    ..where((q) => q.id).equalTo(questaoId)
    ..where((q) => q.situacao).equalTo(true);
  final Query<QuestaoObjetiva> questaoObjetiva = query.join(object: (q) => q.questaoObjetiva);
  Query<Alternativa> alternativaSubQuery = questaoObjetiva.join(set: (qo) => qo.alternativas)
    ..where((a) => a.situacao).equalTo(true)
    ..returningProperties((a) => [a.id, a.descricao, a.resposta]);
  final questoes = await query.fetchOne();
  return Response.ok(questoes);
}

@Operation.put('id')
Future<Response> atualizarQuestao(@Bind.path('id') int questaoId) async{
  final bodyMap = request.body.as();
  final questao = await context.transaction((transaction) async {

    //Atualizar questão
    final questaoQuery = Query<Questao>(transaction)
      ..values.enunciado = bodyMap["enunciado"].toString()
      ..values.unidadetematica.id = int.parse(
          bodyMap["unidadetematica"].toString())
      ..where((q) => q.id).equalTo(questaoId);
    final questao = await questaoQuery.updateOne();

    //Atualizar antigas alternativas
    for (var alternativa in bodyMap["alternativas"]) {
      final alternativaQuery = Query<Alternativa>(transaction)
        ..values.descricao = alternativa[1].toString()
        ..values.resposta = alternativa[2].toString() == "false" ? false : true
        ..values.situacao = alternativa[3].toString() == "false" ? false : true
        ..where((a) => a.id).equalTo(int.parse(alternativa[0].toString()));
      await alternativaQuery.updateOne();
    }

    final questaoObjetivaQuery = Query<QuestaoObjetiva>(transaction)
      ..where((qo) => qo.questao.id).equalTo(questaoId)
      ..returningProperties((qo) => [qo.id]);
    final questaoObjetiva = await questaoObjetivaQuery.fetchOne();

    if((bodyMap["novasAlternativas"] as List).isNotEmpty){
      for (var alternativa in bodyMap["novasAlternativas"]) {
        final alternativaQuery = Query<Alternativa>(transaction)
          ..values.descricao = alternativa[0].toString()
          ..values.resposta = alternativa[1].toString() == "false" ? false : true
          ..values.situacao = true
          ..values.questaoObjetiva.id = questaoObjetiva.id;
        await alternativaQuery.insert();
      }
    }
    return questao;
  });
  return Response.ok(questao);
}

@Operation.delete('id')
Future<Response> excluirQuestao(@Bind.path('id') int questaoId) async{
  final questao = await context.transaction((transaction) async{
    final queryQuestoes = Query<Questao>(transaction)
      ..values.situacao = false
      ..where((q) => q.id).equalTo(questaoId);
    final questao = await queryQuestoes.updateOne();

    final queryQuestaoObjetiva = Query<QuestaoObjetiva>(transaction)
      ..where((qo) => qo.questao.id).equalTo(questaoId);
    final questaoObjetiva = await queryQuestaoObjetiva.updateOne();

    final queryAlternativas = Query<Alternativa>(transaction)
      ..values.situacao = false
      ..where((a) => a.questaoObjetiva.id).equalTo(questaoObjetiva.id);
    await queryAlternativas.update();
    return questao;
  });
  return Response.ok(questao);
}
}