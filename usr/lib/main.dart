import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color wbPurple = Color(0xFFCB11AB);
    return MaterialApp(
      title: 'Поддержка от WB',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: wbPurple,
          primary: wbPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF121212),
        fontFamily: 'Roboto',
      ),
      home: const CarouselScreen(),
    );
  }
}

class CarouselSlide {
  final IconData icon;
  final String title;
  final String text;
  final String? buttonText;
  final String? url;

  CarouselSlide({
    required this.icon,
    required this.title,
    required this.text,
    this.buttonText,
    this.url,
  });
}

class CarouselScreen extends StatefulWidget {
  const CarouselScreen({super.key});

  @override
  State<CarouselScreen> createState() => _CarouselScreenState();
}

class _CarouselScreenState extends State<CarouselScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<CarouselSlide> slides = [
    CarouselSlide(
      icon: Icons.campaign_rounded,
      title: 'Поддержка от WB',
      text: 'А вы знали, что сейчас есть очень крутая поддержка от WB для производителей из России? 🔥',
    ),
    CarouselSlide(
      icon: Icons.cases_rounded,
      title: 'Реальные кейсы',
      text: 'У нас уже есть кейсы, которые получили классные условия от ВБ:\n• Пониженные комиссии\n• Льготы на логистику\n• Доступность складов',
    ),
    CarouselSlide(
      icon: Icons.precision_manufacturing_rounded,
      title: 'Для кого это?',
      text: 'Если вы:\n• Сами производите товары\n• Состоите в реестре МСП\n• Работаете под собственной ТМ\n\nИ готовы мощно масштабироваться — это точно ваш шанс.',
    ),
    CarouselSlide(
      icon: Icons.hourglass_bottom_rounded,
      title: 'Дедлайн',
      text: 'Заявки принимают до 4 МАЯ.\nУспейте подать свою!',
    ),
    CarouselSlide(
      icon: Icons.open_in_new_rounded,
      title: 'Подача заявок',
      text: 'Все детали, условия отбора и подача заявок лежат на официальном сайте.',
      buttonText: 'Перейти на сайт',
      url: 'https://rost.wb.ru/',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Не удалось открыть ссылку')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: slides.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return SlideWidget(
                    slide: slides[index],
                    onButtonPressed: slides[index].url != null
                        ? () => _launchUrl(slides[index].url!)
                        : null,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      slides.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        height: 8.0,
                        width: _currentPage == index ? 24.0 : 8.0,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey.shade800,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      if (_currentPage > 0)
                        IconButton(
                          onPressed: () {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          icon: const Icon(Icons.arrow_back_ios_new_rounded),
                          color: Colors.grey.shade400,
                        ),
                      const SizedBox(width: 8),
                      if (_currentPage < slides.length - 1)
                        FloatingActionButton(
                          onPressed: () {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          elevation: 0,
                          child: const Icon(Icons.arrow_forward_ios_rounded),
                        ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SlideWidget extends StatelessWidget {
  final CarouselSlide slide;
  final VoidCallback? onButtonPressed;

  const SlideWidget({
    super.key,
    required this.slide,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              slide.icon,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 48),
          Text(
            slide.title,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            slide.text,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: Colors.white.withOpacity(0.9),
              height: 1.5,
            ),
          ),
          if (slide.buttonText != null) ...[
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: FilledButton(
                onPressed: onButtonPressed,
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                child: Text(slide.buttonText!),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
