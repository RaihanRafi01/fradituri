import 'package:flutter/material.dart';

class CustomDropdownExample {
  void showMenuDropdown(BuildContext context, List<Map<String, String>> chatHistories) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: EdgeInsets.only(top: 100, left: 10), // Adjust position
              width: 200, // Fixed width
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "History",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5),
                  Divider(color: Colors.white54),
                  // Loop through the chatHistories to display them
                  ...chatHistories.map((chat) {
                    return GestureDetector(
                      onTap: () {
                        print('Selected chat ID: ${chat['id']}');
                        Navigator.pop(context); // Close the dropdown
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          chat['name'] ?? "Untitled Chat",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

