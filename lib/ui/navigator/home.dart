import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:flutter/material.dart';
import 'package:student/misc/parser.dart';
import 'package:student/ui/components/navigator/home/glance_widget.dart';
import 'package:student/ui/components/navigator/home/upcoming_event_widget.dart';
import 'package:student/ui/components/navigator/home/notification.dart';
import 'package:student/ui/components/navigator/home/notification_widget.dart';
import 'package:student/ui/components/navigator/home/topbar_widget.dart';
import 'package:student/ui/components/navigator/navigator.dart';
import 'package:student/ui/components/navigator/quick_navigators.dart';
import 'package:student/ui/components/with_appbar.dart';

class HomePage extends StatelessWidget implements TypicalPage {
  HomePage({super.key});

  final List<Notif> notifs = [
    Notif("title", content: """
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc vel felis diam. Nam at tincidunt magna. Donec imperdiet mauris eget venenatis tempor. Donec suscipit feugiat vulputate. Etiam arcu purus, gravida at commodo volutpat, pulvinar ac elit. Etiam pharetra lorem eget magna imperdiet, eget efficitur risus venenatis. Aliquam ex elit, tincidunt ut nisl at, facilisis consectetur ante. Ut elementum sem sit amet metus imperdiet tempus. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris ultricies est vel nibh venenatis condimentum. Sed non mattis est. Quisque consequat, odio eget feugiat lobortis, magna libero rutrum dui, id mollis quam enim ut dui. Fusce rhoncus fermentum dui vitae tincidunt. Nulla condimentum odio in tortor accumsan, ut eleifend ligula pretium. Sed elementum gravida dictum. Fusce commodo ante eu sem congue maximus.

Donec nec laoreet quam, vitae fringilla est. Proin feugiat elementum dictum. Mauris ac mollis arcu. Aenean aliquam, ante at elementum pellentesque, nulla lectus pellentesque libero, quis finibus nulla est non diam. Sed ut mauris vitae ipsum commodo semper at in lectus. Vestibulum tincidunt turpis vitae tempus tincidunt. Maecenas non viverra est. Etiam ut felis pellentesque, cursus diam et, vestibulum neque.

Mauris sit amet sapien neque. Aenean dolor justo, dictum sit amet velit at, accumsan ultrices libero. Donec nec dapibus neque. Pellentesque eget finibus nibh, sit amet posuere nisl. Pellentesque justo mi, gravida interdum dignissim nec, semper sed felis. Donec in lacus et odio pharetra maximus. Curabitur quam mauris, pharetra et arcu nec, interdum imperdiet velit. Donec hendrerit dui sed consequat elementum. Vivamus vitae nunc mi. Phasellus viverra nulla nec tempus bibendum. Sed facilisis pulvinar justo, eu rutrum ante dictum a. Donec porta at ex ut sollicitudin. Nulla facilisi. Ut venenatis nulla eu tortor tempor accumsan a quis lectus. Donec et nulla in diam pellentesque posuere in a erat. Phasellus odio arcu, tincidunt in eros nec, luctus tincidunt augue.

Praesent iaculis gravida egestas. Etiam gravida erat a est tempor, sit amet tempus urna cursus. Suspendisse tellus mauris, convallis tempus hendrerit id, scelerisque dignissim mauris. Quisque at mattis ipsum. Fusce in lorem non justo venenatis vulputate sed sit amet justo. Mauris consectetur augue quis nibh vulputate consequat. In laoreet pellentesque ligula sed mollis. Nam finibus elementum arcu interdum gravida.

Vestibulum sed dignissim odio. Praesent et lobortis nisi, in tincidunt orci. In scelerisque nisl turpis, et cursus metus sagittis vitae. Suspendisse nec libero sit amet tortor luctus ultricies non eu diam. Vestibulum euismod ex vitae egestas lacinia. Cras tincidunt libero augue, quis efficitur nisi ultrices nec. Proin sit amet cursus arcu. In venenatis turpis eu fringilla blandit. Pellentesque id convallis augue. Pellentesque eu aliquet nulla. Aliquam erat volutpat. Fusce et auctor tellus.
    """),
  ];

  late final bool hasNotif = notifs.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    // ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;

    return WithAppbar(
      height: 80,
      appBar: const HomeTopBar(),
      body: [
        const HomeGlance(),
        // OptionIconWidgets([
        //   Options.settings,
        //   Options.user,
        //   Options.timetable,
        //   Options.help,
        //   Options.search,
        // ]),
        if (hasNotif) HomeNotifWidget(notifs),
        HomeNextupClassWidget(SampleTimetableData.from2dList([])),
        const OptionLabelWidgets([
          "settings",
          "program",
          "learning_result",
          "finance",
          "help",
        ]),
        const Divider(
          color: Colors.transparent,
          height: 16,
        ),
        Text(
          "You've reached the end\nHave a nice day!",
          maxLines: 2,
          style: textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const Divider(
          color: Colors.transparent,
          height: 16,
        ),
      ],
    );
  }

  @override
  Icon get icon => const Icon(Symbols.home);

  @override
  String get title => "Home";
}
