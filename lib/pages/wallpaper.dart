import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaper_app/models/image_model.dart';
import 'package:wallpaper_app/pages/full_screen.dart';

class Wallpaper extends StatefulWidget {
  const Wallpaper({Key? key}) : super(key: key);

  @override
  State<Wallpaper> createState() => _WallpaperState();
}

class _WallpaperState extends State<Wallpaper> {
  List images = [];
  int page = 1;
  @override
  void initState() {
    super.initState();
    fetchApi();
  }

  fetchApi() async {
    await http.get(Uri.parse('https://api.pexels.com/v1/curated?per_page=80'),
        headers: {
          'Authorization':
              '563492ad6f91700001000001f7d4c6561b844a8ab4288ab9a91e2ffb'
        }).then((value) {
      Map result = jsonDecode(value.body);
      setState(() {
        images = result['photos'];
      });
      print(images[0]);
    });
  }

  loadmore() async {
    setState(() {
      page = page + 1;
    });
    String url =
        'https://api.pexels.com/v1/curated?per_page=80&page=' + page.toString();
    await http.get(Uri.parse(url), headers: {
      'Authorization':
          '563492ad6f91700001000001f7d4c6561b844a8ab4288ab9a91e2ffb'
    }).then((value) {
      Map result = jsonDecode(value.body);
      setState(() {
        images.addAll(result['photos']);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wallpaper App'),
      ),
      body: Column(
        children: [
          Expanded(
              child: Container(
            child: GridView.builder(
                itemCount: images.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 4,
                    crossAxisCount: 3,
                    childAspectRatio: 2 / 3,
                    mainAxisSpacing: 4),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FullScreen(
                                imageurl: images[index]['src']['large2x']),
                          ));
                    },
                    child: Container(
                      color: Colors.blue.shade100,
                      child: Image.network(
                        images[index]['src']['tiny'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }),
          )),
          Container(
              width: double.infinity,
              color: Colors.black,
              child: TextButton(
                  onPressed: () {
                    loadmore();
                  },
                  child: Text(
                    'Load More',
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  )))
        ],
      ),
    );
  }
}
