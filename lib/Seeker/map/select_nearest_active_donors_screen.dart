import 'package:abo_initial/Common/tostmessage/tost_message.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';

import '../../Common/global/global_variable.dart';

class SelectNearestActiveDonorsScreen extends StatefulWidget {
  final DatabaseReference? refrenceRideRequest;
  const SelectNearestActiveDonorsScreen({super.key, this.refrenceRideRequest});

  @override
  State<SelectNearestActiveDonorsScreen> createState() =>
      SelectNearestActiveDonorsScreenState();
}

class SelectNearestActiveDonorsScreenState
    extends State<SelectNearestActiveDonorsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: const Text(
          "Nearest Online Donors",
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () {
            //delete/remove the seeker request from database
            widget.refrenceRideRequest!.remove();
            TostMessage().tostMessage("You Cancel the Ride Request");
            SystemNavigator.pop();
          },
        ),
      ),
      body: ListView.builder(
        itemCount: dList.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                chosenDonorId = dList[index]["id"].toString();
              });
              Navigator.pop(context, "selectedDonor");
            },
            child: Card(
              color: Colors.grey,
              elevation: 3,
              shadowColor: Colors.green,
              margin: const EdgeInsets.all(8),
              child: ListTile(
                leading: Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Image.asset(
                    "assets/${dList[index]["bloodgroup"]}.png",
                    width: 70,
                  ),
                ),
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      dList[index]["fname"] + " " + dList[index]["lname"],
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black54,
                      ),
                    ),
                    Text(
                      dList[index]["bloodgroup"],
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.red,
                      ),
                    ),
                    // SmoothStarRating(
                    //   rating: 3.5,
                    //   color: Colors.black,
                    //   borderColor: Colors.black,
                    //   allowHalfRating: true,
                    //   starCount: 5,
                    //   size: 15,
                    // ),
                  ],
                ),
                // trailing: Column(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: const [
                //     Text(
                //       "3",
                //       style: TextStyle(
                //         fontWeight: FontWeight.bold,
                //       ),
                //     ),
                //     SizedBox(
                //       height: 2,
                //     ),
                //     Text(
                //       "13 km",
                //       style: TextStyle(
                //           fontWeight: FontWeight.bold,
                //           color: Colors.black54,
                //           fontSize: 12),
                //     ),
                //   ],
                // ),
              ),
            ),
          );
        },
      ),
    );
  }
}
