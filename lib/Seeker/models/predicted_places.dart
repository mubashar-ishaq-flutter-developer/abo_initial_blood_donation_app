// ignore_for_file: non_constant_identifier_names

class PredictedPlaces {
  //from places api write json to capture location information
  String? place_id;
  String? main_text;
  String? secondary_text;
  //constructor
  PredictedPlaces({
    this.place_id,
    this.main_text,
    this.secondary_text,
  });
  //for prediction
  PredictedPlaces.fromJson(Map<String, dynamic> jsonData) {
    //getting from the json and assign to these variables
    place_id = jsonData["place_id"];
    //main text in the structure formatting
    main_text = jsonData["structured_formatting"]["main_text"];
    //secondary text in the structure formatting
    secondary_text = jsonData["structured_formatting"]["secondary_text"];
  }
}
