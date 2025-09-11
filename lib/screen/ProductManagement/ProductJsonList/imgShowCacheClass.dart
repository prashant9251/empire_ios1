import 'package:cached_network_image/cached_network_image.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'package:http/http.dart' as http;

class imgShowCacheClass {
  static imgCachebyBurl(url, {heigh, width}) {
    //print(url);
    return CachedNetworkImage(
      height: heigh != null ? heigh : 145,
      width: width != null ? width : 120,
      key: UniqueKey(),
      imageUrl: url,
      fit: BoxFit.cover,
      httpHeaders: {
        "Authorization": basicAuthForLocal,
      },
      // maxHeightDiskCache: 400,
      placeholder: (context, url) => Container(
        color: Colors.grey,
        child: Center(child: CircularProgressIndicator()),
      ),
      errorWidget: (context, url, error) {
        return Container(
          child: Center(child: Icon(Icons.error, color: Colors.red)),
        );
      },
    );
  }

  static imgCacheByDefultForHomePage({UserObj}) {
    var url = savedUrlForHomeScreen;
    if (url != "" && url != null) {
      return CachedNetworkImage(
        height: 145,
        width: 120,
        key: UniqueKey(),
        imageUrl: url,
        fit: BoxFit.fill,
        httpHeaders: {
          "Authorization": basicAuthForLocal,
        },
        // maxHeightDiskCache: 400,
        placeholder: (context, url) => Container(color: Colors.grey),
        errorWidget: (context, url, error) {
          return Container(
            child: Icon(Icons.error, color: Colors.red),
          );
        },
      );
    }
  }
}
