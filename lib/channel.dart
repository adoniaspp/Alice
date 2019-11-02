import 'alice.dart';


class AliceChannel extends ApplicationChannel {
  ManagedContext context;

  @override
  Future prepare() async {
    final config = MyConfiguration(options.configurationFilePath);
    final dataModel = ManagedDataModel.fromCurrentMirrorSystem();
    final psc = PostgreSQLPersistentStore.fromConnectionInfo(
        config.database.username,
        config.database.password,
        config.database.host,
        config.database.port,
        config.database.databaseName);
    context = ManagedContext(dataModel, psc);
    logger.onRecord.listen((rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));
  }


  @override
  Controller get entryPoint {
    final router = Router();


    router
      .route("/example")
      .linkFunction((request) async {
        return Response.ok({"key": "value"});
      });
    
    router  //ok
      .route("/unidade/[:id]")
      .link(()=> ManagedObjectController<UnidadeTematica>(context));

    router //ok
      .route("/tipoquestao/[:id]")
      .link(()=> ManagedObjectController<TipoQuestao>(context));

    router
        .route("/questionario/[:id]")
        .link(()=> ManagedObjectController<Questionario>(context));

    router
        .route("/usuario/[:id]")
        .link(()=> ManagedObjectController<Usuario>(context));

    router
        .route("/perfil/[:id]")
        .link(()=> ManagedObjectController<Perfil>(context));

    router
        .route("/questao/[:id]")
        .link(()=> ManagedObjectController<Questao>(context));

    router
        .route("/questao/:questaoId/questaoobjetiva/[:id]")
        .link(() => QuestaoObjetivaController(context));
    
    router
        .route("/questaoobjetiva/:objetivaId/alternativas/[:id]")
        .link(() => AlternativasController(context));

    return router;
  }
}

class MyConfiguration extends Configuration {
  MyConfiguration(String configPath) : super.fromFile(File(configPath));

  DatabaseConfiguration database;
}