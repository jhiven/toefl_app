import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toefl_app/domain/models/test_section_model.dart';
import 'package:toefl_app/domain/state/test_packet/test_packet_cubit.dart';
import 'package:toefl_app/domain/state/test_section/test_section_cubit.dart';
import 'package:toefl_app/domain/state/timer/timer_bloc.dart';
import 'package:toefl_app/presentation/test/screens/listening_test.dart';
import 'package:toefl_app/presentation/test/screens/reading_question.dart';
import 'package:toefl_app/presentation/test/screens/result_screen.dart';
import 'package:toefl_app/presentation/test/screens/section_direction.dart';
import 'package:toefl_app/presentation/test/screens/section_result.dart';
import 'package:toefl_app/presentation/test/screens/written_question.dart';
import 'package:toefl_app/presentation/test/widgets/test_drawer.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const TestDrawer(),
      body: MultiBlocListener(
        listeners: [
          BlocListener<TestPacketCubit, TestPacketState>(
            listener: _onChangeSection,
            listenWhen: (previous, current) =>
                previous is TestPacketAnswering &&
                current is TestPacketAnswering &&
                previous.currentSection != current.currentSection,
          ),
          BlocListener<TestSectionCubit, TestSectionState>(
            listener: _onSectionStart,
            listenWhen: (previous, current) =>
                previous.isShowInstruction != current.isShowInstruction &&
                current.isShowInstruction == false,
          ),
        ],
        child: BlocBuilder<TestPacketCubit, TestPacketState>(
          buildWhen: (previous, current) => previous != current,
          builder: (context, state) {
            switch (state) {
              case TestPacketLoading():
              case TestPacketInitial():
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case TestPacketAnswering():
                return _buildQuestionView();
              case TestPacketError():
                return Text(state.errorMsg);
              case TestPacketDone():
                return ResultPage(
                  listeningScore: state.listeningScore,
                  readingScore: state.readingScore,
                  structureScore: state.structureScore,
                  totalScore: state.totalScore,
                );
            }
          },
        ),
      ),
    );
  }

  Widget _buildQuestionView() {
    return BlocConsumer<TestSectionCubit, TestSectionState>(
      listener: (context, state) {
        context.read<TestPacketCubit>().calculateSectionScore(
              sectionType: state.section.sectionType,
              totalCorrect: state.totalCorrect,
            );
        context.read<TimerBloc>().add(const TimerStop());
      },
      listenWhen: (previous, current) =>
          previous.status == TestSectionStatus.success &&
          current.status == TestSectionStatus.done,
      builder: (context, state) {
        switch (state.status) {
          case TestSectionStatus.initial:
            return const Center(
              child: CircularProgressIndicator(),
            );
          case TestSectionStatus.success:
            if (state.isShowInstruction) {
              return SectionDirection(
                sectionType: state.section.sectionType,
              );
            } else {
              switch (state.section.sectionType) {
                case SectionType.listening:
                  return const ListeningTest();
                case SectionType.structure:
                  return const WrittenQuestion();
                case SectionType.reading:
                  return const ReadingQuestion();
                default:
                  return const SizedBox();
              }
            }
          case TestSectionStatus.done:
            return const SectionResult();
        }
      },
    );
  }

  void _onChangeSection(BuildContext context, TestPacketState state) {
    state as TestPacketAnswering;
    context.read<TestSectionCubit>().setTestSection(
          section: state.currentSection,
        );
  }

  void _onSectionStart(BuildContext context, TestSectionState state) {
    final packetState = context.read<TestPacketCubit>().state;

    switch (packetState) {
      case TestPacketAnswering():
        switch (state.section.sectionType) {
          case SectionType.listening:
            context
                .read<TimerBloc>()
                .add(const TimerStarted(duration: Duration(hours: 1)));
          case SectionType.structure:
            context
                .read<TimerBloc>()
                .add(const TimerStarted(duration: Duration(hours: 1)));
          case SectionType.reading:
            context
                .read<TimerBloc>()
                .add(const TimerStarted(duration: Duration(hours: 1)));
          default:
            break;
        }
      default:
        break;
    }
  }
}
