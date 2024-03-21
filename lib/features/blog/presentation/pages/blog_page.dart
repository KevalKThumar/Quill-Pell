// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:animate_do/animate_do.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/features/auth/presentation/page/login_screen.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/pages/add_new_blog_page.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_viewer_page.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/common/widgets/dialogbox.dart';

class BlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const BlogPage(),
      );
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  final InternetConnection internetConnection = InternetConnection();
  bool isnetwotkConnected = false;
  late InternetConnection listener;
  final SupabaseClient supabaseClient = Supabase.instance.client;
  late Session? currentUserSession;
  @override
  void initState() {
    super.initState();
    listener = InternetConnection();
    checkConnection();
    context.read<BlogBloc>().add(BlogFetchAllBlogs());
    currentUserSession = supabaseClient.auth.currentSession;
  }

  void checkConnection() async {
    listener.onStatusChange.listen((InternetStatus status) {
      switch (status) {
        case InternetStatus.connected:
          setState(() {
            isnetwotkConnected = true;
          });
          break;
        case InternetStatus.disconnected:
          setState(() {
            isnetwotkConnected = false;
          });
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await dialogBox(
          context: context,
          onNoPressed: () {
            Navigator.pop(context);
          },
          onYesPressed: () async {
             SystemNavigator.pop();
          },
          title: "Are you sure you want to exit?",
        );
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          elevation: 0,
          onPressed: () {
            Navigator.push(context, AddNewBlogPage.route());
          },
          backgroundColor: AppPallete.gradient2,
          child: const Icon(
            Icons.add,
            color: AppPallete.whiteColor,
          ),
        ),
        appBar: AppBar(
          title: const Text(
            'Blog App',
            style: TextStyle(
              color: AppPallete.whiteColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: IconButton(
                onPressed: () async {
                  dialogBox(
                    context: context,
                    onNoPressed: () {
                      Navigator.pop(context);
                    },
                    onYesPressed: () async {
                      await supabaseClient.auth.signOut();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                          (route) => false);
                    },
                    title: "Are you sure you want to logout?",
                  );
                },
                icon: const Icon(
                  Icons.logout,
                ),
              ),
            ),
          ],
        ),
        body: BlocConsumer<BlogBloc, BlogState>(
          listener: (context, state) {
            if (state is BlogFailure) {
              showSnackBar(context, state.error);
            }
          },
          builder: (context, state) {
            if (state is BlogLoading) {
              return Shimmer.fromColors(
                baseColor: Colors.grey.shade100.withOpacity(0.5),
                highlightColor: Colors.grey.shade400.withOpacity(0.5),
                enabled: true,
                child: const SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      LodingBlogCard(),
                      LodingBlogCard(),
                      LodingBlogCard(),
                      LodingBlogCard(),
                    ],
                  ),
                ),
              );
            }
            if (state is BlogsDisplaySuccess) {
              return RefreshIndicator(
                color: AppPallete.gradient3,
                backgroundColor: Colors.transparent,
                triggerMode: RefreshIndicatorTriggerMode.anywhere,
                onRefresh: () {
                  log(isnetwotkConnected.toString());
                  return Future.delayed(
                      const Duration(seconds: 1, milliseconds: 500), () async {
                    checkConnection();
                    log(isnetwotkConnected.toString());
                    context.read<BlogBloc>().add(BlogFetchAllBlogs());
                  });
                },
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: state.blogs.length,
                  itemBuilder: (context, index) {
                    final blog = state.blogs[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            BlogViewerPage.route(blog, isnetwotkConnected));
                      },
                      child: ZoomIn(
                        delay: Duration(milliseconds: 100 * index),
                        curve: Curves.easeInOut,
                        animate: true,
                        child: BlogCard(
                          blog: blog,
                          color: index % 2 == 0
                              ? AppPallete.gradient1
                              : AppPallete.gradient2,
                        ),
                      ),
                    );
                  },
                ),
              );
            }
            return const Center(
              child: Text(
                'No blogs found',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
