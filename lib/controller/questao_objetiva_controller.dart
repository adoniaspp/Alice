import 'package:alice/alice.dart';

class QuestaoObjetivaController extends ResourceController{

  QuestaoObjetivaController(this.context){}

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
    final queryQuestaoObjetiva = Query<QuestaoObjetiva>(transaction)
        ..values.situacao = true;
    final questaoObjetiva = await queryQuestaoObjetiva.insert();

    //Insere as alternativas das questões no BD
    for (var alternativa in bodyMap["alternativas"]) {
      var alternativaQuery = Query<Alternativa>(transaction)
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
  var query = Query<Questao>(context)
    ..where((q) => q.situacao).equalTo(true);
  Query<QuestaoObjetiva> questaoObjetiva = query.join(object: (q) => q.questaoObjetiva)
    ..where((qo) => qo.situacao).equalTo(true);
  Query<Alternativa> alternativaSubQuery = questaoObjetiva.join(set: (qo) => qo.alternativas)
      ..where((a) => a.situacao).equalTo(true)
      ..returningProperties((a) => [a.id, a.descricao, a.resposta]);
  var questoes = await query.fetch();
  return Response.ok(questoes);
}

@Operation.get('id')
Future<Response> obterQuestao(@Bind.path('id') int questaoId) async{
  var query = Query<Questao>(context)
    ..where((q) => q.id).equalTo(questaoId)
    ..where((q) => q.situacao).equalTo(true);
    Query<Alternativa> alternativaSubQuery = query.join(set: (q) => q.alternativas)
    ..where((a) => a.situacao).equalTo(true)
    ..returningProperties((a) => [a.id, a.descricao, a.resposta]);
  var questoes = await query.fetch();
  return Response.ok(questoes);
}

@Operation.put('id')
Future<Response> atualizarQuestao(@Bind.path('id') int questaoId) async{
  final bodyMap = request.body.as();
  final questao = await context.transaction((transaction) async {

    //Atualizar questão
    var questaoQuery = Query<Questao>(transaction)
      ..values.enunciado = bodyMap["enunciado"].toString()
      ..values.unidadetematica.id = int.parse(
          bodyMap["unidadetematica"].toString())
      ..where((q) => q.id).equalTo(questaoId);
    final questao = await questaoQuery.updateOne();

    //Atualizar antigas questões
    for (var alternativa in bodyMap["alternativas"]) {
      var alternativaQuery = Query<Alternativa>(transaction)
        ..values.descricao = alternativa[1].toString()
        ..values.resposta = alternativa[2].toString() == "false" ? false : true
        ..values.situacao = alternativa[3].toString() == "false" ? false : true
        ..where((a) => a.id).equalTo(int.parse(alternativa[0].toString()));
      await alternativaQuery.updateOne();
    }

    if((bodyMap["novasAlternativas"] as List).isNotEmpty){
      for (var alternativa in bodyMap["novasAlternativas"]) {
        var alternativaQuery = Query<Alternativa>(transaction)
          ..values.descricao = alternativa[0].toString()
          ..values.resposta = alternativa[1].toString() == "false" ? false : true
          ..values.situacao = true
          ..values.questao.id = questaoId;
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
    var queryQuestoes = Query<Questao>(transaction)
      ..values.situacao = false
      ..where((q) => q.id).equalTo(questaoId);
    final questao = await queryQuestoes.updateOne();
    var queryAlternativas = Query<Alternativa>(transaction)
      ..values.situacao = false
      ..where((a) => a.questao.id).equalTo(questaoId);
    await queryAlternativas.update();
    return questao;
  });
  return Response.ok(questao);
}
}