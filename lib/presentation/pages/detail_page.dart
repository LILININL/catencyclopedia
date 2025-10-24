import 'package:catencyclopedia/presentation/bloc/get/cat_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/entities/cat_breed.dart';
import '../bloc/get/cat_bloc.dart';
import '../bloc/get/cat_state.dart';
import '../bloc/favorite/favorite_bloc.dart';
import '../bloc/favorite/favorite_event.dart';
import '../../locator.dart';
import 'package:translator/translator.dart';

class DetailPage extends StatefulWidget {
  static const String routeName = '/detail';
  final String? image;
  final CatBreed? breed;

  const DetailPage({super.key, required this.breed, this.image});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String? translatedDescription;
  String? translatedTemperament;
  String? translatedFact;
  bool isTranslatingDetail = false;
  bool isTranslatingFact = false;
  bool showTranslatedAll = false;
  bool showTranslatedFact = false;

  final translator = GoogleTranslator();

  @override
  void initState() {
    super.initState();
    // print(" ชื่อ :${widget.breed?.name} , ต้นกำเนิด : ${widget.breed?.origin} อายุขัย : ${widget.breed?.lifeSpan} น้ำหนัก : ${widget.breed?.weight?.toString()}");
  }

  Future<void> _autoTranslateAll() async {
    setState(() => isTranslatingDetail = true);
    final desc = widget.breed?.description ?? '';
    final temp = widget.breed?.temperament ?? '';
    final futures = <Future>[];

    try {
      if (desc.isNotEmpty) {
        futures.add(translator.translate(desc, to: 'th').then((t) => translatedDescription = t.text));
      } else {
        translatedDescription = null;
      }
      if (temp.isNotEmpty) {
        futures.add(translator.translate(temp, to: 'th').then((t) => translatedTemperament = t.text));
      } else {
        translatedTemperament = null;
      }
      await Future.wait(futures);
      setState(() {
        isTranslatingDetail = false;
        showTranslatedAll = true;
      });
    } catch (e) {
      setState(() {
        isTranslatingDetail = false;
        showTranslatedAll = false;
        translatedDescription = null;
        translatedTemperament = null;
      });
      debugPrint('Translation error: $e');
    }
  }

  void showOriginalAll() {
    setState(() {
      showTranslatedAll = false;
      translatedDescription = null;
      translatedTemperament = null;
    });
  }

  Future<void> translateFact(String fact) async {
    setState(() {
      isTranslatingFact = true;
    });

    try {
      final translation = await translator.translate(fact, to: 'th');
      setState(() {
        translatedFact = translation.text;
        showTranslatedFact = true;
        isTranslatingFact = false;
      });
    } catch (e) {
      setState(() {
        isTranslatingFact = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('เกิดข้อผิดพลาดในการแปล')));
      debugPrint('Translation error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final catOrange = const Color(0xFFFFB74D);
    final catCream = const Color(0xFFFFF3E0);
    final catBrown = const Color(0xFF8D5524);

    return MultiBlocProvider(
      providers: [
        BlocProvider<FavoriteBloc>(create: (_) => sl<FavoriteBloc>()..add(LoadFavorites())),
        BlocProvider<CatBloc>(create: (_) => sl<CatBloc>()),
      ],
      child: Scaffold(
        backgroundColor: catCream,
        appBar: AppBar(
          backgroundColor: catOrange,
          iconTheme: const IconThemeData(color: Color(0xFF8D5524)),
          title: Row(
            children: [
              const Icon(Icons.pets, color: Color(0xFF8D5524)),
              const SizedBox(width: 8),
              Text(widget.breed?.name ?? 'Unknown', style: const TextStyle(color: Color(0xFF8D5524))),
            ],
          ),
          elevation: 2,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Hero(
                tag: widget.image ?? '',
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(32), bottomRight: Radius.circular(32)),
                  child: CachedNetworkImage(
                    imageUrl: widget.image ?? '',
                    height: 260,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => Container(
                      height: 260,
                      color: catOrange.withOpacity(0.2),
                      child: const Center(child: Icon(Icons.error, size: 100, color: Colors.red)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Card(
                  color: Colors.white,
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (!showTranslatedAll)
                              ElevatedButton.icon(
                                icon: const Icon(Icons.translate),
                                label: const Text('แปลไทย'),
                                style: ElevatedButton.styleFrom(backgroundColor: catOrange, foregroundColor: Colors.white),
                                onPressed: isTranslatingDetail ? null : _autoTranslateAll,
                              ),
                            if (showTranslatedAll)
                              ElevatedButton.icon(
                                icon: const Icon(Icons.language),
                                label: const Text('ภาษาอังกฤษ'),
                                style: ElevatedButton.styleFrom(backgroundColor: catBrown, foregroundColor: Colors.white),
                                onPressed: showOriginalAll,
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: catOrange,
                              child: const Icon(Icons.pets, color: Colors.white),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                widget.breed?.name ?? 'Unknown',
                                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF8D5524)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            Chip(
                              label: Text('ต้นกำเนิด: ${widget.breed?.origin}', style: const TextStyle(color: Colors.white)),
                              backgroundColor: catBrown,
                            ),
                            Chip(
                              label: Text('อายุขัย: ${widget.breed?.lifeSpan} ปี', style: const TextStyle(color: Colors.white)),
                              backgroundColor: catOrange,
                            ),
                            Chip(
                              label: Text('น้ำหนัก: ${widget.breed?.weightMetric?.toString()} กิโลกรัม', style: const TextStyle(color: Colors.white)),
                              backgroundColor: catBrown,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'อารมณ์',
                          style: TextStyle(fontWeight: FontWeight.bold, color: catBrown, fontSize: 18),
                        ),
                        const SizedBox(height: 4),
                        isTranslatingDetail
                            ? const LinearProgressIndicator(minHeight: 4)
                            : Text(
                                showTranslatedAll && translatedTemperament != null ? translatedTemperament! : widget.breed?.temperament ?? 'No temperament info',
                                style: const TextStyle(fontSize: 16, color: Colors.deepOrange),
                              ),
                        const SizedBox(height: 16),
                        Text(
                          'รายละเอียด',
                          style: TextStyle(fontWeight: FontWeight.bold, color: catBrown, fontSize: 18),
                        ),
                        const SizedBox(height: 4),
                        isTranslatingDetail
                            ? const LinearProgressIndicator(minHeight: 4)
                            : Text(
                                showTranslatedAll && translatedDescription != null ? translatedDescription! : widget.breed?.description ?? 'No description',
                                style: const TextStyle(fontSize: 16, color: Colors.deepOrange),
                              ),
                        const SizedBox(height: 24),
                        // แสดงส่วน "สุ่มข้อเท็จจริง" เสมอ
                        BlocBuilder<CatBloc, CatState>(
                          builder: (context, state) {
                            final fact = state.fact ?? '';
                            return Container(
                              decoration: BoxDecoration(color: catOrange.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.lightbulb, color: Color(0xFF8D5524)),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'สุ่มข้อเท็จจริง',
                                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: catBrown),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.refresh, color: Color(0xFF8D5524)),
                                        tooltip: 'สุ่ม ข้อเท็จจริง ใหม่',
                                        onPressed: () {
                                          setState(() {
                                            showTranslatedFact = false;
                                            translatedFact = null;
                                          });
                                          context.read<CatBloc>().add(GetFact());
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  if (isTranslatingFact)
                                    const LinearProgressIndicator(minHeight: 4)
                                  else if (fact.isNotEmpty)
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(showTranslatedFact && translatedFact != null ? translatedFact! : fact, style: const TextStyle(fontSize: 16, color: Colors.deepOrange)),
                                        const SizedBox(height: 12),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            if (!showTranslatedFact)
                                              ElevatedButton.icon(
                                                icon: const Icon(Icons.translate),
                                                label: const Text('แปลไทย'),
                                                onPressed: isTranslatingFact ? null : () => translateFact(fact),
                                                style: ElevatedButton.styleFrom(backgroundColor: catOrange, foregroundColor: Colors.white),
                                              ),
                                            if (showTranslatedFact)
                                              ElevatedButton.icon(
                                                icon: const Icon(Icons.language),
                                                label: const Text('ภาษาอังกฤษ'),
                                                onPressed: () => setState(() {
                                                  showTranslatedFact = false;
                                                }),
                                                style: ElevatedButton.styleFrom(backgroundColor: catBrown, foregroundColor: Colors.white),
                                              ),
                                          ],
                                        ),
                                      ],
                                    )
                                  else
                                    const Text('สร้างข้อเท็จจริง', style: TextStyle(fontSize: 16, color: Colors.deepOrange)),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
