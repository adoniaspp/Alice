import 'dart:async';
import 'package:aqueduct/aqueduct.dart';   

class Migration12 extends Migration { 
  @override
  Future upgrade() async {
   		database.deleteColumn("_Alternativa", "questao");
  }
  
  @override
  Future downgrade() async {}
  
  @override
  Future seed() async {}
}
    