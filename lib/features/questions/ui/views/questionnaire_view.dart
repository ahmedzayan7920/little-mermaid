import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puzzle/background.dart';
import 'package:puzzle/core/app_functions.dart';
import 'package:puzzle/core/di/di.dart';
import 'package:puzzle/features/auth/logic/auth_cubit.dart';
import 'package:puzzle/features/selection/ui/views/selection_screen.dart';

import '../../../../core/app_colors.dart';
import '../../../../generated/assets.dart';
import '../../logic/questionnaire_cubit.dart';
import '../../logic/questionnaire_state.dart';
import '../../models/question_model.dart';

class QuestionnaireView extends StatelessWidget {
  const QuestionnaireView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QuestionnaireCubit(
        questions: questionsList,
        userRepository: getIt(),
        authCubit: BlocProvider.of<AuthCubit>(context),
      ),
      child: BlocListener<QuestionnaireCubit, QuestionnaireState>(
        listener: (context, state) {
          if (state is QuestionnaireUploadingState) {
            showLoadingDialog(context);
          } else if (state is QuestionnaireUploadSuccessState) {
            Navigator.of(context).popUntil((route) => route.isFirst);
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const SelectionScreen(),
              ),
            );
          } else if (state is QuestionnaireUploadFailureState) {
            Navigator.of(context).pop();
            showSnackBar(context: context, content: state.message);
          }
        },
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: Stack(
              children: [
                CustomBackground(),
                BlocBuilder<QuestionnaireCubit, QuestionnaireState>(
                  builder: (context, state) {
                    final cubit = context.read<QuestionnaireCubit>();
                    final currentQuestion = cubit.getCurrentQuestion();

                    return SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(Assets.assetsLogo,
                                width: 100, height: 80),
                            const SizedBox(height: 16),
                            Text(
                              currentQuestion.text,
                              textAlign: TextAlign.justify,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    color: AppColors.white,
                                  ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => cubit.answerQuestion(
                                currentQuestion.id,
                                true,
                              ),
                              child: const Text('نعم'),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => cubit.answerQuestion(
                                currentQuestion.id,
                                false,
                              ),
                              child: const Text('لا'),
                            ),
                            const SizedBox(height: 16),
                            LinearProgressIndicator(
                              value: cubit.getProgress(),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
