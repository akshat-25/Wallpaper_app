import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';

class FullScreen extends StatefulWidget {
  final String imageurl;

  const FullScreen({Key? key, required this.imageurl}) : super(key: key);

  @override
  State<FullScreen> createState() => _FullScreenState();
}

class _FullScreenState extends State<FullScreen> {
  Future<void> setWallpaper() async {
    var file = await DefaultCacheManager().getSingleFile(widget.imageurl);
    int location = WallpaperManager.BOTH_SCREEN; //can be Home/Lock Screen
    bool result = await WallpaperManager.setWallpaperFromFile(
        file.path, location); //provide image path
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Expanded(
                child: Container(
              child: Image.network(widget.imageurl),
            )),
            InkWell(
              onTap: () {
                setWallpaper();
                print('Button Pressed');
              },
              child: Container(
                height: 60,
                width: double.infinity,
                color: Colors.black,
                child: Center(
                  child: Text('Set Wallpaper',
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
