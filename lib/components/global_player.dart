import 'package:just_audio/just_audio.dart';

class GlobalPlayer {
  GlobalPlayer._();
  static final GlobalPlayer instance = GlobalPlayer._();
  final AudioPlayer player = AudioPlayer();
}