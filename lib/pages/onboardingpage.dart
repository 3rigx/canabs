import 'package:canabs/helpers/appcolors.dart';
import 'package:canabs/helpers/utils.dart';
import 'package:canabs/models/onboardingcontent.dart';
import 'package:canabs/wudgets/mainappbar.dart';
import 'package:canabs/wudgets/themebutton.dart';
import 'package:flutter/material.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final List<OnboardingContent> _content = Utils.getOnboarding();
  int pageIndex = 0;
  PageController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (int page) {
                  setState(() {
                    pageIndex = page;
                  });
                },
                children: List.generate(
                  _content.length,
                  (index) => Container(
                    padding: const EdgeInsets.all(40),
                    margin: const EdgeInsets.only(
                        left: 40, right: 40, top: 40, bottom: 20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                              color: AppColors.MAIN_COLOR.withOpacity(0.3),
                              blurRadius: 20,
                              offset: Offset.zero),
                        ]),
                    child: Column(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              const Align(
                                alignment: Alignment.topRight,
                                child: Icon(
                                  Icons.help_center,
                                  size: 40,
                                  color: AppColors.MAIN_COLOR,
                                ),
                              ),
                              Image.asset(
                                'assets/icons/icon.png',
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                _content[index].message!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: AppColors.MAIN_COLOR, fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: index == _content.length - 1,
                          child: ThemeButton(
                            onClick: () {
                              Utils.mainAppNav.currentState!
                                  .pushNamed('/mainpage');
                            },
                            label: 'Start App!',
                            color: AppColors.DARK_GREEN,
                            highlight: AppColors.DARKER_GREEN,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _content.length,
                (index) => GestureDetector(
                  onTap: () {
                    _controller!.animateTo(
                        MediaQuery.of(context).size.width * index,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut);
                  },
                  child: Container(
                    width: 20,
                    height: 20,
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.MAIN_COLOR,
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                          width: 6,
                          color: pageIndex == index
                              ? const Color(0xFFC1E09E)
                              : Theme.of(context).canvasColor),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ThemeButton(
              onClick: () {
                Utils.mainAppNav.currentState!.pushNamed('/mainpage');
              },
              label: 'Close Onboarding',
            )
          ],
        ),
      ),
    );
  }
}
