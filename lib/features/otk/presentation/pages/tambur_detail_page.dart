import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tambur_create/core/theme/app_colors.dart';
import 'package:tambur_create/core/ui/dialog_utils.dart';
import 'package:tambur_create/features/otk/data/model/list_tambur_model.dart';
import 'package:tambur_create/features/otk/presentation/manager/otk_bloc.dart';
import 'package:tambur_create/features/otk/presentation/widgets/textfiled_widget.dart';

class TamburDetailPage extends StatelessWidget {
  final Tambur tambur;

  const TamburDetailPage({super.key, required this.tambur});

  static Route route(Tambur tambur) =>
      MaterialPageRoute(builder: (context) => TamburDetailPage(tambur: tambur));

  @override
  Widget build(BuildContext context) {
    return TamburDetailView(tambur: tambur);
  }
}

class TamburDetailView extends StatelessWidget {
  final Tambur tambur;

  TamburDetailView({super.key, required this.tambur});

  final TextEditingController numberController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController shiftController = TextEditingController();
  final TextEditingController radiusController = TextEditingController();
  final TextEditingController formatController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    numberController.text = tambur.tamburNumber ?? '-';
    dateController.text = tambur.createdAt != null
        ? '${tambur.createdAt!.day} ${_getMonthName(tambur.createdAt!.month)} '
              '${tambur.createdAt!.hour}:${tambur.createdAt!.minute}'
        : '-';

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Детали тамбура'),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Номер тамбура
              CustomRightWidgetTextField(
                label: "Номер тамбура",
                controller: numberController,
                readOnly: true,
                rightWidget: const Text("№", style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 12),

              /// Дата/Время производства
              CustomRightWidgetTextField(
                label: "Дата/Время производства",
                controller: dateController,
                readOnly: true,
                rightWidget: const SizedBox(),
                textStyle: const TextStyle(fontSize: 16, color: AppColors.blue),
              ),
              const SizedBox(height: 12),

              /// Смена (editable)
              CustomRightWidgetTextField(
                label: "Смена (1/2/3)",
                controller: shiftController,
                readOnly: false,
                onTap: () {},
                rightWidget: SvgPicture.asset("assets/icon/pencil.svg"),
              ),
              const SizedBox(height: 12),

              /// Радиус
              CustomRightWidgetTextField(
                label: "Радиус",
                controller: radiusController,
                readOnly: false,
                rightWidget: const Text("CM", style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 12),

              /// Формат тамбура (editable)
              CustomRightWidgetTextField(
                label: "Формат тамбура",
                controller: formatController,
                readOnly: false,
                onTap: () {},
                rightWidget: SvgPicture.asset("assets/icon/pencil.svg"),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  color: AppColors.green,
                  onPressed: () {
                    try {
                      final shift = shiftController.text;
                      final radius = int.tryParse(radiusController.text) ?? 0;
                      final format = int.tryParse(formatController.text) ?? 0;

                      if (shift.isEmpty || radius <= 0 || format <= 0) {
                        DialogUtils.showErrorToast(
                          'Please fill all fields with valid values',
                        );
                        return;
                      }

                      context.read<OtkBloc>().add(
                        UpdateTamburEvent(
                          tamburId: tambur.id!,
                          shift: shift,
                          radius: radius,
                          format: format,
                          onSuccess: () {
                            Navigator.pop(
                              context,
                              true,
                            ); // Return true to indicate success
                          },
                          onError: (error) {
                            DialogUtils.showErrorToast(error);
                          },
                        ),
                      );
                    } catch (e) {
                      DialogUtils.showErrorToast('An error occurred: $e');
                    }
                  },
                  child: const Text(
                    'Создать тамбур',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'янв',
      'фев',
      'мар',
      'апр',
      'май',
      'июн',
      'июл',
      'авг',
      'сен',
      'окт',
      'ноя',
      'дек',
    ];
    return months[month - 1];
  }
}
