import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'card_model.dart';
import 'memory_card_widget.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  late ConfettiController _confettiController;

  List<CarCardModel> _cards = [];
  int _firstSelectedIndex = -1;
  bool _isProcessing = false;
  int _moves = 0;
  int _matchesFound = 0;
  bool _gameCompleted = false;

  final List<String> _carNames = [
    'Ferrari', 'Lamborghini', 'Porsche', 'McLaren',
    'Bugatti', 'Aston Martin', 'Audi R8', 'Nissan GTR'
  ];

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 5));
    _initializeGame();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  void _playSound(String fileName) async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource('audio/$fileName'));
    } catch (e) {
      debugPrint("Audio playback note: $e");
    }
  }

  void _initializeGame() {
    _moves = 0;
    _matchesFound = 0;
    _firstSelectedIndex = -1;
    _isProcessing = false;
    _gameCompleted = false;
    _confettiController.stop();

    List<CarCardModel> templateList = [];
    for (int i = 0; i < _carNames.length; i++) {
      String name = _carNames[i];
      String formattedName = name.toLowerCase().replaceAll(' ', '_');

      templateList.add(CarCardModel(id: i * 2,
          carName: name,
          imagePath: 'assets/images/$formattedName.png'));
      templateList.add(CarCardModel(id: (i * 2) + 1,
          carName: name,
          imagePath: 'assets/images/$formattedName.png'));
    }

    templateList.shuffle();
    setState(() {
      _cards = templateList;
    });
  }

  void _handleCardTap(int index) {
    if (_isProcessing || _cards[index].isFlipped || _cards[index].isMatched)
      return;

    _playSound('flip.mp3');

    setState(() {
      _cards[index].isFlipped = true;
    });

    if (_firstSelectedIndex == -1) {
      _firstSelectedIndex = index;
    } else {
      _moves++;
      _isProcessing = true;

      if (_cards[_firstSelectedIndex].carName == _cards[index].carName) {
        // MATCH DETECTED
        Future.delayed(const Duration(milliseconds: 300), () {
          _playSound('match.mp3');
          setState(() {
            _cards[_firstSelectedIndex].isMatched = true;
            _cards[index].isMatched = true;
            _matchesFound++;
            _firstSelectedIndex = -1;
            _isProcessing = false;

            if (_matchesFound == _carNames.length) {
              _gameCompleted = true;
              _playSound('victory.mp3');
              _confettiController.play();
            }
          });
        });
      } else {
        // MISMATCH - Flip back over
        Future.delayed(const Duration(milliseconds: 1000), () {
          setState(() {
            _cards[_firstSelectedIndex].isFlipped = false;
            _cards[index].isFlipped = false;
            _firstSelectedIndex = -1;
            _isProcessing = false;
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B071E),
      body: Stack(
        children: [
          // Background Gradient Atmosphere
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0B071E), Color(0xFF1D1135)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Main Screen Layout
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                // UPDATED: Title changed from NEO SPEED MATCH to CAR MATCH
                const Text(
                  "CAR MATCH",
                  style: TextStyle(
                    color: Colors.cyan,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 3,
                  ),
                ),
                Text(
                  "Moves: $_moves  |  Matches: $_matchesFound/${_carNames.length}",
                  style: const TextStyle(color: Colors.purpleAccent, fontSize: 16, fontWeight: FontWeight.w600),
                ),

                // Centered and pulled together to avoid empty spaces
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: GridView.builder(
                        shrinkWrap: true,
                        itemCount: _cards.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.75,
                        ),
                        itemBuilder: (context, index) {
                          return MemoryCardWidget(
                            card: _cards[index],
                            onTap: () => _handleCardTap(index),
                          );
                        },
                      ),
                    ),
                  ),
                ),

                // Reset Engine Button
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: ElevatedButton.icon(
                    onPressed: _initializeGame,
                    icon: const Icon(Icons.refresh, color: Colors.black),
                    label: const Text(
                      "RESET ENGINE",
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      elevation: 8,
                      shadowColor: Colors.cyan.withOpacity(0.5),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Victory Screen Layer Overlay
          if (_gameCompleted)
            Container(
              color: Colors.black.withOpacity(0.85),
              width: double.infinity,
              height: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.emoji_events, color: Colors.amber, size: 100),
                  const SizedBox(height: 16),
                  const Text(
                    "VICTORY!",
                    style: TextStyle(color: Colors.cyan, fontSize: 40, fontWeight: FontWeight.w900, letterSpacing: 4),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "LIVE YOUR PERFECT",
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 2),
                  ),
                  Text(
                    "You conquered the grid in $_moves moves.",
                    style: const TextStyle(color: Colors.purpleAccent, fontSize: 16),
                  ),
                  const SizedBox(height: 32),
                  OutlinedButton(
                    onPressed: _initializeGame,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.cyan, width: 2),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text("PLAY AGAIN", style: TextStyle(color: Colors.cyan, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),

          // Particle Celebration Engine
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [Colors.cyan, Colors.purpleAccent, Colors.amber, Colors.blue, Colors.green],
              numberOfParticles: 30,
              gravity: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}