import 'package:alice/alice.dart';

class QuestionarioController extends ResourceController{

  QuestionarioController(this.context){}

  ManagedContext context;

  @Operation.post()
  Future<Response> criarQuestionario() async{
  }

  @Operation.get()
  Future<Response> listarQuestionarios() async{

  }

  @Operation.get('id')
  Future<Response> obterQuestionario() async{

  }

  @Operation.put('id')
  Future<Response> atualizarQuestionario(@Bind.path('id') int questionarioId){

  }

  @Operation.delete('id')
  Future<Response> excluirQuestionario(@Bind.path('id') int questionarioId){

  }


}