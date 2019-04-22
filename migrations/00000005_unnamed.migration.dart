import 'dart:async';
import 'package:aqueduct/aqueduct.dart';   

class Migration5 extends Migration { 
  @override
  Future upgrade() async {
   		database.deleteColumn("_Usuario", "situacao");
  }
  
  @override
  Future downgrade() async {}
  
  @override
  Future seed() async {}
}
    