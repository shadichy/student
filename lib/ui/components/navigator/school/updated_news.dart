import 'package:flutter/material.dart';
import 'package:student/ui/components/option.dart';
import 'package:student/ui/components/section_label.dart';

class URL {
  final String url;
  const URL(this.url);
}

class UpdatedNews extends StatefulWidget {
  final List<URL> news;
  const UpdatedNews(this.news, {super.key});

  @override
  State<UpdatedNews> createState() => _UpdatedNewsState();
}

class _UpdatedNewsState extends State<UpdatedNews> {
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        SectionLabel(
          "Tài liệu mới cập nhật",
          Option(Icons.arrow_forward, "", () {}),
          fontWeight: FontWeight.w900,
          fontSize: 20,
          color: colorScheme.onSecondaryContainer,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          // padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Card.outlined(
                    margin: const EdgeInsets.all(16),
                    // shape: RoundedRectangleBorder(
                    //   borderRadius: BorderRadius.circular(16),
                    // ),
                    color: colorScheme.primary.withOpacity(0.05),
                    child: InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.width * 0.56,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                "https://service.teamfuho.net/wp-content/uploads/2024/02/2024-02-10_22.06.19.jpg",
                                fit: BoxFit.cover,
                                width: MediaQuery.of(context).size.width,
                                height: 140,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              "Bao moi",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: colorScheme.onSecondaryContainer,
                                fontSize: 18,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
