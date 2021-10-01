import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class Methods {
  LocalStorage storage = LocalStorage('silkroute');
  redirectToRegister(contact, context) {
    print("Check $contact");
    if (contact != null) {
      if (contact.length != 10) {
        storage.clear();
        contact = null;
      }
    }
    if (contact == null || contact.length != 10) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 16,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.height * 0.8,
              child: Container(
                child: Column(
                  children: <Widget>[
                    Text(
                      "Your contact is not registered yet",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                        child: Text("Click here to register"),
                        style: ElevatedButton.styleFrom(primary: Colors.teal),
                        onPressed: () {
                          Navigator.of(context).pushNamed('/enter_contact');
                        }),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }
  }
}
