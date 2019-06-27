import 'dart:async';
import 'package:aqueduct/aqueduct.dart';   

class Migration10 extends Migration { 
  @override
  Future upgrade() async {
   		database.deleteColumn("_Questao", "questaoObjetiva");
  }
  
  @override
  Future downgrade() async {}
  
  @override
  Future seed() async {}
}
    