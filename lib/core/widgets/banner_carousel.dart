import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BannerCarousel extends StatelessWidget {
  const BannerCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('banners').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final bannerDocs = snapshot.data!.docs;

        return CarouselSlider(
          options: CarouselOptions(
            height: 110,
            autoPlay: true,
            enlargeCenterPage: true,
          ),
          items: bannerDocs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final title = data['title'] ?? 'Title';
            final subtitle = data['subtitle'] ?? 'Subtitle';
            final imageUrl = data['imageUrl'] ?? '';

            return Container(
              // margin: EdgeInsets.symmetric(horizontal: 2),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(subtitle),
                    ],
                  ),
                  imageUrl.isNotEmpty
                      ? Image.network(imageUrl, width: 60)
                      : const Icon(Icons.image, size: 60, color: Colors.grey),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
