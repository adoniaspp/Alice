
import 'package:alice/alice.dart';

class Usuario extends ManagedObject<_Usuario> implements _Usuario{}

class _Usuario{

  @primaryKey
  int id;

  String nome;

  String cpf;

  String situacao;

  ManagedSet<UsuarioPerfil> usuariosPerfis;

  ManagedSet<Usuario> alunos;

  @Relate(#alunos)
  Usuario professor;

}