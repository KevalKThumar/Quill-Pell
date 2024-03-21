// ignore_for_file: must_be_immutable

import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/calculate_reading_time.dart';
import 'package:blog_app/core/utils/format_date.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class BlogViewerPage extends StatefulWidget {
  static route(Blog blog, bool isNetwork) => MaterialPageRoute(
        builder: (context) => BlogViewerPage(
          blog: blog,
          isNetwork: isNetwork,
        ),
      );
  final Blog blog;
  bool isNetwork;
  BlogViewerPage({
    super.key,
    required this.blog,
    required this.isNetwork,
  });

  @override
  State<BlogViewerPage> createState() => _BlogViewerPageState();
}

class _BlogViewerPageState extends State<BlogViewerPage> {
  ScrollController scrollController = ScrollController();

  final InternetConnection internetConnection = InternetConnection();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog Viewer'),
        centerTitle: true,
      ),
      body: Scrollbar(
        scrollbarOrientation: ScrollbarOrientation.right,
        controller: scrollController,
        child: RefreshIndicator(
          color: AppPallete.gradient3,
          backgroundColor: Colors.transparent,
          triggerMode: RefreshIndicatorTriggerMode.anywhere,
          onRefresh: () {
            return Future.delayed(const Duration(seconds: 2), () async {
              if (!(await internetConnection.hasInternetAccess)) {
                widget.isNetwork = !widget.isNetwork;
              }
              setState(() {});
            });
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.blog.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'By ${widget.blog.userName}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${formatDateBydMMMYYYY(widget.blog.updatedAt)} . ${calculateReadingTime(widget.blog.content)} min',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: AppPallete.greyColor,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: widget.isNetwork == true
                        ? Image.network(
                            widget.blog.imageUrl,
                            frameBuilder: (context, child, frame,
                                wasSynchronouslyLoaded) {
                              if (wasSynchronouslyLoaded) {
                                return child;
                              }
                              return AnimatedOpacity(
                                opacity: frame == null ? 0 : 1,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInCirc,
                                child: child,
                              );
                            },
                          )
                        : const Text(
                            "In offline mode no image available",
                            style: TextStyle(
                              color: AppPallete.greyColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.blog.content,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 2,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
