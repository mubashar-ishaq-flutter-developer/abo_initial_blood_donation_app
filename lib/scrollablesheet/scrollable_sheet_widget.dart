import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Common/global/global_variable.dart';
import '../infoHandler/app_info.dart';

class ScrollableSheetWidget extends StatefulWidget {
  const ScrollableSheetWidget({super.key});

  @override
  State<ScrollableSheetWidget> createState() => _ScrollableSheetWidgetState();
}

class _ScrollableSheetWidgetState extends State<ScrollableSheetWidget> {
  //controller
  final myLocationController = TextEditingController();
  final yourLocationController = TextEditingController();
  double searchLocationContainerHeight = 220;
  @override
  Widget build(BuildContext context) {
    //ui for searching location
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: AnimatedSize(
        curve: Curves.easeIn,
        duration: const Duration(milliseconds: 120),
        child: Container(
          height: searchLocationContainerHeight,
          decoration: const BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              topLeft: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            child: Column(
              children: [
                //from
                Row(
                  children: [
                    const Icon(
                      Icons.add_location_alt_outlined,
                      color: Colors.grey,
                    ),
                    const SizedBox(
                      width: 12.0,
                    ),
                    Text(
                      Provider.of<AppInfo>(context).userPickUpLocation != null
                          ? "${(Provider.of<AppInfo>(context).userPickUpLocation!.locationName!).substring(0, 24)}..."
                          : "not getting address",
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),

                const SizedBox(height: 10.0),

                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Colors.grey,
                ),

                const SizedBox(height: 16.0),

                //to
                Row(
                  children: [
                    const Icon(
                      Icons.add_location_alt_outlined,
                      color: Colors.grey,
                    ),
                    const SizedBox(
                      width: 12.0,
                    ),
                    Text(
                      "Where to go?",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),

                const SizedBox(height: 10.0),

                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Colors.grey,
                ),

                const SizedBox(height: 16.0),

                SizedBox(
                  height: 45,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isvisible = !isvisible;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      backgroundColor: Colors.red,
                    ),
                    child: const Text("Search Location"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


 // return Stack(
    //   fit: StackFit.expand,
    //   children: [
    //     DraggableScrollableSheet(
    //       initialChildSize: 0.3,
    //       minChildSize: 0.1,
    //       maxChildSize: 0.4,
    //       builder: (context, scrollController) => Container(
    //         decoration: BoxDecoration(
    //           color: Colors.white,
    //           borderRadius: const BorderRadius.only(
    //             topLeft: Radius.circular(15),
    //             topRight: Radius.circular(15),
    //           ),
    //         ),
    //         child: Container(
    //           margin: const EdgeInsets.symmetric(horizontal: 20),
    //           child: ListView(
    //             controller: scrollController,
    //             children: [
    //               const Icon(
    //                 Icons.horizontal_rule_rounded,
    //                 size: 30,
    //               ),
    //               const SizedBox(
    //                 height: 05,
    //               ),
    //               Row(
    //                 children: [
    //                   const Icon(
    //                     Icons.add_location_alt_outlined,
    //                     color: Colors.red,
    //                   ),
    //                   const SizedBox(
    //                     width: 12.0,
    //                   ),
    //                   Column(
    //                     crossAxisAlignment: CrossAxisAlignment.start,
    //                     children: [
    //                       const Text(
    //                         "From",
    //                         style: TextStyle(color: Colors.red, fontSize: 12),
    //                       ),
    //                       Text(
    //                         Provider.of<AppInfo>(context).userPickUpLocation !=
    //                                 null
    //                             ? (Provider.of<AppInfo>(context)
    //                                         .userPickUpLocation!
    //                                         .locationName!)
    //                                     .substring(0, 24) +
    //                                 "..."
    //                             : "not getting address",
    //                         style: const TextStyle(
    //                             color: Colors.grey, fontSize: 14),
    //                       ),
    //                     ],
    //                   ),
    //                 ],
    //               ),
    //               TextFormField(
    //                 controller: myLocationController,
    //                 decoration: InputDecoration(
    //                   // icon: const Icon(Icons.location_pin),
    //                   prefixIcon: const Icon(Icons.location_pin),
    //                   border: UnderlineInputBorder(
    //                     borderRadius: BorderRadius.circular(15),
    //                   ),
    //                   hintText: 'Select current location',
    //                 ),
    //               ),
    //               const SizedBox(
    //                 height: 05,
    //               ),
    //               TextField(
    //                 controller: yourLocationController,
    //                 keyboardType: TextInputType.text,
    //                 decoration: InputDecoration(
    //                   prefixIcon: const Icon(Icons.message),
    //                   border: UnderlineInputBorder(
    //                     borderRadius: BorderRadius.circular(15),
    //                   ),
    //                   hintText: 'Enter Your Message',
    //                 ),
    //               ),
    //               const SizedBox(
    //                 height: 10,
    //               ),
            //       SizedBox(
            //         height: 50,
            //         width: double.infinity,
            //         child: ElevatedButton(
            //           onPressed: () {},
            //           style: ElevatedButton.styleFrom(
            //             shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(15),
            //             ),
            //             textStyle: const TextStyle(
            //               fontSize: 20,
            //               fontWeight: FontWeight.bold,
            //             ),
            //             backgroundColor: Colors.red,
            //           ),
            //           child: const Text("Search Location"),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
    //       ),
    //     ),
    //   ],
    // );