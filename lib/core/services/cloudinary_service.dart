import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class CloudinaryService {
  final String cloudName = "dd15ci6zb";
  final String uploadPreset = "ml_default";

  Future<String?> uploadImage(File imageFile) async {
    final url = Uri.parse(
      "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
    );

    try {
      final request = http.MultipartRequest("POST", url)
        ..fields['upload_preset'] = uploadPreset
        ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

      final response = await request.send();
      final responseData = await response.stream.toBytes();
      final responseString = utf8.decode(responseData);

      if (response.statusCode == 200) {
        final jsonMap = jsonDecode(responseString);
        return jsonMap['secure_url'];
      } else {
        print("Cloudinary Upload Failed with status: ${response.statusCode}");
        print("Response Body: $responseString");
        return null;
      }
    } on SocketException catch (e) {
      print("Network Error (Check your internet/DNS): $e");
      return null;
    } catch (e) {
      print("Cloudinary Error during upload: $e");
      return null;
    }
  }
}
