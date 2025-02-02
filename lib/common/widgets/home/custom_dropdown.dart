import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fradituri/app/modules/home/controllers/chat_controller.dart';
import 'package:fradituri/app/modules/home/views/home_view.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../app/modules/home/controllers/home_controller.dart';
import '../../../app/modules/home/views/chat_view.dart';

class CustomDropdownExample {
  final HomeController homeController = Get.put(HomeController());
  final ChatController chatController = Get.put(ChatController());

  Future<void> showMenuDropdown(BuildContext context, /*List<Map<String, String>> chatHistories,*/ bool isChat) async {
    //await homeController.fetchHistory();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: EdgeInsets.only(top: 100, left: 10),
              width: 250,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "History",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        if (isChat)
                          GestureDetector(
                            onTap: () {
                              Get.offAll(HomeView());
                            },
                            child: SvgPicture.asset('assets/images/home/new_icon.svg', color: Colors.white),
                          ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Divider(color: Colors.white54),

                    // Using Obx to listen for loading state
                    Obx(() {
                      if (homeController.isLoading.value) {
                        return _buildShimmerEffect(); // Show shimmer while loading
                      } else if (homeController.chatHistories.isEmpty) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Center(
                            child: Text(
                              "No chat history found",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      } else {
                        return Column(
                          children: homeController.chatHistories.map((chat) {
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
                              onTap: () async {
                                print('Selected chat ID: ${chat['id']}');
                                Navigator.pop(context);
                                await chatController.fetchChatHistory(chat['id']!);
                                Get.to(() => const ChatView());
                              },
                            );
                          }).toList(),
                        );
                      }
                    }),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildShimmerEffect() {
    return Column(
      children: List.generate(
        5, // Show 5 shimmer placeholders
            (index) => Padding(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[700]!,
            highlightColor: Colors.grey[500]!,
            child: Container(
              height: 20,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ),
      ),
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
