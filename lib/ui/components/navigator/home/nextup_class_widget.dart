import 'package:flutter/material.dart';
import 'package:student/misc/parser.dart';

class HomeNextupClassCards extends StatefulWidget {
  final TimetableData timetableData;
  const HomeNextupClassCards(this.timetableData, {super.key});

  @override
  State<HomeNextupClassCards> createState() => _HomeNextupClassCardsState();
}

class _HomeNextupClassCardsState extends State<HomeNextupClassCards> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      padding: const EdgeInsets.all(0),
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: Color(0x00000000),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.zero,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    "Next-up classes",
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontStyle: FontStyle.normal,
                      fontSize: 20,
                      color: Color(0xff000000),
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward,
                  color: Color(0xff212435),
                  size: 24,
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            margin: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            width: 240,
                            decoration: BoxDecoration(
                              color: const Color(0x1f000000),
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      "B704",
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 14,
                                        color: Color(0xff000000),
                                      ),
                                    ),
                                    Text(
                                      " - ",
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 14,
                                        color: Color(0xff000000),
                                      ),
                                    ),
                                    Icon(
                                      Icons.alarm,
                                      color: Color(0xff212435),
                                      size: 16,
                                    ),
                                    Text(
                                      "30m",
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 14,
                                        color: Color(0xff000000),
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  "TIENGVIETTH(THANHNHAC).1",
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 18,
                                    color: Color(0xff000000),
                                  ),
                                ),
                                Text(
                                  "TIếng Việt thực hành (Thanh Nhạc)",
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 12,
                                    color: Color(0xff000000),
                                  ),
                                ),
                                Text(
                                  "Thời gian: 14:00 - 16:00",
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 12,
                                    color: Color(0xff000000),
                                  ),
                                ),
                                Text(
                                  "GV: Nguyễn Thị Thùy Trang",
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 12,
                                    color: Color(0xff000000),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            width: 240,
                            decoration: BoxDecoration(
                              color: const Color(0x1f000000),
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      "B104",
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 14,
                                        color: Color(0xff000000),
                                      ),
                                    ),
                                    Text(
                                      " - ",
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 14,
                                        color: Color(0xff000000),
                                      ),
                                    ),
                                    Icon(
                                      Icons.alarm,
                                      color: Color(0xff212435),
                                      size: 16,
                                    ),
                                    Text(
                                      "2h30",
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 14,
                                        color: Color(0xff000000),
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  "GDTC:BONGCHUYENCB.25",
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 18,
                                    color: Color(0xff000000),
                                  ),
                                ),
                                Text(
                                  "GDTC: Bóng bàn cơ bản",
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 12,
                                    color: Color(0xff000000),
                                  ),
                                ),
                                Text(
                                  "Thời gian: 16:00 - 18:00",
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 12,
                                    color: Color(0xff000000),
                                  ),
                                ),
                                Text(
                                  "GV: Tên Giảng Viên Siêu Dài",
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 12,
                                    color: Color(0xff000000),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Icon(
                        Icons.done,
                        color: Color(0xff212435),
                        size: 32,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
