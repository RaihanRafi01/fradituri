import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/modules/home/controllers/home_controller.dart';

class CustomDropdownExample {
  final HomeController homeController = Get.put(HomeController());
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
              width: 250, // Increased width to fit menu button
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(10),
              ),
              child: SingleChildScrollView(
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
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          chat['name'] ?? "Untitled Chat",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        trailing: PopupMenuButton<String>(
                          icon: Icon(Icons.more_vert, color: Colors.white),
                          color: Colors.black,
                          onSelected: (value) {
                            if (value == 'edit') {
                              _showEditDialog(context, chat);
                            } else if (value == 'delete') {
                              _showDeleteDialog(context, chat);
                            }
                          },
                          itemBuilder: (BuildContext context) => [
                            PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(Icons.edit, color: Colors.white),
                                  SizedBox(width: 8),
                                  Text("Edit", style: TextStyle(color: Colors.white)),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete, color: Colors.red),
                                  SizedBox(width: 8),
                                  Text("Delete", style: TextStyle(color: Colors.red)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          print('Selected chat ID: ${chat['id']}');
                          Navigator.pop(context); // Close the dropdown
                        },
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Show Edit Chat Name Dialog
  void _showEditDialog(BuildContext context, Map<String, String> chat) {
    TextEditingController _controller = TextEditingController(text: chat['name']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Chat Name"),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: "Enter new chat name",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                String newName = _controller.text.trim();
                if (newName.isNotEmpty) {
                  print("Will be Renamed Chat ID: ${chat['id']} to $newName");
                  Navigator.pop(context);
                  Navigator.pop(context);
                  await homeController.updateChatName(newName, chat['id']!);

                }
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  /// Show Delete Confirmation Dialog
  void _showDeleteDialog(BuildContext context, Map<String, String> chat) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Chat"),
          content: Text("Are you sure you want to delete '${chat['name']}'?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                print("Will be Deleted Chat ID: ${chat['id']}");
                Navigator.pop(context);
                Navigator.pop(context);
                await homeController.deleteChat(chat['id']!);

              },
              child: Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
