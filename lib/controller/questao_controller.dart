import 'package:alice/alice.dart';

class QuestaoController extends ResourceController{

  QuestaoController(this.context){}

  ManagedContext context;

@Operation.post()
Future<Response> criarQuestao() async{

  Map<String, dynamic> bodyMap = request.body.as();

  //Insere questão no BD
  final queryQuestao = Query<Questao>(context)
    ..values.enunciado = bodyMap["enunciado"].toString()
    ..values.unidadetematica.id = int.parse(bodyMap["unidade"].toString());
  final questao = await queryQuestao.insert();

  //Insere as alternativas das questões no BD

  for(var alternativa in bodyMap["alternativas"]){
    var alternativaQuery = Query<Alternativa>(context)
      ..values.descricao = alternativa.toString()
      ..values.questao.id = questao.id;
    var alternativaResult = await alternativaQuery.insert();
  }
  return Response.ok(questao);
}

}