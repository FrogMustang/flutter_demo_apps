import 'package:flutter/material.dart';
import 'package:flutter_demo_apps/screens/art_collections_screen.dart';
import 'package:flutter_demo_apps/screens/infinite_scroll_screen.dart';
import 'package:flutter_demo_apps/screens/tic_tac_toe_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SizedBox(
          height: 1.sh,
          width: 1.sw,
          child: Column(
            children: [
              SizedBox(height: 40.h),

              /// SCREEN TITLE
              Text(
                "Welcome",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(height: 20.h),

              /// SELECT A DEMO
              Text(
                "Select one of the demos",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 24,
                    ),
              ),
              Text(
                "P.S. They're different and independent",
                style: Theme.of(context).textTheme.titleSmall,
              ),
              SizedBox(height: 80.h),

              /// CLAY - INFINITE LOOP
              _buildButton(
                "Clay",
                "infinite auto-loop",
                const InfiniteScrollScreen(),
              ),
              SizedBox(height: 40.h),

              /// RIJKS MUSEUM
              _buildButton(
                "Rijks Museum",
                "lazy loading lists with categories",
                const CollectionsScreen(),
              ),
              SizedBox(height: 40.h),

              /// TIC TAC TOE
              _buildButton(
                "TicTacToe",
                "",
                const TicTacToeScreen(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String title, String subtitle, screen) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => screen));
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.white,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 30.r, vertical: 10.r),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 5.r),
          child: Column(
            children: [
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(color: Colors.black),
              ),
              subtitle.isNotEmpty
                  ? Text(
                      subtitle,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(color: Colors.black),
                      textAlign: TextAlign.center,
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
