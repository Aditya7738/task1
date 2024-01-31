import 'package:flutter/material.dart';
import 'package:task_1/constants/constants.dart';
import 'package:task_1/helpers/db_helper.dart';
import 'package:task_1/model/wishlist_model.dart';
import 'package:provider/provider.dart';
import 'package:task_1/providers/wishlist_provider.dart';

class WishListPage extends StatefulWidget {
  WishListPage({super.key});

  @override
  State<WishListPage> createState() => _WishListPageState();
}

class _WishListPageState extends State<WishListPage> {
  late DBHelper dbHelper;

  bool loadingWishList = false;

  List<WishlistModel>? wishlist;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    dbHelper = DBHelper();
  }

  Future<void> getWishList(int userID) async {
    setState(() {
      loadingWishList = true;
    });
    wishlist = await dbHelper.getFavDogsByUserId(userID);
    setState(() {
      loadingWishList = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final wishListProvider = Provider.of<WishlistProvider>(context);
    getWishList(wishListProvider.userId);
    return Scaffold(
        appBar: AppBar(
          title: Text("Wishlist"),
        ),
        body: loadingWishList
            ? Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                ),
              )
            : wishlist != null
                ? wishlist!.length == 0
                    ? SizedBox()
                    : GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 0.64,
                            crossAxisCount:
                                MediaQuery.of(context).size.width > 600 ? 4 : 2,
                            crossAxisSpacing: 5.0,
                            mainAxisSpacing: 10.0),
                        itemCount: wishlist!.length,
                        itemBuilder: (context, index) {
                          WishlistModel wishlistModel = wishlist![index];

                          return Card(
                            child: Column(
                              children: [
                                Image.network(
                                  Constants.dogImageUrl,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    }
                                    return SizedBox(
                                      width:
                                          (MediaQuery.of(context).size.width /
                                                  2) +
                                              16.0,
                                      height:
                                          (MediaQuery.of(context).size.width /
                                                  2) +
                                              10.0,
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.black,
                                        ),
                                      ),
                                    );
                                  },
                                  width:
                                      (MediaQuery.of(context).size.width / 2) +
                                          16.0,
                                  height:
                                      (MediaQuery.of(context).size.width / 2) +
                                          5.0,
                                  fit: BoxFit.fill,
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width:
                                            (MediaQuery.of(context).size.width /
                                                    3) -
                                                10,
                                        child: Text(
                                          wishlistModel.name ?? "Dog",
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: true,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      IconButton(
                                          icon: Icon(
                                            wishListProvider.favDogIds.contains(
                                                    wishlistModel.dogId)
                                                ? Icons.favorite
                                                : Icons
                                                    .favorite_border_outlined,
                                            color: Colors.red,
                                            size: 30.0,
                                          ),
                                          onPressed: () async {
                                            print("PRESSED");
                                            setState(() {
                                              loadingWishList = true;
                                            });
                                            await dbHelper
                                                .deleteItemFromWishList(
                                                    int.parse(
                                                        wishlistModel.dogId));

                                            getWishList(
                                                wishListProvider.userId);

                                            wishListProvider.removeFromWishlist(
                                                int.parse(wishlistModel.dogId));

                                            print(
                                                "Dog is removed from wishlist");

                                            // if (wishListProvider.favDogIds
                                            //     .contains(
                                            //         wishlistModel.dogId)) {
                                            //   setState(() {
                                            //     loadingWishList = true;
                                            //   });
                                            //   await dbHelper
                                            //       .deleteItemFromWishList(
                                            //           int.parse(
                                            //               wishlistModel.dogId));

                                            //   getWishList(
                                            //       wishListProvider.userId);

                                            //   wishListProvider
                                            //       .removeFromWishlist(int.parse(
                                            //           wishlistModel.dogId));

                                            //   print(
                                            //       "Dog is removed from wishlist");
                                            // } else if (wishListProvider
                                            //         .favDogIds.length <
                                            //     5) {
                                            //   Map<String, String> data = {
                                            //     'dogId': wishlistModel.dogId,
                                            //     'name': wishlistModel.name,
                                            //     'referenceImageId':
                                            //         wishlistModel
                                            //             .referenceImageId
                                            //   };

                                            //   await dbHelper
                                            //       .insertIntoWishlistTable(
                                            //           data);
                                            //   wishListProvider.addToWishlist(
                                            //       wishlistModel.id);
                                            //   print(
                                            //       "Dog is added to wishlist");
                                            // } else {
                                            //   ScaffoldMessenger.of(context)
                                            //       .showSnackBar(SnackBar(
                                            //           padding:
                                            //               EdgeInsets.all(15.0),
                                            //           backgroundColor:
                                            //               Colors.red,
                                            //           content: Text(
                                            //               "Wishlist can contain only 5 items.")));
                                            // }
                                          }),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        })
                : SizedBox());
  }
}
