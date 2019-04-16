
import 'package:alice/alice.dart';

class UnidadeController extends ResourceController{

  UnidadeController(this.context){}

  ManagedContext context;

  @Operation.get()
  Future<Response> insertUnidade() async{
    final query = Query<UnidadeTematica>(context)
        ..values.descricao = "Língua Portuguesa";
    final unidadeTematica = await query.insert();
    //Map<String, dynamic> map = unidadeTematica.asMap();
    return Response.ok(unidadeTematica);
  }

}