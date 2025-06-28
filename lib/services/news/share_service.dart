// Dart imports:
import 'dart:typed_data';
import 'dart:ui' as ui;

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:inshort_clone/common/utils/logger.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'dart:io';

import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:inshort_clone/controller/provider.dart';

void convertWidgetToImageAndShare(BuildContext context, containerKey) async {
  final RenderRepaintBoundary renderRepaintBoundary =
      containerKey.currentContext.findRenderObject() as RenderRepaintBoundary;
  final ui.Image boxImage =
      await renderRepaintBoundary.toImage(pixelRatio: 1);
  final ByteData? byteData =
      await boxImage.toByteData(format: ui.ImageByteFormat.png);
  if (byteData == null) return;
  final Uint8List uInt8List = byteData.buffer.asUint8List();

  try {
    final tempDir = await getTemporaryDirectory();
    final file = await File('${tempDir.path}/inshortClone.png').create();
    await file.writeAsBytes(uInt8List);

    await Share.shareXFiles([
      XFile(file.path,
          mimeType: 'image/png',
          name: 'inshortClone.png'),
    ], text: 'This message sent from *inshorts Clone* made by *Sanjay Soni*\nFork this repository on *Github*\n\n https://github.com/imSanjaySoni/Inshorts-Clone.');
  } catch (e) {
    logMessage('error: $e');
  }

  Provider.of<FeedProvider>(context, listen: false).setWatermarkVisible(false);
}
