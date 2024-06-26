import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toefl_app/domain/models/material.dart';
import 'package:toefl_app/domain/state/answer_cubit.dart';
import 'package:toefl_app/domain/state/button_next_cubit.dart';
import 'package:toefl_app/domain/state/example_question/example_question_cubit.dart';
import 'package:toefl_app/domain/state/material/material_cubit.dart';
import 'package:toefl_app/presentation/learn/widget/bottom_backgorund.dart';
import 'package:toefl_app/presentation/learn/widget/button_next.dart';
import 'package:toefl_app/presentation/learn/widget/button_test.dart';
import 'package:toefl_app/presentation/learn/pages/question.dart';

class ContentPage extends StatelessWidget {
  const ContentPage({super.key, required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MaterialModulCubit, MaterialModulState>(
      builder: (context, state) {
        String? content;
        String? title;
        int? id;
        List<MaterialModel>? data;
        if (state is MaterialLoaded) {
          data = state.data;
          title = state.data[index].title;
          content = state.data[index].content;
          id = state.data[index].id;
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(title!),
            centerTitle: true,
            forceMaterialTransparency: true,
          ),
          body: Stack(
            children: [
              SizedBox(
                height: double.infinity,
                child: SingleChildScrollView(
                  child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 150),
                      child: Text(content!)),
                ),
              ),
              BottomBackground(
                butoon1: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            QuestionScreen(index: index, length: data!.length),
                      ),
                    );
                    context.read<ButtonNextCubit>().changeButton(false);
                    context.read<AnswerCubit>().resetAnswer();
                    context.read<ExampleQuestionCubit>().showQuestion(id!);
                  },
                  child: const ButtonTest(),
                ),
                button2: index + 1 < data!.length
                    ? InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ContentPage(index: index + 1),
                              ));
                        },
                        child: const ButtonNext(
                          next: true,
                        ),
                      )
                    : Container(),
              ),
            ],
          ),
        );
      },
    );
  }
}
