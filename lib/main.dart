import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.select): const ActivateIntent(),
      },
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('fa', ''),
          // Locale('en', ''),
        ],
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        cacheExtent: 1000,
        // controller: _scrollController,
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate(
              [
                HorizontalList(),
                HorizontalList(),
                HorizontalList(),
                HorizontalList(),
                HorizontalList(),
                HorizontalList(),
                HorizontalList(),
                HorizontalList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HorizontalList extends StatelessWidget {
  final int _itemsCount = 9;
  final AutoScrollController controller = AutoScrollController(
      //add this for advanced viewport boundary. e.g. SafeArea
      viewportBoundaryGetter: () => const Rect.fromLTRB(0, 0, 0, 0),
      //choose vertical/horizontal
      axis: Axis.horizontal,
      //this given value will bring the scroll offset to the nearest position in fixed row height case.
      //for variable row height case, you can still set the average height, it will try to get to the relatively closer offset
      //and then start searching.
      suggestedRowHeight: 200);

  HorizontalList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        itemCount: _itemsCount + 1,
        //+1 for moreBtn
        scrollDirection: Axis.horizontal,
        controller: controller,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        itemBuilder: (context, index) {
          if (index == _itemsCount) {
            return const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MoreBtn(),
              ],
            );
          } else {
            return AutoScrollTag(
              key: ValueKey(index),
              controller: controller,
              index: index,
              child: Child(controller, index),
            );
          }
        },
      ),
    );
  }
}

class Child extends StatefulWidget {
  final int index;
  final AutoScrollController controller;

  const Child(this.controller, this.index, {super.key});

  @override
  State<Child> createState() => _ChildState();
}

class _ChildState extends State<Child> {
  final FocusNode focusNode = FocusNode();

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        debugPrint("Index of item with focus is: ${widget.index} ");
        widget.controller.scrollToIndex(widget.index,
            preferPosition: AutoScrollPosition.middle);
      }
    });
    return InkWell(
      onTap: () {},
      focusNode: focusNode,
      focusColor: Colors.purple,
      child: Container(
        margin: const EdgeInsets.all(10),
        width: 100,
        height: 100,
        color: Colors.cyanAccent,
        child: Text('${widget.index}'),
      ),
    );
  }
}

class MoreBtn extends StatelessWidget {
  const MoreBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        print('press');
      },
      style: ButtonStyle(
        side: MaterialStateProperty.resolveWith<BorderSide?>((state) {
          if (state.contains(MaterialState.focused)) {
            return const BorderSide(color: Colors.white, width: 3);
          }
          return null;
        }),
      ),
      child: Focus(
          onKey: (FocusNode node, RawKeyEvent event) {
            print(event.logicalKey);
            if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
              print('me');
              return KeyEventResult.handled;
            }
            print('and me');
            return KeyEventResult.ignored;
          },
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'ShowMore',
              ),
            ],
          )),
    );
  }
}
