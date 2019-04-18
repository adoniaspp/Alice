
import 'package:alice/alice.dart';

class UsuarioPerfil extends ManagedObject<_UsuarioPerfil> implements _UsuarioPerfil{}

class _UsuarioPerfil{

  @primaryKey
  int id;

  @Relate(#usuariosPerfis)
  Perfil perfil;

  @Relate(#usuariosPerfis)
  Usuario usuario;
}