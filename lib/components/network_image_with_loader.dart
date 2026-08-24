import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import 'skleton/skelton.dart';

class NetworkImageWithLoader extends StatelessWidget {
  final BoxFit fit;

  const NetworkImageWithLoader(
    this.src, {
    super.key,
    this.fit = BoxFit.cover,
    this.radius = defaultPadding,
  });

  final String src;
  final double radius;

  @override
  Widget build(BuildContext context) {
    if (src.trim().isEmpty) {
      return const _FallbackImage();
    }

    final isNetworkUrl = src.startsWith('http://') || src.startsWith('https://');
    if (isNetworkUrl) {
      return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        child: CachedNetworkImage(
          fit: fit,
          imageUrl: src,
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: fit,
              ),
            ),
          ),
          placeholder: (context, url) => const Skeleton(),
          errorWidget: (context, url, error) => const _FallbackImage(),
        ),
      );
    }

    if (src.startsWith('assets/')) {
      return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        child: Image.asset(
          src,
          fit: fit,
          errorBuilder: (context, error, stackTrace) => const _FallbackImage(),
        ),
      );
    }

    return const _FallbackImage();
  }
}

class _FallbackImage extends StatelessWidget {
  const _FallbackImage();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade200,
      child: const Icon(Icons.image_not_supported_outlined, color: Colors.grey),
    );
  }
}
