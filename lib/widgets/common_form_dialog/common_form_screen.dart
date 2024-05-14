

import 'package:flutter/material.dart';
import 'package:rentinventory/base/components/screen_utils/flutter_screenutil.dart';

import '../../base/basePageDialog.dart';
import '../../base/constants/app_colors.dart';
import '../../base/constants/app_images.dart';
import '../../base/constants/app_styles.dart';
import '../../base/widgets/button_view.dart';
import '../../base/widgets/image_view.dart';
import 'common_form_screen_bloc.dart';

class CommonFormScreen extends BasePageDialog<CommonFormScreenBloc> {
  final String formTitleText;
  final String formButtonText;
  final Widget contentWidget;
  final Function onCloseTapped;
  final Function onButtonTapped;

  const CommonFormScreen(
      {Key? key,
      required this.formTitleText,
      required this.formButtonText,
      required this.contentWidget,
      required this.onCloseTapped,
      required this.onButtonTapped})
      : super(key: key);

  @override
  BasePageDialogState<CommonFormScreen, CommonFormScreenBloc> getDialogState() {
    return _FilterScreenState();
  }

}

class _FilterScreenState
    extends BasePageDialogState<CommonFormScreen, CommonFormScreenBloc> {

  final CommonFormScreenBloc _bloc = CommonFormScreenBloc();
  bool switchValue = false;

  Widget buildTopView() {
    return Container(
      width: MediaQuery.of(context).size.width*0.65,
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        color: Colors.blueAccent
      ),
      child: Text(
        widget.formTitleText,
        style: styleSmall4.copyWith(color: white, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget buildBottomView() {
    return Container(
      width:MediaQuery.of(context).size.width*0.65,
      padding: EdgeInsetsDirectional.fromSTEB(15.w, 0, 15.w, 15.w),
      child: ButtonView( widget.formButtonText, () async {
        widget.onButtonTapped();

      }),

    );
  }

  @override
  bool isRemoveScaffold() => true;

  @override
  void onReady() {}

  @override
  CommonFormScreenBloc getBloc() {
    return _bloc;
  }

  @override
  Widget? getAppBar() {
    return null;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget buildWidget(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.fromLTRB(20.w, 20, 20.w, 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.only(left: 10.0, right: 10.0),
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12.0,right: 12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0 ,
                    offset: Offset(0.0, 10.0),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildTopView(),
                  Flexible(child: SingleChildScrollView(child: widget.contentWidget)),
                  buildBottomView()
                ],
              ),
            ),
            PositionedDirectional(
              end: 0.0,
              child: GestureDetector(
                onTap: (){
                  widget.onCloseTapped();
                  Navigator.of(context).pop();
                },
                child: const Align(
                  alignment: AlignmentDirectional.topEnd,
                  child: ImageView(image: AppImages.icClose, imageType: ImageType.svg,),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
