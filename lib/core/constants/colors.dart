import 'package:fluttertoast/fluttertoast.dart';
import 'package:tambur_create/core/theme/app_colors.dart';

void showToast(String text) {
  Fluttertoast.showToast(
    msg: text,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.TOP,
    timeInSecForIosWeb: 2,
    backgroundColor: AppColors.red,
    textColor: AppColors.white,
    fontSize: 16.0,
  );
}
