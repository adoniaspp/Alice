
import 'package:alice/alice.dart';
import 'package:aqueduct/managed_auth.dart';

class Usuario extends ManagedObject<_Usuario> implements _Usuario, ManagedAuthResourceOwner<_Usuario>{}

class _Usuario extends ResourceOwnerTableDefinition{

  @primaryKey
  int id;

  @Column(nullable: false)
  @Validate.present(onInsert: true)
  String nome;

  @Column(nullable: false)
  @Validate.length(lessThan: 11)
  @Validate.matches("[0-9]{3}\.?[0-9]{3}\.?[0-9]{3}\-?[0-9]{2}")
  @Validate.present(onInsert: true, onUpdate: false)
  String cpf;

  @Column(unique: true)
  String nomeUsuario;

  bool situacao;

  DateTime dataCadastro;

  DateTime dataAtualizacao;


  ManagedSet<UsuarioPerfil> usuariosPerfis;

  ManagedSet<Usuario> alunos;

  @Relate(#alunos)
  Usuario professor;

}