import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/utilities/globals.dart';
import 'package:intl/intl.dart';

class ListItemWidget extends StatelessWidget {
  final String id;
  final String? animationId;
  final String title;
  final String? imgUrl;
  final bool? isAnimation;
  final DateTime createdAd;
  final VoidCallback? onPress;
  final VoidCallback? onDelete;

  const ListItemWidget({
    Key? key,
    required this.id,
    required this.title,
    this.isAnimation,
    this.animationId,
    this.imgUrl,
    required this.createdAd,
    this.onPress,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(this.title),
      leading: this.imgUrl != null
          ? SizedBox(
              width: 100,
              child: AnimatedAlign(
                alignment: this.id == this.animationId ? Alignment.bottomLeft :  Alignment.bottomRight,
                duration: const Duration(seconds: 1),
                curve: Curves.fastOutSlowIn,
                child: SizedBox(
                  width: 50,
                  child: CachedNetworkImage(
                    imageUrl: Globals().domainHost + this.imgUrl!,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.fitWidth,
                            colorFilter: ColorFilter.mode(
                                Colors.white, BlendMode.colorBurn)),
                      ),
                    ),
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
            )
          : Icon(Icons.image),
      trailing: Text(
        DateFormat('yyyy-MM-dd').format(this.createdAd) +
            "\n" +
            DateFormat('HH:mm:ss').format(this.createdAd),
      ),
      onTap: this.onPress,
      onLongPress: this.onDelete,
    );
  }
}
