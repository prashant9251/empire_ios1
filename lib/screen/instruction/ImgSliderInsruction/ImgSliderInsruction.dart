import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/instruction/OpenInstruction/OpenInstruction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ImgSliderInsruction extends StatefulWidget {
  ImgSliderInsruction({Key? key}) : super(key: key);

  @override
  State<ImgSliderInsruction> createState() => _ImgSliderInsructionState();
}

class _ImgSliderInsructionState extends State<ImgSliderInsruction> {
  List<dynamic> imgL = [];

  int activeIndex = 0;
  void getData() async {
    if (firebSoftwraesInfo["imgCardList"] != null) {
      imgL = firebSoftwraesInfo["imgCardList"];
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return imgL.length > 0
        ? imgL[0]["title"] != null && imgL[0]["title"] != ""
            ? Container(
                height: 60,
                width: MediaQuery.of(context).size.width,
                child: CarouselSlider.builder(
                  disableGesture: true,
                  options: CarouselOptions(
                      autoPlayInterval: const Duration(seconds: 1),
                      enableInfiniteScroll: false,
                      onPageChanged: (index, reason) => setState(() => activeIndex = index)),
                  itemCount: imgL.length,
                  itemBuilder: (context, index, realindex) {
                    return Card(
                      color: Colors.grey,
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () => Myf.Navi(context, OpenInstruction(d: imgL[index])),
                              child: Stack(
                                alignment: Alignment.center,
                                children: <Widget>[
                                  imgL[index]["link"] != null && imgL[index]["link"] != ""
                                      ? Container(
                                          margin: const EdgeInsets.symmetric(horizontal: 5),
                                          color: Colors.grey,
                                          child: CachedNetworkImage(
                                            httpHeaders: {
                                              "Authorization": basicAuthForLocal,
                                            },
                                            width: MediaQuery.of(context).size.width,
                                            key: UniqueKey(),
                                            imageUrl: imgL[index]["link"],
                                            fit: BoxFit.cover,
                                            maxHeightDiskCache: 400,
                                            placeholder: (context, url) => Container(color: Colors.grey),
                                            errorWidget: (context, url, error) {
                                              return Container(child: Icon(Icons.error, color: Colors.red));
                                            },
                                          ),
                                        )
                                      : Container(
                                          color: Colors.grey,
                                        ),
                                  imgL[index]["title"] != null
                                      ? Positioned(
                                          left: 0,
                                          bottom: 0,
                                          child: Container(
                                            color: opColors,
                                            child: Text(
                                              "${imgL[index]["title"]}",
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          ))
                                      : SizedBox.shrink()
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                              top: 0,
                              right: 0,
                              child: CircleAvatar(
                                backgroundColor: Colors.grey,
                                child: IconButton(
                                  onPressed: () => Myf.Navi(context, OpenInstruction(d: imgL[index])),
                                  icon: Icon(Icons.open_in_new),
                                  color: Colors.black,
                                ),
                              ))
                        ],
                      ),
                    );
                  },
                ),
              )
            : SizedBox.shrink()
        : SizedBox.shrink();
  }
}
