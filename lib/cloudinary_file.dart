import 'package:cloudinary/cloudinary.dart';

Future<String?> getCloudinaryFileUrl(String filePath) async {
  final cloudinary = Cloudinary.signedConfig(
    cloudName: 'ds0psaxoc',
    apiKey: '467315474851437',
    apiSecret: 'DuxlsUbu1oahxHDkQkzXmggBb7Q',
  );

  final response = await cloudinary.upload(
    file: filePath,
    resourceType: CloudinaryResourceType.raw,
  );

  return response.secureUrl;
}
