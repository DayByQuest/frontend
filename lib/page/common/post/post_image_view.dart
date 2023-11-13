import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/class/post_image.dart';

class PostImageView extends StatelessWidget {
  const PostImageView({
    super.key,
    required this.width,
    required this.imageList,
    required this.imageLength,
    required this.changeCurIdx,
  });

  final double width;
  final List<PostImage> imageList;
  final int imageLength;
  final Function changeCurIdx;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // 이미지
      width: width,
      height: width,
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return Image.network(
            imageList[index].imageUrl,
            fit: BoxFit.contain,
          );
        },
        itemCount: imageLength,
        loop: false,
        onIndexChanged: (int nextImageIndex) {
          changeCurIdx(nextImageIndex);
        },
      ),
    );
  }
}
