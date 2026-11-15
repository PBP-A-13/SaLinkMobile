import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:salink_mobile/models/item_listing.dart';

class SalingBeliPage extends StatefulWidget {
  const SalingBeliPage({super.key});

  @override
  State<SalingBeliPage> createState() => _SalingBeliPageState();
}

class _SalingBeliPageState extends State<SalingBeliPage> {
  final String baseUrl = 'https://pws.cs.ui.ac.id/muhammad.hasbi52/salink';

  Future<List<ItemListing>> fetchListings() async {
    final url = Uri.parse('$baseUrl/saling-beli/json/');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return itemListingFromJson(utf8.decode(response.bodyBytes));
      } else {
        final localUrl = Uri.parse('http://10.0.2.2:8000/saling-beli/json/');
        final localResp = await http.get(localUrl);
        if (localResp.statusCode == 200) {
          return itemListingFromJson(utf8.decode(localResp.bodyBytes));
        }
        throw Exception('Gagal memuat listing: HTTP ${response.statusCode}');
      }
    } catch (e) {
      final localUrl = Uri.parse('http://10.0.2.2:8000/saling-beli/json/');
      try {
        final localResp = await http.get(localUrl);
        if (localResp.statusCode == 200) {
          return itemListingFromJson(utf8.decode(localResp.bodyBytes));
        }
      } catch (_) {}
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Katalog Saling Beli'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<ItemListing>>(
        future: fetchListings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.cloud_off, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    const Text(
                      'Belum dapat terhubung ke server Django',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => setState(() {}),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada barang di katalog Saling Beli.',
                style: TextStyle(color: Colors.black54),
              ),
            );
          }

          final listings = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: listings.length,
            itemBuilder: (context, index) {
              final item = listings[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          width: 80,
                          height: 80,
                          color: Colors.indigo.shade50,
                          child: item.displayImage != null && item.displayImage!.isNotEmpty
                              ? Image.network(
                                  item.displayImage!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (ctx, err, stack) =>
                                      const Icon(Icons.image_not_supported, color: Colors.grey),
                                )
                              : const Icon(Icons.shopping_bag, color: Colors.indigo),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.isFree ? 'GRATIS' : 'Rp ',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: item.isFree ? Colors.green : Colors.indigo,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Chip(
                                  label: Text(
                                    item.category,
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                  padding: EdgeInsets.zero,
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    '📍 ',
                                    style: const TextStyle(fontSize: 11, color: Colors.black54),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
