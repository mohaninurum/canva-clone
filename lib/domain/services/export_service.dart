import 'package:flutter/foundation.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import '../models/editor_state.dart';
import '../models/canvas_element.dart';

class ExportService {
  Future<bool> exportToMp4(EditorState state, String outputPath) async {
    // Mathematical algorithm orchestrating FFMPEG node strings parsing absolute boundaries
    final commandBuffer = StringBuffer();
    
    // Generate solid white background layer (1080p, 10s default duration)
    commandBuffer.write('-y -f lavfi -i color=c=white:s=1920x1080:d=10 ');
    
    int filterIndex = 1;
    final complexFilter = StringBuffer();
    
    for (final element in state.elements) {
      if (element is VideoElement) {
        commandBuffer.write('-i "${element.path}" ');
        complexFilter.write('[$filterIndex:v]scale=${element.size.width}:${element.size.height}[v$filterIndex]; ');
        filterIndex++;
      }
      // Audio tracks could be interleaved as [a$filterIndex]
    }
    
    // Append the encoded overlay chains if objects exist
    if (filterIndex > 1) {
      commandBuffer.write('-filter_complex "${complexFilter.toString()}[0:v][v1]overlay=x=960:y=540" ');
    }

    // Output bindings
    final command = '${commandBuffer.toString()}-c:v libx264 -preset ultrafast "$outputPath"';
    
    debugPrint('Executing Render Engine: $command');
    final session = await FFmpegKit.execute(command);
    final returnCode = await session.getReturnCode();
    
    if (ReturnCode.isSuccess(returnCode)) {
      debugPrint("Successfully Exported MP4 to Native Path: $outputPath");
      return true;
    } else {
      final logs = await session.getLogsAsString();
      debugPrint("FFMPEG COMPILE ERROR: $logs");
      return false;
    }
  }
}
