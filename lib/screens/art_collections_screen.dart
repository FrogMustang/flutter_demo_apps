import 'dart:async';
import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_apps/models/art_object.dart';
import 'package:flutter_demo_apps/providers/art_objects_provider.dart';
import 'package:flutter_demo_apps/screens/art_obj_details_screen.dart';
import 'package:flutter_demo_apps/utils/utils.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:provider/provider.dart';

class CollectionsScreen extends StatefulWidget {
  const CollectionsScreen({Key? key}) : super(key: key);

  @override
  State<CollectionsScreen> createState() => _CollectionsScreenState();
}

class _CollectionsScreenState extends State<CollectionsScreen> {
  /// Number of items to fetch at a time
  int itemsOnPage = 10;

  /// Used to get current screen size
  Size? _screenSize;

  /// Custom scroll controller to fetch items only when needed
  /// so when bottom of list is reached, fetch some more items
  final ScrollController _scrollController = ScrollController();

  /// set to store the sculptures
  late Set<ArtObject> _sculptures;

  /// set to store the photographs
  late Set<ArtObject> _photographs;

  /// set to store the paintings
  late Set<ArtObject> _paintings;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.extentAfter < 300 &&
          !(context.read<ArtObjectsProvider>().isFetching)) {
        context
            .read<ArtObjectsProvider>()
            .getObjects(itemsOnPage)
            .catchError((e) {
          log("EXCEPTION HomeScreen get objects: ", error: e.toString());
        });
      }
    });

    Future.microtask(() {
      context
          .read<ArtObjectsProvider>()
          .getObjects(itemsOnPage)
          .catchError((e) {
        log("EXCEPTION HomeScreen get objects: ", error: e.toString());
      });
      // debugPrint("FETCHING MORE ITEMS");
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    _sculptures = context.watch<ArtObjectsProvider>().sculptures;
    _photographs = context.watch<ArtObjectsProvider>().photographs;
    _paintings = context.watch<ArtObjectsProvider>().paintings;

    return Scaffold(
      // backgroundColor: Colors.black,
      body: SafeArea(
        child: SizedBox(
          height: _screenSize!.height,
          width: _screenSize!.width,
          child: CustomScrollView(
            key: const Key("homeScreen"),
            controller: _scrollController,
            slivers: [
              /// SCREEN TITLE
              SliverAppBar(
                key: const Key("sliverAppBar"),
                pinned: true,
                backgroundColor: Colors.white,
                expandedHeight: _screenSize!.height * 0.4,
                collapsedHeight: 60,
                flexibleSpace: FlexibleSpaceBar(
                  background: FittedBox(
                    fit: BoxFit.cover,
                    child: Image.asset("assets/images/museum_logo.jpg"),
                  ),
                  centerTitle: true,
                  title: const Text(
                    "Collections",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                      fontFamily: "Mont",
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                iconTheme: const IconThemeData(color: Colors.black),
              ),

              _sculptures.isNotEmpty
                  ? _stickyHeaderList("Sculptures", _sculptures)
                  : const SliverToBoxAdapter(child: HomeScreenPlaceHolder()),
              _photographs.isNotEmpty
                  ? _stickyHeaderList("Photographs", _photographs)
                  : const SliverToBoxAdapter(
                      child: SizedBox(),
                    ),
              _paintings.isNotEmpty
                  ? _stickyHeaderList("Paintings", _paintings)
                  : const SliverToBoxAdapter(
                      child: SizedBox(),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stickyHeaderList(String header, Set<ArtObject> items) {
    return SliverStickyHeader(
      header: Container(
        color: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Text(
          header,
          style: const TextStyle(
            fontFamily: "Mont",
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, i) => _buildArtObject(items, i),
          childCount: items.length,
        ),
      ),
    );
  }

  Widget _buildArtObject(Set<ArtObject> itms, int i) {
    List<ArtObject> items = itms.toList();

    return InkWell(
      key: Key("artObject_${items[i].objNr}"),
      onTap: () {
        // update the art object inside the provider
        // to have a smooth transition using Hero Widget.
        // If not, the tag doesn't update and it will briefly show the
        // previous object details, until [getObjectDetails] method updates
        // the art object inside the provider
        context.read<ArtObjectsProvider>().artObject = items[i];

        /// GO TO DETAILS SCREEN
        /// where more details about the art object are presented
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsScreen(
              artObject: items[i],
            ),
          ),
        );
      },
      child: SizedBox(
        width: _screenSize!.width,
        height: _screenSize!.height / (1.5 * items[i].imgRatio),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30),

            /// ART OBJECT IMAGE
            Flexible(
              child: Hero(
                tag: items[i].objNr + items[i].img,
                child: CachedNetworkImage(
                  imageUrl: items[i].img,
                  progressIndicatorBuilder: (BuildContext context,
                      String imgUrl, DownloadProgress progress) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.red,
                        value: progress.totalSize != null
                            ? progress.downloaded / progress.totalSize!
                            : null,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),

            /// ART OBJECT TITLE
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: AutoSizeText(
                items[i].title,
                maxLines: 2,
                minFontSize: 18,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: "Mont",
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontSize: 22,
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class HomeScreenPlaceHolder extends StatelessWidget {
  const HomeScreenPlaceHolder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      key: const Key("homeScreenPlaceholder"),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 1.1,
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            /// fake header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              width: MediaQuery.of(context).size.width,
              color: Colors.black,
              child: const Text(
                "Header",
                // textAlign: TextAlignVertical.center,
                style: TextStyle(
                  fontFamily: "Mont",
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(height: 40),

            /// fake items
            Utils.placeholder(300, 20, width: 200),
            Utils.placeholder(30, 60, width: 300),
            Utils.placeholder(300, 20, width: 200),
            Utils.placeholder(30, 60, width: 300),
          ],
        ),
      ),
    );
  }
}
