import 'package:cloudinary/cloudinary.dart';

Future<String?> getCloudinaryUrl(String image) async {
  final cloudinary = Cloudinary.signedConfig( 
      cloudName: 'ds0psaxoc',
      apiKey: '467315474851437',
      apiSecret: 'DuxlsUbu1oahxHDkQkzXmggBb7Q');

  final response = await cloudinary.upload(
    file: image,
    resourceType: CloudinaryResourceType.image,
  );
  return response.secureUrl;
}
