import 'package:flutter/material.dart';
import 'package:task_1/constants/constants.dart';
import 'package:task_1/helpers/db_helper.dart';
import 'package:task_1/model/dog_data_model.dart';
import 'package:task_1/providers/wishlist_provider.dart';
import 'package:task_1/views/widgets/detail_widget.dart';
import 'package:provider/provider.dart';

class DogDetails extends StatefulWidget {
  DogDataModel dogDataModel;
  DogDetails({super.key, required this.dogDataModel});

  @override
  State<DogDetails> createState() => _DogDetailsState();
}

class _DogDetailsState extends State<DogDetails> {
  DogDataModel dogDataModel = DogDataModel();

  late DBHelper dbHelper;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHelper = DBHelper();
    dogDataModel = widget.dogDataModel;
  }

  @override
  Widget build(BuildContext context) {
    final wishListProvider = Provider.of<WishlistProvider>(context);
    print(" wishListProvider.favDogIds ${wishListProvider.favDogIds}");
    print("dogDataModel $dogDataModel");
    return Scaffold(
      appBar: AppBar(
        title: Text("Details"),
      ),
      body: Column(
        children: [
          Image.network(
            Constants.dogImageUrl,
            width: MediaQuery.of(context).size.width,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ),
                ),
              );
            },
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(dogDataModel.name ?? "Dog",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      style: Theme.of(context).textTheme.headline3),
                  IconButton(
                      icon: Icon(
                        wishListProvider.favDogIds.contains(dogDataModel.id)
                            ? Icons.favorite
                            : Icons.favorite_border_outlined,
                        color: Colors.red,
                        size: 30.0,
                      ),
                      onPressed: () async {
                        print("PRESSED");
                        if (wishListProvider.favDogIds
                            .contains(dogDataModel.id)) {
                          await dbHelper
                              .deleteItemFromWishList(dogDataModel.id!);

                          wishListProvider.removeFromWishlist(dogDataModel.id!);
                          print("Dog is removed from wishlist");
                        } else if (wishListProvider.favDogIds.length < 5) {
                          Map<String, dynamic> data = {
                            'userId': wishListProvider.userId,
                            'dogId': dogDataModel.id.toString(),
                            'name': dogDataModel.name!,
                            'referenceImageId': dogDataModel.referenceImageId!
                          };
                          await dbHelper.insertIntoWishlistTable(data);

                          wishListProvider.addToWishlist(dogDataModel.id!);

                          print("Dog is added to wishlist");
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              padding: EdgeInsets.all(15.0),
                              backgroundColor: Colors.red,
                              content:
                                  Text("Wishlist can contain only 5 items.")));
                        }
                      }),
                ],
              ),
              SizedBox(
                height: 5.0,
              ),
              Text("Description: ",
                  style: Theme.of(context).textTheme.headline3),
              SizedBox(
                height: 5.0,
              ),
              Text(
                dogDataModel.description ?? "Pet dog",
                maxLines: 12,
              ),
              SizedBox(
                height: 5.0,
              ),
              DetailWidget(
                  label: "Weight (in kg): ",
                  info: dogDataModel.height != null
                      ? dogDataModel.height!.metric ?? "3-20"
                      : "3-20"),
              SizedBox(
                height: 5.0,
              ),
              DetailWidget(
                label: "Weight (in lb): ",
                info: dogDataModel.height != null
                    ? dogDataModel.height!.imperial ?? "6-20"
                    : "3-20",
              ),
              SizedBox(
                height: 5.0,
              ),
              DetailWidget(
                label: "Bred for: ",
                info: dogDataModel.bredFor ?? "Playful dog",
              ),
              SizedBox(
                height: 5.0,
              ),
              DetailWidget(
                label: "Breed group: ",
                info: dogDataModel.breedGroup ?? "dog",
              ),
              SizedBox(
                height: 5.0,
              ),
              DetailWidget(
                label: "Life span: ",
                info: dogDataModel.lifeSpan ?? "10 - 12 years",
              ),
              SizedBox(
                height: 5.0,
              ),
              DetailWidget(
                label: "History: ",
                info: dogDataModel.history ?? "",
              ),
              SizedBox(
                height: 5.0,
              ),
              DetailWidget(
                label: "Temperament: ",
                info: dogDataModel.temperament ?? "Trainable",
              ),
            ]),
          )
        ],
      ),
    );
  }
}
