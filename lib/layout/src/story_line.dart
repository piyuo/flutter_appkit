import 'package:flutter/material.dart';
import 'package:libcli/delta/delta.dart' as delta;

typedef StoryBuilder = Widget Function(BuildContext context, Story story);

double firstItemSpace = 50;

class StoryLineProvider with ChangeNotifier {
  StoryLineProvider();
}

class Story {
  Story({
    required this.utcDate,
  });

  final DateTime utcDate;
}

class StoryLine extends StatelessWidget {
  const StoryLine({
    required this.stories,
    required this.builder,
    required this.title,
    this.subtitle = '',
    this.height = 300,
    Key? key,
  }) : super(key: key);

  /// title is story line title
  final String title;

  /// title is story line subtitle
  final String subtitle;

  /// height is the story line total height
  final double height;

  /// stories keep list of story
  final List<Story> stories;

  final StoryBuilder builder;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(firstItemSpace, 20, 0, 20),
            child: Row(children: [
              Text(title,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[900],
                  )),
              const SizedBox(width: 20),
              Text(subtitle,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  )),
            ]),
          ),
          Expanded(
            child: delta.RefreshMoreView(
              itemCount: stories.length,
              itemBuilder: (BuildContext context, int index) {
                final story = stories[index];
                return Card(
                  margin: EdgeInsets.only(
                    left: index == 0 ? firstItemSpace : 15,
                    bottom: 20,
                  ),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: builder(context, story),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class SimpleStory extends Story {
  SimpleStory({
    required DateTime utcDate,
    this.color = Colors.black,
    this.icon,
    required this.text,
    this.title,
  }) : super(utcDate: utcDate);

  final Color color;

  final IconData? icon;

  final String text;

  final String? title;

  static Widget builder(BuildContext context, Story story) {
    return story is SimpleStory
        ? Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            width: 250,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                story.icon != null
                    ? Icon(
                        story.icon,
                        color: story.color,
                        size: 54,
                      )
                    : const SizedBox(),
                Text.rich(TextSpan(
                    text: story.text,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    children: <InlineSpan>[
                      TextSpan(
                        text: story.title != null ? ' ' + story.title! : '',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: story.color,
                        ),
                      )
                    ])),
              ],
            ),
          )
        : const SizedBox();
  }
}
