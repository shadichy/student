import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:student/core/routing.dart';
import 'package:student/ui/components/section_label.dart';

class URL {
  final String url;
  final String label;
  const URL(this.label, this.url);
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
    TextTheme textTheme = Theme.of(context).textTheme;
    List<Widget> mainContent = List.generate(widget.news.length, (i) {
      URL u = widget.news[i];
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Card.outlined(
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
                      u.url,
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width,
                      height: 140,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    u.label,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleMedium?.apply(
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
    return Column(
      children: [
        SectionLabel(
          "Tài liệu mới cập nhật", // change to "Bài viết mới"
          icon: const Icon(Symbols.arrow_forward),
          target: () => Routing.goto(context, Routing.papers),
          // fontWeight: FontWeight.w300,
          textStyle:
              textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
          color: colorScheme.onPrimaryContainer,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width * 0.56 + 64,
          // padding: const EdgeInsets.symmetric(horizontal: 16),
          // child: SingleChildScrollView(
          //   scrollDirection: Axis.horizontal,
          //   child: Row(children: mainContent),
          // ),
          child: ScrollSnapList(
            itemBuilder: (context, index) => mainContent[index],
            itemCount: mainContent.length,
            itemSize: MediaQuery.of(context).size.width,
            onItemFocus: (_) {},
            padding: const EdgeInsets.symmetric(vertical: 16),
            shrinkWrap: true,
            duration: 300,
            curve: Curves.easeInOut,
          ),
        )
      ],
    );
  }
}
