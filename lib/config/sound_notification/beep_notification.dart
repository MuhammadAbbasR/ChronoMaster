import 'package:chronomaster_pro/config/constants/sound_notifcation_constants.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

 class BeepNotification {

  final _player = AudioPlayer();


 Future<void> init() async {
   debugPrint("Initialization Beep working");
   try{
     await _player.setVolume(0.5);
     await _player.setAsset(SoundNotificationConstants.beepStart);
     _player.play();

   }
   catch(e){
     debugPrint(e.toString());
   }

  }

  Future<void> playStartBeep() async {
    debugPrint("Start Beep working");
   try{
     await _player.setAsset(SoundNotificationConstants.beepStart);
      _player.seek(Duration.zero);
      _player.setVolume(0.5);
      _player.play();
    // _player.stop();
   }
   catch(e){
     debugPrint(e.toString());
   }

  }

  Future<void> playEndBeep() async {
    debugPrint("End Beep working");
   try{
     await  _player.setAsset(SoundNotificationConstants.beepEnd);
      _player.seek(Duration.zero);
      _player.setVolume(0.5);
      _player.play();
   //  _player.stop();
   }
   catch(e){
     debugPrint(e.toString());
   }

  }

  void stopPlayer(){
   try{
     _player.stop();
   }
   catch(e){
     debugPrint(e.toString());
   }

  }

  void disposePlayer() {
    _player.dispose();
  }

}