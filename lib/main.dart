import 'package:flutter/material.dart';
import 'data.dart';
import 'package:gradient_text/gradient_text.dart';
import 'page_indicator.dart';

void main() => runApp(
      MaterialApp(
        home: MyApp(),
        debugShowCheckedModeBanner: false,
      ),
    );

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with TickerProviderStateMixin {
  PageController _controller;
  AnimationController animationController;
  Animation<double> _scaleAnim;
  int currentPage = 0;
  bool lastPage = false;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: currentPage);
    animationController =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    _scaleAnim = Tween(begin: 0.6, end: 1.0).animate(animationController);
  }

  @override
  void dispose() {
    _controller.dispose();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF485563),
            Color(0xFF29323C),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          tileMode: TileMode.clamp,
          stops: [
            0.0,
            1.0,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            PageView.builder(
              itemCount: pageList.length,
              controller: _controller,
              onPageChanged: (index) {
                setState(() {
                  currentPage = index;
                  if (currentPage == pageList.length - 1) {
                    lastPage = true;
                    animationController.forward();
                  } else {
                    lastPage = false;
                  }
                });
              },
              itemBuilder: (context, index) {
                return Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        var page = pageList[index];
                        var delta;
                        var y = 1.0;

                        if (_controller.position.haveDimensions) {
                          delta = _controller.page - index;
                          y = 1 - delta.abs().clamp(0.0, 1.0);
                        }

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Image.asset(
                              page.imageUrl,
                            ),
                            Container(
                              height: 100.0,
                              margin: EdgeInsets.only(
                                left: 12.0,
                              ),
                              child: Stack(
                                children: <Widget>[
                                  Opacity(
                                    opacity: .10,
                                    child: GradientText(
                                      page.title,
                                      gradient: LinearGradient(
                                        colors: page.titleGradient,
                                      ),
                                      style: TextStyle(
                                        fontSize: 100.0,
                                        fontFamily: 'Montserrat-Black',
                                        letterSpacing: 1.0,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 30.0,
                                      left: 22.0,
                                    ),
                                    child: GradientText(
                                      page.title,
                                      gradient: LinearGradient(
                                        colors: page.titleGradient,
                                      ),
                                      style: TextStyle(
                                        fontSize: 70,
                                        fontFamily: 'Montserrat-Black',
                                        letterSpacing: 1.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: 12.0,
                                left: 34.0,
                              ),
                              child: Transform(
                                transform: Matrix4.translationValues(
                                  0.0,
                                  50.0 * (1 - y),
                                  0.0,
                                ),
                                child: Text(
                                  page.body,
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontFamily: 'Montserrat-Medium',
                                    color: Color(0xFF9B9B9B),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                );
              },
            ),
            Positioned(
              left: 30.0,
              bottom: 55.0,
              child: Container(
                width: 160.0,
                child: PageIndicator(currentPage, pageList.length),
              ),
            ),
            Positioned(
              right: 30.0,
              bottom: 30.0,
              child: ScaleTransition(
                scale: _scaleAnim,
                child: lastPage
                    ? FloatingActionButton(
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.black,
                        ),
                        onPressed: () {},
                      )
                    : Container(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
