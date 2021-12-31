import 'dart:convert';

import 'package:http/http.dart' as http;

class PincodeApi {
  Future getAddress(String pincode) async {
    try {
      print("picodeapi get address - $pincode");
      String url = "https://api.postalpincode.in/pincode/" + pincode;
      var uri = Uri.parse(url);
      var res = await http.get(uri);
      var data = jsonDecode(res.body);
      var address = [];
      for (var postoffice in data[0]["PostOffice"]) {
        address.add({
          "Name": postoffice["Name"],
          "District": postoffice["District"],
          "State": postoffice["State"]
        });
      }
      return address;
    } catch (err) {
      print("picodeapi getAddress err - $err");
      return err;
    }
  }
}
