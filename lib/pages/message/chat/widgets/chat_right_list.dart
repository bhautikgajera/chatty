import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatty/common/entities/entities.dart';
import 'package:chatty/common/values/colors.dart';
import 'package:chatty/common/values/server.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatRightList extends StatelessWidget {
  const ChatRightList({required this.item, super.key});

  final Msgcontent item;

  @override
  Widget build(BuildContext context) {
    String url = '';
    if (item.type == 'image') {
      url = item.content!.replaceAll("http://localhost/", SERVER_API_URL);
    }
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 10.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 250.w,
              minHeight: 40.h,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.only(
                    top: 10.w,
                    bottom: 10.w,
                    left: 10.w,
                    right: 10.w,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryElement,
                    borderRadius: BorderRadius.circular(5.w),
                  ),
                  child: item.type == "text"
                      ? Text(
                          item.content ?? "--",
                          style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.primaryElementText),
                        )
                      : ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: 90.w,
                          ),
                          child: GestureDetector(
                            onTap: () {},
                            child: CachedNetworkImage(
                              imageUrl: url,
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
