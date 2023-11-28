import 'package:flutter/material.dart';
import 'dart:async';
import 'upgrades.dart';

void main() => runApp(const Clicker());

class Clicker extends StatelessWidget {
  const Clicker({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ClickerGame(),
    );
  }
}

class ClickerGame extends StatefulWidget {
  const ClickerGame({super.key});

  @override
  _ClickerGameState createState() => _ClickerGameState();
}

class _ClickerGameState extends State<ClickerGame> {
  double score = 0.0;
  double scorePerSecond = 0.0;
  int upgradeCount = 0;
  Timer? timer;
  late Image image;
  double imageSize = 150.0;

  @override
  void initState() {
    super.initState();

    // Load the image from assets
    image = Image.asset('assets/placeholder.png');

    // Add the initial scorePerSecond to score
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        score += scorePerSecond;
      });
    });
  }

  void incrementScore() {
    setState(() {
      score++;
    });
  }

  void loadImage(String imagePath) async {
    final imageProvider = AssetImage(imagePath);
    final loadedImage = Image(image: imageProvider);

    await precacheImage(imageProvider, context);

    setState(() {
      image = loadedImage;
    });
  }

  Widget _buildCircularIcon(IconData iconData) {
    return Container(
      width: 50, // Adjust the size as needed
      height: 50, // Adjust the size as needed
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white, // Customize the background color
      ),
      child: Center(
        child: Icon(
          iconData,
          size: 30, // Adjust the icon size as needed
          color: Colors.blue, // Customize the icon color
        ),
      ),
    );
  }

  void buyUpgrade(Upgrade upgrade) {
    if (score >= upgrade.cost) {
      setState(() {
        score -= upgrade.cost;
        upgrade.count++;
        upgrade.cost *= 1.5;
        scorePerSecond += upgrade.value;
      });

      if (timer != null) {
        timer!.cancel();
      }
      timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
        setState(() {
          score += scorePerSecond;
        });
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Score: ${score.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 24.0),
            ),
            Text(
              'Score per Second: ${scorePerSecond.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16.0),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Row(
        children: <Widget>[
          Expanded(
            flex: 2, // 20% of the screen width
            child: Container(
              color: Colors.blueGrey, // Customize the color for upgrades
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: <Widget>[
                  const Text(
                    'Upgrades',
                    style: TextStyle(fontSize: 24.0, color: Colors.white),
                  ),
                  const Divider(
                    color: Colors.white, 
                  ),
                  // Display upgrades from the upgradesData list
                  for (var upgrade in upgradesData)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${upgrade.name} (${upgrade.count})',
                          style: const TextStyle(fontSize: 16.0, color: Colors.white),
                        ),
                        Text(
                          upgrade.description, 
                          style: const TextStyle(fontSize: 16.0, color: Colors.white),
                        ),
                        Text(
                          'Cost: ${upgrade.cost.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 16.0, color: Colors.white),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            buyUpgrade(upgrade);
                          },
                          child: Text('Buy ${upgrade.name}'),
                        ),
                        const Divider(
                          color: Colors.white, // Add a divider between upgrades
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 8, // 80% of the screen width
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 20.0),
                InkWell(
                  onTap: () {
                    setState(() {
                      score += 1;
                      imageSize = 75.0;
                    });

                    // Return to the normal image size after 0.5 seconds
                    Future.delayed(const Duration(milliseconds: 50), () {
                      setState(() {
                        imageSize = 400.0;
                      });
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200), 
                    width: imageSize, 
                    height: imageSize, 
                    child: Container(
                      padding: const EdgeInsets.only(top: 120.0), 
                      child: image, 
                    ), // Display the loaded image
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter, // Align the icons to the bottom center
                    child: Container(
                      color: Colors.blueGrey, // Customize the color for the container
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Align icons evenly
                        children: [
                          _buildCircularIcon(Icons.home), 
                          _buildCircularIcon(Icons.settings), 
                          _buildCircularIcon(Icons.star), 
                          _buildCircularIcon(Icons.mail), 
                          _buildCircularIcon(Icons.menu), 
                          _buildCircularIcon(Icons.person), 
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            flex: 2,
            child: Container(
              color: Colors.green,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'More',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                  // Add content here
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}