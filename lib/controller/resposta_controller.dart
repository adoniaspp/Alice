import 'package:alice/alice.dart';

class RespostaController extends ResourceController{

  ManagedContext context;

  RespostaController(this.context){}

  @Operation.post()
  Future<Response> responderQuestao() async{

    final bodyMap = request.body.as();
    final resultado = await context.transaction((transaction) async{

      //TODO: Obter a alternativa correta da questão
      //TODO: Verificar se é a mesma que o usuário marcou
      //TODO: Se sim ou se não, grava na tabela de resultado e
      //TODO: retorna para o usuário a resposta.
    });

  }

}