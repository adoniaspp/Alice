import 'package:alice/alice.dart';

class QuestaoController extends ResourceController{

  QuestaoController(this.context){}

  ManagedContext context;

@Operation.post()
Future<Response> criarQuestao() async{

  final bodyMap = request.body.as();

  //Insere questão no BD
  final queryQuestao = Query<Questao>(context)
    ..values.enunciado = bodyMap["enunciado"].toString()
    ..values.unidadetematica.id = int.parse(bodyMap["unidade"].toString());
  final questao = await queryQuestao.insert();

  //Insere as alternativas das questões no BD
  for(var alternativa in bodyMap["alternativas"]){
      var alternativaQuery = Query<Alternativa>(context)
        ..values.descricao = alternativa[0].toString()
        ..values.resposta = alternativa[1].toString() == "false" ? false : true
        ..values.questao.id = questao.id;
      var alternativaResult = await alternativaQuery.insert();
  }
  //print(bodyMap);
  return Response.ok({"key": "value"});
}

@Operation.get()
Future<Response> listarQuestoes() async{
  var query = Query<Questao>(context)
    ..join(set: (q) => q.alternativas)
        .returningProperties((a) => [a.id, a.descricao, a.resposta]);
  var questoes = await query.fetch();
  return Response.ok(questoes);
}

@Operation.get('id')
Future<Response> obterQuestao(@Bind.path('id') int questaoId) async{
  var query = Query<Questao>(context)
    ..where((q) => q.id).equalTo(questaoId)
    ..join(set: (q) => q.alternativas)
        .returningProperties((a) => [a.id, a.descricao, a.resposta]);
  var questoes = await query.fetch();
  return Response.ok(questoes);
}

@Operation.put('id')
Future<Response> atualizarQuestao(@Bind.path('id') int questaoId) async{
  final bodyMap = request.body.as();
  var query = Query<Questao>(context)
    ..values.enunciado = bodyMap["enunciado"].toString()
    ..values.unidadetematica.id = int.parse(bodyMap["unidadetematica"].toString())
    ..where((q) => q.id).equalTo(questaoId);
  final questao = await query.updateOne();

  for(var alternativa in bodyMap["alternativas"]){
    var alternativaQuery = Query<Alternativa>(context)
      ..values.descricao = alternativa[1].toString()
      ..values.resposta = alternativa[2].toString() == "false" ? false : true
      ..where((a) => a.id).equalTo(int.parse(alternativa[0].toString()));
    var alternativaResult = await alternativaQuery.updateOne();
  }
  return Response.ok(questao);
}

@Operation.delete('id')
Future<Response> excluirQuestao(@Bind.query('id') int questaoId) async{
  return Response.ok({"key": "value"});
}

}