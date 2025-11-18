import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tambur_create/core/theme/app_colors.dart';
import 'package:tambur_create/features/otk/presentation/pages/tambur_detail_page.dart';
import 'package:tambur_create/features/otk/presentation/widgets/roll_widget.dart';
import 'package:tambur_create/features/otk/presentation/widgets/tambur_widget.dart';
import '../manager/otk_bloc.dart';
import '../widgets/logout_dialog.dart';

class OtkFormPage extends StatefulWidget {
  const OtkFormPage({super.key});

  @override
  State<OtkFormPage> createState() => _OtkFormPageState();
}

class _OtkFormPageState extends State<OtkFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    context.read<OtkBloc>().add(const GetListTamburEvent());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      child: BlocBuilder<OtkBloc, OtkState>(
        builder: (context, state) {
          if (state is OtkLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CupertinoActivityIndicator(
                    color: AppColors.primary,
                    radius: 20.r,
                  ),
                  SizedBox(height: 16.r),
                  Text(
                    'Загрузка...',
                    style: TextStyle(
                      color: CupertinoColors.systemGrey,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is OtkFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.exclamationmark_triangle,
                    size: 64.r,
                    color: CupertinoColors.systemRed,
                  ),
                  SizedBox(height: 16.r),
                  Text(
                    'Ошибка',
                    style: TextStyle(
                      color: CupertinoColors.systemRed,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8.r),
                  Text(
                    state.error,
                    style: TextStyle(
                      color: CupertinoColors.systemGrey,
                      fontSize: 14.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          if (state is OtkSuccess) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: MediaQuery.of(context).padding.top),
                    Row(
                      children: [
                        const Spacer(flex: 6),

                        const Column(
                          children: [
                            Image(
                              image: AssetImage(
                                'assets/image/profpack_logo.png',
                              ),
                              width: 130,
                            ),
                          ],
                        ),
                        const Spacer(flex: 4),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: () => LogoutDialog.show(context),
                              child: Icon(
                                CupertinoIcons.square_arrow_right,
                                color: AppColors.primary,
                                size: 22.r,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          // Trigger refresh by dispatching the initial load event with current filters
                          context.read<OtkBloc>().add(
                            const GetListTamburEvent(),
                          );
                        },
                        child: state.listTambur.results!.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const RollCard(
                                      leftImagePath:
                                          "assets/icon/lf.png", // chapdagi siz aytgan rasm
                                      tambur: "1120",
                                      rValue: "140см",
                                      time: "31:10",
                                      formatValue: "4250",
                                    ),

                                    Icon(
                                      CupertinoIcons.search,
                                      size: 64.r,
                                      color: CupertinoColors.systemGrey,
                                    ),
                                    SizedBox(height: 16.r),
                                    Text(
                                      'Товар не найден',
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        color: CupertinoColors.systemGrey,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 8.r),
                                    Text(
                                      'Попробуйте изменить параметры поиска',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: CupertinoColors.systemGrey2,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),

                                    CupertinoButton(
                                      onPressed: () {
                                        context.read<OtkBloc>().add(
                                          const GetListTamburEvent(),
                                        );
                                      },
                                      child: const Text('Обновить'),
                                    ),
                                  ],
                                ),
                              )
                            : Stack(
                                children: [
                                  ListView.builder(
                                    itemCount: state.listTambur.results!.length,
                                    padding: EdgeInsets.only(bottom: 100.r),
                                    itemBuilder: (context, index) {
                                      final item =
                                          state.listTambur.results![index];
                                      return TamburWidget(
                                        item: item,
                                        onTap: () {
                                          Navigator.of(context)
                                              .push(
                                                TamburDetailPage.route(item),
                                              )
                                              .then((value) {
                                                context.read<OtkBloc>().add(
                                                  const GetListTamburEvent(),
                                                );
                                              });
                                        },
                                      );
                                    },
                                  ),
                                  Positioned(
                                    bottom:
                                        MediaQuery.of(context).padding.bottom +
                                        5,
                                    left: 0,
                                    right: 0,
                                    child: CupertinoButton(
                                      padding: EdgeInsets.zero,
                                      color: AppColors.green,
                                      onPressed: () {
                                        context.read<OtkBloc>().add(
                                          CreateTamburEvent(
                                            onSuccess: (tambur) {
                                              Navigator.of(context)
                                                  .push(
                                                    TamburDetailPage.route(
                                                      tambur,
                                                    ),
                                                  )
                                                  .then((value) {
                                                    if (mounted) {
                                                      context.read<OtkBloc>().add(
                                                        const GetListTamburEvent(),
                                                      );
                                                    }
                                                  });
                                            },
                                            onError: (String error) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(content: Text(error)),
                                              );
                                            },
                                          ),
                                        );
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
                  ],
                ),
              ),
            );
          }

          return SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.cube_box,
                    size: 64.r,
                    color: CupertinoColors.systemGrey,
                  ),
                  SizedBox(height: 16.r),
                  Text(
                    'Товары не найдены',
                    style: TextStyle(
                      color: CupertinoColors.systemGrey,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'draft':
        return CupertinoColors.systemOrange;
      case 'completed':
        return CupertinoColors.systemGreen;
      case 'cancelled':
        return CupertinoColors.systemRed;
      default:
        return CupertinoColors.systemGrey;
    }
  }
}
