import 'package:flutter/material.dart';

class EventDetailPage extends StatelessWidget {
  final Map<String, dynamic> event; // Gelen etkinlik bilgisi

  const EventDetailPage({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String title = event['name'] ?? 'Etkinlik Adı Yok';
    final String description = event['info'] ?? 'Açıklama Yok';
    final String date = event['dates']['start']['localDate'] ?? 'Tarih Yok';
    final String type =
        event['classifications']?[0]['segment']['name'] ?? 'Tür Yok';
    final String venue = event['_embedded']?['venues']?[0]?['name'] ?? 'Yer Yok';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Açıklama: $description'),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.date_range, color: Colors.grey),
                const SizedBox(width: 5),
                Text('Tarih: $date'),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.grey),
                const SizedBox(width: 5),
                Text('Yer: $venue'),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.category, color: Colors.grey),
                const SizedBox(width: 5),
                Text('Tür: $type'),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                // Katılma butonu
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Etkinliğe katıldınız!')),
                );
              },
              child: const Text('Etkinliğe Katıl'),
            ),
          ],
        ),
      ),
    );
  }
}
