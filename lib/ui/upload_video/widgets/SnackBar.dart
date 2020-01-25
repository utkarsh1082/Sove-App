import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:video_player/video_player.dart';

class SnackBarPage {
  ScaffoldFeatureController showSnackBar(ctx, text) {
    return Scaffold.of(ctx).showSnackBar(
      SnackBar(
        content: Text(
          text,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
