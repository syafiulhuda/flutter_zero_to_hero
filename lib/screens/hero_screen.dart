import 'package:flutter/material.dart';
import 'package:flutter_zth/data/constants.dart';

class HeroScreen extends StatelessWidget {
  const HeroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: colorScheme.inversePrimary,
        title: Text(
          "Hero",
          style: TextStyle(color: colorScheme.onInverseSurface),
        ),
      ),
      body: Center(
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return Scaffold(
                    appBar: AppBar(
                      centerTitle: true,
                      backgroundColor: colorScheme.inversePrimary,
                      title: Text(
                        "Hero Detail Page",
                        style: TextStyle(color: colorScheme.onInverseSurface),
                      ),
                    ),
                    body: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      color: KTextStyle.generalColor(context),
                      child: Hero(
                        tag: "myHeroImage",
                        child: SizedBox(
                          width: 250,
                          height: 250,
                          child: Image.network(
                            "https://keyword-hero.com/wp-content/uploads/2017/04/Cart-Hero.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
          child: Hero(
            tag: "myHeroImage",
            child: SizedBox(
              width: 100,
              height: 100,
              child: Image.network(
                "https://keyword-hero.com/wp-content/uploads/2017/04/Cart-Hero.png",
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  return Center(
                    child: CircularProgressIndicator(
                      value:
                          loadingProgress != null &&
                                  loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,

                      // value: loadingProgress?.expectedTotalBytes != null ? loadingProgress!.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
