import 'package:cached_network_image/cached_network_image.dart';
import 'package:eClassify/ui/theme/theme.dart';
import 'package:eClassify/utils/app_icon.dart';
import 'package:eClassify/utils/extensions/extensions.dart';
import 'package:eClassify/utils/ui_utils.dart';
import 'package:flutter/material.dart';

class GalleryViewWidget extends StatefulWidget {
  final List images;
  final int initalIndex;

  const GalleryViewWidget({
    super.key,
    required this.images,
    required this.initalIndex,
  });

  @override
  State<GalleryViewWidget> createState() => _GalleryViewWidgetState();

}

class _GalleryViewWidgetState extends State<GalleryViewWidget> {
  late PageController controller =
      PageController(initialPage: widget.initalIndex);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: UiUtils.buildAppBar(
          context,
          showBackButton: true,
          backgroundColor: context.color.secondaryDetailsColor,
        ),
        backgroundColor: context.color.secondaryDetailsColor,
        body: PageView.builder(
          controller: controller,
          itemBuilder: (context, index) {
            return InteractiveViewer(
              scaleEnabled: true,
              maxScale: 5,
              child: CachedNetworkImage(
                imageUrl: widget.images[index],
                fit: BoxFit.contain,
                errorWidget: (context, url, error) {
                  return Container(
                    color: context.color.territoryColor.withValues(alpha: 0.1),
                    alignment: AlignmentDirectional.center,
                    child: SizedBox(
                      child: UiUtils.getSvg(
                        AppIcons.placeHolder,
                        width: 70,
                        height: 70,
                      ),
                    ),
                  );
                },
              ),
            );
          },
          itemCount: widget.images.length,
        ));
  }

}
