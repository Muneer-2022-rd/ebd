import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import 'e_provider_til_widget.dart';

class ShimmerProviderDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return EProviderTilWidget(
      title: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          width: 60.0,
          height: 20.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Get.theme.colorScheme.secondary
                .withOpacity(.5),
          ),
        ),
      ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: 220.0,
              height: 18.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Get.theme.colorScheme.secondary
                    .withOpacity(.5),
              ),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: 160.0,
              height: 18.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Get.theme.colorScheme.secondary
                    .withOpacity(.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
