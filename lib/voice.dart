import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioPlayerPage extends StatefulWidget {
  @override
  _AudioPlayerPageState createState() => _AudioPlayerPageState();
}

class _AudioPlayerPageState extends State<AudioPlayerPage> {
  late AudioPlayer _audioPlayer;
  double _playbackRate = 1.0;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playAudio() async {
    try {
      await _audioPlayer.play(AssetSource('audio/RPG_Battle_01.mp3'));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error playing audio: $e')),
      );
    }
  }

  void _stopAudio() async {
    await _audioPlayer.stop();
  }

  void _changePlaybackRate(double rateChange) {
    setState(() {
      _playbackRate = (_playbackRate + rateChange).clamp(0.5, 2.0);
    });
    _audioPlayer.setPlaybackRate(_playbackRate);
  }

  void _skipAudio(int seconds) async {
    Duration? currentPosition = await _audioPlayer.getCurrentPosition();
    if (currentPosition != null) {
      Duration newPosition = currentPosition + Duration(seconds: seconds);
      if (newPosition.inMilliseconds < 0) newPosition = Duration.zero;
      await _audioPlayer.seek(newPosition);
    }
  }

  Widget _buildButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Audio Player Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildButton('Play Audio', _playAudio),
            SizedBox(height: 16),
            _buildButton('Stop Audio', _stopAudio),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildButton('Slow Down', () => _changePlaybackRate(-0.5)),
                SizedBox(width: 16),
                _buildButton('Fast Forward', () => _changePlaybackRate(0.5)),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildButton('Skip Backward', () => _skipAudio(-10)),
                SizedBox(width: 16),
                _buildButton('Skip Forward', () => _skipAudio(10)),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Playback Rate: ${_playbackRate.toStringAsFixed(1)}x',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
