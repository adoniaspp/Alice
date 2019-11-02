import 'package:alice/alice.dart';

class QuestaoObjetivaController extends ResourceController{

  QuestaoObjetivaController(this.context);

  ManagedContext context;

@Operation.post('questaoId')
Future<Response> criarQuestao(@Bind.path('questaoId') int idQuestao) async{

  final questaoObjetiva = await context.transaction((transaction) async {
    final queryQuestao = Query<QuestaoObjetiva>(transaction)
      ..values.questao.id = idQuestao;
    await queryQuestao.insert();
  });
  return Response.ok(questaoObjetiva);
}

@Operation.get('questaoId')
Future<Response> listarQuestoesObjetivas(@Bind.path('questaoId') int idQuestao) async{
  final query = Query<QuestaoObjetiva>(context)
    ..where((q) => q.questao.id).equalTo(idQuestao);
  final questoes = await query.fetch();
  return Response.ok(questoes);
}

@Operation.get('questaoId', 'objetivaId')
Future<Response> obterQuestao(@Bind.path('id') int questaoId, @Bind.path('objetivaId') int objetivaId) async{
  final query = Query<QuestaoObjetiva>(context)
    ..where((q) => q.id).equalTo(objetivaId)
    ..where((q) => q.questao.id).equalTo(questaoId);
  final questoes = await query.fetchOne();
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
    var questao = await questaoQuery.updateOne();

    //Atualizar antigas alternativas
    for (var alternativa in bodyMap["alternativas"]) {
      var alternativaQuery = Query<Alternativa>(transaction)
        ..values.descricao = alternativa[1].toString()
        ..values.resposta = alternativa[2].toString() == "false" ? false : true
        ..values.situacao = alternativa[3].toString() == "false" ? false : true
        ..where((a) => a.id).equalTo(int.parse(alternativa[0].toString()));
      await alternativaQuery.updateOne();
    }

    var questaoObjetivaQuery = Query<QuestaoObjetiva>(transaction)
      ..where((qo) => qo.questao.id).equalTo(questaoId)
      ..returningProperties((qo) => [qo.id]);
    var questaoObjetiva = await questaoObjetivaQuery.fetchOne();

    if((bodyMap["novasAlternativas"] as List).isNotEmpty){
      for (var alternativa in bodyMap["novasAlternativas"]) {
        var alternativaQuery = Query<Alternativa>(transaction)
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
    var queryQuestoes = Query<Questao>(transaction)
      ..values.situacao = false
      ..where((q) => q.id).equalTo(questaoId);
    var questao = await queryQuestoes.updateOne();

    var queryQuestaoObjetiva = Query<QuestaoObjetiva>(transaction)
      ..where((qo) => qo.questao.id).equalTo(questaoId);
    var questaoObjetiva = await queryQuestaoObjetiva.updateOne();

    var queryAlternativas = Query<Alternativa>(transaction)
      ..values.situacao = false
      ..where((a) => a.questaoObjetiva.id).equalTo(questaoObjetiva.id);
    await queryAlternativas.update();
    return questao;
  });
  return Response.ok(questao);
}
}