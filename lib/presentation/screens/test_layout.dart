import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toefl_app/domain/state/test_packet/test_packet_cubit.dart';
import 'package:toefl_app/domain/state/test_section/test_section_cubit.dart';
import 'package:toefl_app/presentation/screens/home_page.dart';
import 'package:toefl_app/presentation/widgets/primary_button.dart';

class TestLayout extends StatelessWidget {
  const TestLayout({
    super.key,
    required this.child,
    this.buttonText,
  });

  final Widget child;
  final String? buttonText;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Expanded(
              child: child,
            ),
            const SizedBox(
              height: 12,
            ),
            PrimaryButton(
              onPressed: () {
                final sectionCubit = context.read<TestSectionCubit>();
                final packetCubit = context.read<TestPacketCubit>();

                switch (packetCubit.state) {
                  case TestPacketAnswering():
                    switch (sectionCubit.state.status) {
                      case TestSectionStatus.initial:
                        break;
                      case TestSectionStatus.success:
                        if (sectionCubit.state.isShowInstruction) {
                          sectionCubit.startSection();
                        } else {
                          sectionCubit.checkAnswer();
                          sectionCubit.nextQuestion();
                        }
                      case TestSectionStatus.done:
                        packetCubit.nextSection();
                    }
                  case TestPacketDone():
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      ),
                    );
                  default:
                    break;
                }
              },
              icon: null,
              text: buttonText ?? "Next",
            )
          ],
        ),
      ),
    );
  }
}