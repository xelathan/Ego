import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageListWidget extends StatelessWidget {
  final List<XFile> images;
  final Function(int) onRemove;

  ImageListWidget(this.images, this.onRemove);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: images.asMap().entries.map((entry) {
        final int index = entry.key;
        final xfile = entry.value;
        final File file = File(xfile.path);
        return AnimatedSwitcher(
          duration:
              Duration(milliseconds: 300), // Adjust the duration as needed
          child: Stack(
            key: ValueKey<int>(index), // Key for the switcher
            children: [
              Image.file(
                file,
                width: 100,
                height: 100,
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Transform.translate(
                  offset: Offset(8, -8), // Adjust the offset as needed
                  child: GestureDetector(
                    onTap: () {
                      onRemove(index);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(
                            0, 0, 0, 0.5), // Black with 0.5 opacity
                        shape: BoxShape.circle,
                      ),
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
