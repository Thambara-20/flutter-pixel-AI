
 powerful AI image generation package for Flutter. It uses [Edenai](https://www.edenai.co/) API to generate images based on user input.

## Features

- Generate images from text descriptions.
- High-quality image output.
- Easy to integrate with any Flutter project.

## Getting Started

### Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_pixel: ^0.0.4
```

Authentication [Edenai](https://www.edenai.co/):

```yaml
Authenticator.setApiToken('your api-key'); 
// Replace this with your edenai API key (currently has a free plan as of 02/03/2024).

```

Usage of the image generation functionality:

```yaml
 Future<Uint8List> _generate(String query) async {
    textController.clear();
    setState(() {
      isTextEmpty = true;
    });
   // You can specify the size [small(256x256), medium(512x512), large(1024x1024)] 
    Uint8List image = await imageGenerator(query, ImageSize.medium); 
    return image;
  }
```

Refer to this example:
```yaml
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_pixel/utilities/index.dart';

class ImageScreen extends StatefulWidget {
  final String title;
  const ImageScreen({Key? key, required this.title}) : super(key: key);

  @override
  State<ImageScreen> createState() => _TestState();
}

class _TestState extends State<ImageScreen> {
  bool isTextEmpty = true;
  TextEditingController textController = TextEditingController();

  Future<Uint8List> _generate(String query) async {
    textController.clear();
    setState(() {
      isTextEmpty = true;
    });
    Uint8List image = await imageGenerator(query, ImageSize.medium);
    return image;
  }

  @override
  void dispose() {
    textController.dispose();
    textController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    Authenticator.setApiToken('your api-key'); // Replace this with your edenai API key (currently has a free plan as of 02/03/2024).

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextField(
                    controller: textController,
                    decoration: const InputDecoration(
                      labelText: 'Enter Text to Generate Image',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    width: width,
                    child: !isTextEmpty
                        ? FutureBuilder<Uint8List>(
                            future: _generate(textController.text),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else if (snapshot.hasData) {
                                return Image.memory(snapshot.data!);
                              } else {
                                return Container();
                              }
                            },
                          )
                        : const Center(
                            child: Text(
                              'Enter Text and Click the button to generate the image',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (textController.text.isNotEmpty) {
            setState(() {
              isTextEmpty = false;
            });
          }
        },
        child: const Icon(Icons.art_track),
      ),
    );
  }
}
```




