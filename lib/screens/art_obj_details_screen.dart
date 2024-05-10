import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_apps/models/art_object.dart';
import 'package:flutter_demo_apps/providers/art_objects_provider.dart';
import 'package:flutter_demo_apps/utils/utils.dart';
import 'package:provider/provider.dart';

class DetailsScreen extends StatefulWidget {
  final ArtObject artObject;

  const DetailsScreen({
    super.key,
    required this.artObject,
  });

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  /// the art object for which we are displaying the details
  late ArtObject _artObject;

  /// Used to get current screen size
  Size? _screenSize;

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () =>
          context.read<ArtObjectsProvider>().getObjectDetails(widget.artObject),
    );
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    // art object should not be null here
    _artObject = context.watch<ArtObjectsProvider>().artObject!;

    return Scaffold(
      body: SafeArea(
        child: _artObject.detailsFetched()
            ? DetailsScreenPlaceholder(_artObject)
            : _buildDetailsScreen(),
      ),
    );
  }

  Widget _buildDetailsScreen() {
    return SizedBox(
      height: _screenSize!.height,
      width: _screenSize!.width,
      child: Stack(
        children: [
          /// screen
          ScrollConfiguration(
            behavior: NoMoreGlow(),
            child: ListView(
              key: const Key("detailsScreen"),
              children: [
                _buildImage(),
                const SizedBox(height: 20),

                /// ART OBJECT TITLE & DETAILS
                _buildTitleAndDetails(),
                const SizedBox(height: 80),
              ],
            ),
          ),

          /// back button
          Positioned(
            top: 10,
            left: 10,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(7),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildImage() {
    return AspectRatio(
      key: const Key("artObjectImage"),
      aspectRatio: _artObject.imgRatio,
      child: Container(
        constraints: BoxConstraints(maxHeight: _screenSize!.height * 0.7),
        child: Hero(
          tag: _artObject.objNr + _artObject.img,
          child: CachedNetworkImage(
            imageUrl: _artObject.img,
            progressIndicatorBuilder: (BuildContext context, String imgUrl,
                DownloadProgress progress) {
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
    );
  }

  Widget _buildTitleAndDetails() {
    return Padding(
      key: const Key("titleAndDetails"),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          /// TITLE
          Text(
            _artObject.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              color: Colors.black,
              fontFamily: "Mont",
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),

          /// LABEL
          Text(
            _artObject.label ?? " - ",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontFamily: "Mont",
              fontWeight: FontWeight.w400,
            ),
          ),
          const Divider(height: 40, thickness: 0.2, color: Colors.black),

          /// DETAILS
          const Text(
            "Details",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontFamily: "Mont",
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),

          Text(
            "Maker: ${_artObject.maker}",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontFamily: "Mont",
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 10),

          Text(
            "Dating: ${_artObject.date}",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontFamily: "Mont",
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 10),

          Text(
            "Types: ${_artObject.types?.join(", ") ?? " - "}",
            key: const Key("artObjectTypes"),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontFamily: "Mont",
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 10),

          Text(
            "Materials: ${_artObject.materials?.join(", ") ?? " - "}",
            key: const Key("artObjectMaterials"),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontFamily: "Mont",
              fontWeight: FontWeight.w400,
            ),
          ),
          const Divider(height: 40, thickness: 0.2, color: Colors.black),

          const Text(
            "Description",
            key: Key("artObjectDescription"),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontFamily: "Mont",
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),

          Text(
            _artObject.description ?? " - ",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontFamily: "Mont",
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class DetailsScreenPlaceholder extends StatelessWidget {
  final ArtObject obj;

  const DetailsScreenPlaceholder(this.obj, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const Key("detailsScreenPlaceholder"),
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Hero(
          tag: obj.objNr + obj.img,
          child: Container(
            height: MediaQuery.of(context).size.width / obj.imgRatio,
            color: Colors.black.withOpacity(0.2),
          ),
        ),
        const SizedBox(height: 20),
        Utils.placeholder(
          20,
          20,
          width: MediaQuery.of(context).size.width * 0.9,
        ),
        Utils.placeholder(
          10,
          10,
          width: MediaQuery.of(context).size.width * 0.5,
        ),
        Utils.placeholder(
          10,
          10,
          width: MediaQuery.of(context).size.width * 0.7,
        ),
      ],
    );
  }
}
