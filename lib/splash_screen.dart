import 'package:animate_do/animate_do.dart';
import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/features/auth/presentation/page/login_screen.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'features/auth/presentation/bloc/auth_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthIsUserLoggedIn());
    Future.delayed(
      const Duration(seconds: 3),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppPallete.backgroundColor, // Set background color to black
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(right: 8.0, left: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 40),
              BounceInDown(
                duration: const Duration(seconds: 2),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: SvgPicture.asset('assets/image/logo.svg',
                      semanticsLabel: 'Acme Logo'),
                ),
              ),
              const SizedBox(height: 40),
              FadeIn(
                duration: const Duration(seconds: 1),
                child: Text('Blog App',
                    style: GoogleFonts.openSans(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppPallete.whiteColor,
                    )),
              ),
              const SizedBox(height: 40),
              FadeInUp(
                duration: const Duration(seconds: 1, milliseconds: 500),
                child: Text(
                  "Focus on producing a blog that's great for your readers.",
                  style: GoogleFonts.openSans(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: AppPallete.whiteColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 110),
              BlocSelector<AppUserCubit, AppUserState, bool>(
                selector: (state) {
                  return state is AppUserLoggedIn;
                },
                builder: (context, isLoggedIn) {
                  return FadeInUp(
                    duration: const Duration(seconds: 1),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 50,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppPallete.gradient1,
                        ),
                        onPressed: () {
                          if (isLoggedIn) {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const BlogPage()),
                                (route) => false);
                          } else {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()),
                                (route) => false);
                          }
                        },
                        child: const Text(
                          'Get Started',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppPallete.whiteColor,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
