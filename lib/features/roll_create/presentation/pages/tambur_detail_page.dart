import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tambur_create/core/theme/app_colors.dart';
import 'package:tambur_create/core/ui/dialog_utils.dart';
import 'package:tambur_create/features/roll_create/data/model/list_tambur_model.dart';
import 'package:tambur_create/features/roll_create/domain/entities/brand_entity.dart';
import 'package:tambur_create/features/roll_create/presentation/manager/otk_bloc.dart';
import 'package:tambur_create/features/roll_create/presentation/widgets/textfiled_widget.dart';

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

class TamburDetailView extends StatefulWidget {
  final Tambur tambur;

  const TamburDetailView({super.key, required this.tambur});

  @override
  State<TamburDetailView> createState() => _TamburDetailViewState();
}

class _TamburDetailViewState extends State<TamburDetailView> {
  final TextEditingController numberController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController shiftController = TextEditingController();
  final TextEditingController radiusController = TextEditingController();
  final TextEditingController formatController = TextEditingController();
  int? selectedBrandId;

  @override
  void initState() {
    super.initState();
    _initControllers();
    _fetchBrandsIfNeeded();
  }

  void _initControllers() {
    numberController.text = widget.tambur.tamburNumber ?? '-';
    dateController.text = widget.tambur.createdAt != null
        ? '${widget.tambur.createdAt!.day} ${_getMonthName(widget.tambur.createdAt!.month)} '
              '${widget.tambur.createdAt!.hour}:${widget.tambur.createdAt!.minute}'
        : '-';
    formatController.text = '4250';
    selectedBrandId = widget.tambur.brand;
  }

  void _fetchBrandsIfNeeded() {
    final otkState = context.read<OtkBloc>().state;
    if (otkState is OtkSuccess && otkState.brands == null) {
      context.read<OtkBloc>().add(const GetBrandsEvent());
    } else if (otkState is! OtkSuccess) {
      context.read<OtkBloc>().add(const GetBrandsEvent());
    }
  }

  void _showBrandPicker(BuildContext context, List<BrandEntity> brands) {
    if (brands.isEmpty) {
      DialogUtils.showErrorToast("Список брендов пуст или еще загружается");
      return;
    }

    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 350,
          padding: const EdgeInsets.only(top: 6.0),
          color: CupertinoColors.systemBackground.resolveFrom(context),
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: CupertinoColors.systemGrey5,
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: const Text('Отмена', style: TextStyle(color: CupertinoColors.systemRed)),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Text(
                        'Выберите бренд',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: const Text('Готово', style: TextStyle(color: CupertinoColors.activeBlue)),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: brands.length,
                    itemBuilder: (context, index) {
                      final brand = brands[index];
                      final isSelected = brand.id == selectedBrandId;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedBrandId = brand.id; 
                          });
                          Navigator.pop(context);
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: CupertinoColors.systemGrey6,
                                width: 0.5,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                brand.title,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                  color: isSelected ? AppColors.blue : Colors.black,
                                ),
                              ),
                              if (isSelected)
                                const Icon(
                                  CupertinoIcons.check_mark,
                                  color: AppColors.blue,
                                  size: 20,
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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

              /// Выбор бренда
              BlocBuilder<OtkBloc, OtkState>(
                builder: (context, state) {
                  List<BrandEntity> brands = [];
                  if (state is OtkSuccess && state.brands != null) {
                    brands = state.brands!;
                  }

                  final selectedBrand = brands.firstWhere(
                    (b) => b.id == selectedBrandId,
                    orElse: () => const BrandEntity(id: -1, title: ''),
                  );
                  final brandText = selectedBrand.id != -1 ? selectedBrand.title : 'Выберите бренд';

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Бренд",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 6),
                      GestureDetector(
                        onTap: () => _showBrandPicker(context, brands),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  brandText,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: selectedBrand.id != -1
                                        ? Colors.black
                                        : CupertinoColors.placeholderText,
                                  ),
                                ),
                              ),
                              const Icon(
                                CupertinoIcons.chevron_down,
                                color: CupertinoColors.systemGrey,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
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

                      if (shift.isEmpty || radius <= 0 || format <= 0 || selectedBrandId == null) {
                        DialogUtils.showErrorToast(
                          'Please fill all fields with valid values, including the brand selection',
                        );
                        return;
                      }

                      context.read<OtkBloc>().add(
                        UpdateTamburEvent(
                          tamburId: widget.tambur.id!,
                          shift: shift,
                          radius: radius,
                          format: format,
                          brand: selectedBrandId,
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
