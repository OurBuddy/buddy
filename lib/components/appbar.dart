import 'package:buddy/components/image_poster.dart';
import 'package:buddy/components/new_post.dart';
import 'package:buddy/components/search.dart';
import 'package:buddy/components/text_poster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppBarBuddy extends StatelessWidget implements PreferredSizeWidget {
  const AppBarBuddy({
    super.key,
    this.actions,
  });

  final List<Widget>? actions;

  @override
  Size get preferredSize {
    return const Size.fromHeight(65);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      toolbarHeight: 65,
      backgroundColor: Colors.white,
      elevation: 0,
      titleSpacing: 16,
      title: Align(
        alignment: Alignment.centerLeft,
        child: Image.asset(
          "assets/icons/logo.png",
          height: 50,
        ),
      ),
      actions: actions ??
          [
            IconButton(
              onPressed: () {
                // Open bottom sheet

                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return NewPost(
                        onPost: () {
                          Navigator.pop(context);
                          showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: (context) {
                              return const TextPostDialog();
                            },
                          );
                        },
                        onImage: () {
                          Navigator.pop(context);
                          showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: (context) {
                              return const ImagePostDialog();
                            },
                          );
                        },
                      );
                    });
              },
              icon: Container(
                margin: const EdgeInsets.all(4),
                padding: const EdgeInsets.all(4.0),
                child: SvgPicture.asset(
                  "assets/icons/rectangle-history-circle-plus-duotone.svg",
                  width: 26,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return const AlertDialog(
                        scrollable: true,
                        insetPadding: EdgeInsets.all(10),
                        title: Text("Search"),
                        content: SizedBox(
                          width: double.infinity,
                          child: SearchDialog(),
                        ),
                      );
                    });
              },
              icon: Container(
                margin: const EdgeInsets.all(4),
                padding: const EdgeInsets.all(4.0),
                child: SvgPicture.asset(
                  "assets/icons/search.svg",
                  width: 24,
                ),
              ),
            ),
          ],
    );
  }
}
