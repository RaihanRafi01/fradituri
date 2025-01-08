import 'package:flutter/material.dart';

class CustomDropdownExample {
  void showMenuDropdown(BuildContext context) {
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
                  Text(
                    "Today chat",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                  Divider(color: Colors.white54),
                  _chatItem("Chat 1........."),
                  _chatItem("Chat 2........."),
                  _chatItem("Chat 3........."),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _chatItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: TextStyle(color: Colors.white),
          ),
          Icon(Icons.more_horiz, color: Colors.white),
        ],
      ),
    );
  }
}
