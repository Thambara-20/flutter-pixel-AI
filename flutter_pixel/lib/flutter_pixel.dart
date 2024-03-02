library flutter_pixel;

import 'package:flutter/foundation.dart';
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

  Future<Uint8List> _generate(String query) async {
    Uint8List image = await imageGenerator(query);
    return image;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double size = MediaQuery.of(context).size.width;
    Authenticator.setApiToken(''); 


    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                height: size,
                width: size,
                child: !isTextEmpty
                    ? FutureBuilder<Uint8List>(
                        future: _generate(widget.title),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isTextEmpty = false;
          });
        },
        child: const Icon(Icons.art_track),
      ),
    );
  }
}
