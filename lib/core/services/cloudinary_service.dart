import 'package:cloudinary/cloudinary.dart';
import 'package:plantcare/core/constants/api_constants.dart';

/// Uploads an image file to Cloudinary and returns the secure URL.
Future<String?> getCloudinaryUrl(String image) async {
  final cloudinary = Cloudinary.signedConfig(
    cloudName: ApiConstants.cloudinaryCloudName,
    apiKey: ApiConstants.cloudinaryApiKey,
    apiSecret: ApiConstants.cloudinaryApiSecret,
  );

  final response = await cloudinary.upload(
    file: image,
    resourceType: CloudinaryResourceType.image,
  );
  return response.secureUrl;
}

/// Uploads a raw file (e.g. GLB, PDF) to Cloudinary and returns the secure URL.
Future<String?> getCloudinaryFileUrl(String filePath) async {
  final cloudinary = Cloudinary.signedConfig(
    cloudName: ApiConstants.cloudinaryCloudName,
    apiKey: ApiConstants.cloudinaryApiKey,
    apiSecret: ApiConstants.cloudinaryApiSecret,
  );

  final response = await cloudinary.upload(
    file: filePath,
    resourceType: CloudinaryResourceType.raw,
  );

  return response.secureUrl;
}
