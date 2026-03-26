import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';
import 'package:path_provider/path_provider.dart';
import '../models/models.dart';

class ExportService {
  static Future<String?> exportProject(Project project) async {
    final directory = await getApplicationDocumentsDirectory();
    final outputPath = '${directory.path}/export_${DateTime.now().millisecondsSinceEpoch}.mp4';

    // Simplified FFmpeg command generation
    // In a real app, this would be a complex filter_complex chain
    // For now, we'll just demonstrate the structure
    
    String inputs = "";
    String filters = "";
    int inputCount = 0;

    for (var element in project.elements) {
      if (element.type == ElementType.video || element.type == ElementType.image) {
        inputs += " -i ${element.content}";
        // Apply scaling and positioning filters
        filters += "[$inputCount:v]scale=${element.size.width}:${element.size.height}[v$inputCount];";
        inputCount++;
      }
    }

    // This is a placeholder command. Real implementation requires complex overlaying logic.
    final command = "$inputs -filter_complex \"$filters\" -map \"[v${inputCount - 1}]\" -aspect ${project.canvasSize.width}/${project.canvasSize.height} $outputPath";

    final session = await FFmpegKit.execute(command);
    final returnCode = await session.getReturnCode();

    if (ReturnCode.isSuccess(returnCode)) {
      return outputPath;
    } else {
      final logs = await session.getLogs();
      print("FFmpeg Error: ${logs.join('\n')}");
      return null;
    }
  }
}
