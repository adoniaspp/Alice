
import 'package:alice/alice.dart';

class Perfil extends ManagedObject<_Perfil> implements _Perfil{}

class _Perfil{

  @primaryKey
  int id;

  String descricao;

  bool situacao;

  DateTime dataCadastro;

  DateTime dataAtualizacao;

  ManagedSet<UsuarioPerfil> usuariosPerfis;

}