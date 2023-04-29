import 'package:flutter/material.dart';

class ScrollableSheetWidget extends StatefulWidget {
  const ScrollableSheetWidget({super.key});

  @override
  State<ScrollableSheetWidget> createState() => _ScrollableSheetWidgetState();
}

class _ScrollableSheetWidgetState extends State<ScrollableSheetWidget> {
  //controller
  final myLocationController = TextEditingController();
  final yourLocationController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        DraggableScrollableSheet(
          initialChildSize: 0.3,
          minChildSize: 0.1,
          maxChildSize: 0.4,
          builder: (context, scrollController) => Container(
            decoration: BoxDecoration(
              color: Colors.deepOrange.shade400,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                controller: scrollController,
                children: [
                  const Icon(
                    Icons.horizontal_rule_rounded,
                    size: 30,
                  ),
                  const SizedBox(
                    height: 05,
                  ),
                  TextFormField(
                    controller: myLocationController,
                    decoration: InputDecoration(
                      // icon: const Icon(Icons.location_pin),
                      prefixIcon: const Icon(Icons.location_pin),
                      border: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      hintText: 'Select current location',
                    ),
                  ),
                  const SizedBox(
                    height: 05,
                  ),
                  TextField(
                    controller: yourLocationController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.message),
                      border: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      hintText: 'Enter Your Message',
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 20,
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
      ],
    );
  }
}
