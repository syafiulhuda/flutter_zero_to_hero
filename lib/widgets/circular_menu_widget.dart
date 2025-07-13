// ignore_for_file: unused_import

import 'dart:math';

import 'package:camera/camera.dart';
import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zth/data/constants.dart';
import 'package:flutter_zth/routes/route.dart';
import 'package:go_router/go_router.dart';

class CircularMenuWidget extends StatefulWidget {
  const CircularMenuWidget({super.key});

  @override
  State<CircularMenuWidget> createState() => _CircularMenuWidgetState();
}

class _CircularMenuWidgetState extends State<CircularMenuWidget> {
  bool showMenu = true;

  // ! Func to handler circular menu
  void _openCamera(BuildContext context) async {
    final cameras = await availableCameras();
    final controller = CameraController(cameras[0], ResolutionPreset.max);

    try {
      await controller.initialize();

      if (!context.mounted) return;

      await showDialog(
        context: context,
        builder:
            (_) => Dialog(
              child: AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: CameraPreview(controller),
              ),
            ),
      );
    } catch (e) {
      debugPrint("Camera error: $e");
    } finally {
      await controller.dispose();
    }
  }

  void _showSearchAnchor(BuildContext context) async {
    setState(() => showMenu = false);

    await showModalBottomSheet(
      context: context,
      builder: (_) {
        final SearchController searchController = SearchController();

        return Padding(
          padding: const EdgeInsets.all(16),
          child: SearchAnchor(
            isFullScreen: true,
            searchController: searchController,
            builder: (context, controller) {
              return SearchBar(
                controller: controller,
                padding: const WidgetStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 16),
                ),
                backgroundColor: WidgetStatePropertyAll(
                  KTextStyle.generalTextStyle(context),
                ),
                onTap: () => controller.openView(),
                onChanged: (_) => controller.openView(),
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.search),
                ),
              );
            },
            suggestionsBuilder: (context, controller) {
              final query = controller.text.toLowerCase();
              final filtered =
                  appRoutes
                      .where((item) => item.title.toLowerCase().contains(query))
                      .toList();

              return List<Widget>.generate(filtered.length, (index) {
                final routeItem = filtered[index];

                return ListTile(
                  contentPadding: const EdgeInsets.all(8),
                  title: Text(
                    routeItem.title,
                    style: KTextStyle.bodyTextStyle(context),
                  ),
                  subtitle: Text(
                    'Path: ${routeItem.path}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                    color: KTextStyle.generalColor(context),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    context.push(routeItem.path);
                  },
                );
              });
            },
          ),
        );
      },
    );

    setState(() => showMenu = true);
  }

  @override
  Widget build(BuildContext context) {
    List<CircularMenuItem> items = [
      CircularMenuItem(
        icon: Icons.camera_alt_outlined,
        onTap: () {
          _openCamera(context);
        },
        iconColor: KTextStyle.generalColor(context),
        color: KTextStyle.generalTextStyle(context),
      ),
      CircularMenuItem(
        icon: Icons.search_off_outlined,
        onTap: () {
          _showSearchAnchor(context);
        },
        iconColor: KTextStyle.generalColor(context),
        color: KTextStyle.generalTextStyle(context),
      ),
      CircularMenuItem(
        icon: Icons.settings_outlined,
        onTap: () {},
        iconColor: KTextStyle.generalColor(context),
        color: KTextStyle.generalTextStyle(context),
      ),
    ];

    return showMenu
        ? CircularMenu(
          alignment: Alignment.bottomRight,
          startingAngleInRadian: 1.05 * pi,
          endingAngleInRadian: 1.5 * pi,
          toggleButtonIconColor: KTextStyle.generalTextStyle(context),
          toggleButtonColor: KTextStyle.generalColor(context),
          items: items,
        )
        : const SizedBox.shrink();
  }
}
