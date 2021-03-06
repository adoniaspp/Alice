import 'dart:async';
import 'package:aqueduct/aqueduct.dart';   

class Migration13 extends Migration { 
  @override
  Future upgrade() async {
   		database.addColumn("_Alternativa", SchemaColumn.relationship("questaoObjetiva", ManagedPropertyType.bigInteger, relatedTableName: "_QuestaoObjetiva", relatedColumnName: "id", rule: DeleteRule.nullify, isNullable: true, isUnique: false));
  }
  
  @override
  Future downgrade() async {}
  
  @override
  Future seed() async {}
}
    