import 'package:flutter/cupertino.dart';
import 'package:vibration/vibration.dart';

class VibrationNotification {


 static vibrateMobile()async{
   try{

     if(await Vibration.hasVibrator()){
       Vibration.vibrate(amplitude: 128);
     }else{
       debugPrint("no vibration allowed");
     }
   }
   catch(e){
     debugPrint("Error in vibration ${e.toString()}");
   }

 }


}