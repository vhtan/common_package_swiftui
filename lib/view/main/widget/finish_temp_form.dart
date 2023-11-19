import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:mvvm_cubit/common/widget/text_input.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/core/app_style.dart';

class FinishTempForm extends StatelessWidget {
  final ValueChanged<String> okAction;
  final _commentController = TextEditingController();

  FinishTempForm({
    super.key,
    required this.okAction,
  });

  final FocusNode _nodeTextInput = FocusNode();
  KeyboardActionsConfig _keyboardActionsConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.IOS,
      keyboardBarColor: Colors.grey[200],
      nextFocus: false,
      actions: [
        KeyboardActionsItem(
          focusNode: _nodeTextInput,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.transparent,
      body: KeyboardActions(
        tapOutsideBehavior: TapOutsideBehavior.opaqueDismiss,
        config: _keyboardActionsConfig(context),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              alignment: Alignment.center,
              child: IntrinsicHeight(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _title,
                      const SizedBox(height: 20.0),
                      Expanded(
                        child: TextInput(
                          maxLines: 4,
                          focusNode: _nodeTextInput,
                          hint: 'Nhập ghi chú',
                          labelText: 'Nhập ghi chú',
                          controller: _commentController,
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        children: [
                          Expanded(
                              child: TextButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  side:
                                      const BorderSide(color: AppColors.border),
                                  borderRadius: BorderRadius.circular(
                                      Dimension.radiusDefault),
                                ),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Không',
                              style: textDefault,
                            ),
                          )),
                          const SizedBox(width: 20),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(Dimension
                                      .radiusDefault), // Set the desired border radius
                                ),
                                backgroundColor: AppColors.primary,
                              ),
                              onPressed: () {
                                okAction(_commentController.text);
                                Navigator.pop(context, _commentController.text);
                              },
                              child: const Text(
                                'Có',
                                style: menuTextStyle,
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget get _title {
    return const Align(
      alignment: Alignment.center,
      child: Text(
        'Hoàn thành phiếu yêu cầu',
        style: headLine1,
      ),
    );
  }
}
