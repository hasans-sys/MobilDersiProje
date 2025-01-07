import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EventPage extends StatefulWidget {
  const EventPage({Key? key}) : super(key: key);

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  final String ticketmasterApiKey = 'jZ4foOmx2CL3fwGpASP4EK415CMKF6cj';
  final TextEditingController searchController = TextEditingController();

  List<dynamic> events = [];
  List<dynamic> filteredEvents = [];
  String selectedCategory = 'Tümü';
  bool isLoading = true;

  final Map<String, String> categories = {
    'Tümü': '',
    'Müzik': 'music',
    'Spor': 'sports',
    'Sanat': 'arts',
    'Teknoloji': 'technology',
  };

  // Sabit şehir adı
  final String city = 'Erzurum';

  @override
  void initState() {
    super.initState();
    fetchEvents(); // Sayfa yüklendiğinde etkinlikleri çek
  }

  Future<void> fetchEvents([String? keyword]) async {
    setState(() {
      isLoading = true;
    });

    try {
      String baseUrl = 'https://app.ticketmaster.com/discovery/v2/events.json';
      String query = '?apikey=$ticketmasterApiKey&city=$city'; // Sabit şehir adı kullanılıyor

      if (keyword != null && keyword.isNotEmpty) {
        query += '&keyword=$keyword';
      }

      if (categories[selectedCategory]!.isNotEmpty) {
        query += '&classificationName=${categories[selectedCategory]}';
      }

      final response = await http.get(Uri.parse(baseUrl + query));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          events = data['_embedded']['events'] ?? [];
          filteredEvents = events;
        });
      } else {
        throw Exception('Etkinlikler yüklenirken hata oluştu.');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hata: ${e.toString()}')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void filterEvents(String query) {
    setState(() {
      filteredEvents = events.where((event) {
        final title = event['name']?.toLowerCase() ?? '';
        return title.contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Etkinlik Keşfet'),
        actions: [
          DropdownButton<String>(
            value: selectedCategory,
            icon: const Icon(Icons.filter_list, color: Colors.white),
            dropdownColor: Colors.blue,
            items: categories.keys.map((String category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(category, style: const TextStyle(color: Colors.white)),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  selectedCategory = value;
                });
                fetchEvents(); // Yeni kategoriyi seçtiğinde etkinlikleri yenile
              }
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Etkinlik ara...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: filterEvents, // Arama yaptıkça filtreleme yap
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    fetchEvents(); // Şehir zaten sabit, etkinlikleri çek
                  },
                  child: const Text('Etkinlikleri Getir'),
                ),
                Expanded(
                  child: filteredEvents.isEmpty
                      ? const Center(child: Text('Hiç etkinlik bulunamadı.'))
                      : ListView.builder(
                          itemCount: filteredEvents.length,
                          itemBuilder: (context, index) {
                            final event = filteredEvents[index];
                            final String title = event['name'] ?? 'Bilinmiyor';
                            final String date =
                                event['dates']['start']['localDate'] ?? 'Tarih yok';
                            final String type = event['classifications']?[0]
                                    ['segment']['name'] ?? 'Tür yok';
                            final String description =
                                event['info'] ?? 'Açıklama yok';

                            return Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              child: ListTile(
                                title: Text(title),
                                subtitle: Text(
                                  'Açıklama: $description\nTarih: $date\nTür: $type',
                                ),
                                isThreeLine: true,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EventDetailPage(
                                        event: event, // Seçilen etkinliği detay sayfasına gönder
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}

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
