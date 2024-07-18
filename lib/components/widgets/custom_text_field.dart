import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:in_motion/app/constants/color_constant.dart';
import 'package:in_motion/app/constants/text_style_constants.dart';
import 'package:in_motion/app/utils/strings_util.dart';

class CustomTextField extends StatefulWidget {
  final String? title;
  final String? hintText;
  final String? labelText;
  final String? errorText;
  final bool? isTitleField;
  final TextEditingController textEditingController;
  final FocusNode focusNode;
  final TextStyle? titleStyle;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  final TextStyle? labelStyle;
  final double? borderRadius;
  final double? textFieldHeight;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final Color? borderColor;
  final Color? fillColor;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormats;
  final TextInputAction? textInputAction;
  final TextInputType? textInputType;
  final TextCapitalization? textCapitalization;
  final EdgeInsets? contentPadding;
  final bool? readOnly;
  final bool? canReadOnly;
  final bool? isRequired;
  final bool? onSecureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Function? onClick;
  final Function()? onEditComplete;
  final Function(String?)? onChange;

  const CustomTextField({
    super.key,
    this.title,
    this.isTitleField,
    required this.textEditingController,
    required this.focusNode,
    this.titleStyle,
    this.hintStyle,
    this.textStyle,
    this.borderRadius,
    this.borderColor,
    this.fillColor,
    this.validator,
    this.hintText,
    this.labelText,
    this.labelStyle,
    this.textFieldHeight,
    this.maxLines,
    this.minLines,
    this.maxLength,
    this.textInputAction,
    this.textInputType,
    this.textCapitalization,
    this.contentPadding,
    this.readOnly,
    this.canReadOnly,
    this.isRequired,
    this.suffixIcon,
    this.inputFormats,
    this.onSecureText,
    this.onClick,
    this.onChange,
    this.prefixIcon,
    this.errorText,
    this.onEditComplete,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if ((widget.isTitleField ?? false) &&
            StringUtils.isNullOrEmpty(widget.title))
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${widget.title}${(widget.isRequired ?? false) ? "*" : ""}',
                style: widget.titleStyle ??
                    CustomTextStyle.getMediumText(textSize: 14),
              ),
              SizedBox(
                height: 3.h,
              )
            ],
          ),
        SizedBox(
          height: widget.textFieldHeight,
          child: GestureDetector(
            onTap: () {
              if ((widget.readOnly ?? false) && widget.onClick != null) {
                widget.onClick!();
              }
            },
            child: TextFormField(
              controller: widget.textEditingController,
              focusNode: widget.focusNode,
              validator: widget.validator,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onChanged: widget.onChange,
              obscureText: widget.onSecureText ?? false,
              onEditingComplete: widget.onEditComplete,
              cursorColor: ColorConstants.primaryColor,
              style: CustomTextStyle.getRegularText(textSize: 14),
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.always,
                isDense: true,
                errorText: widget.errorText,
                contentPadding: widget.contentPadding ??
                    EdgeInsets.only(
                      left: 10.w,
                      right: 10.w,
                      top: 10.h,
                      bottom: 10.h,
                    ),
                hintText: widget.hintText ?? "",
                labelText: widget.labelText ?? "",
                enabled: !(widget.readOnly ?? false),
                hintStyle: widget.hintStyle ??
                    CustomTextStyle.getMediumText(
                        textSize: 14, textColor: ColorConstants.hintColor),
                labelStyle: widget.labelStyle ??
                    CustomTextStyle.getMediumText(
                        textSize: 14, textColor: ColorConstants.blackColor),
                border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(widget.borderRadius ?? 5.r),
                    borderSide: BorderSide(
                        width: 1.h,
                        color: ColorConstants.primaryColor.withOpacity(0.5))),
                errorBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(widget.borderRadius ?? 5.r),
                    borderSide: BorderSide(
                        width: 1.h, color: ColorConstants.errorColor)),
                focusedBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(widget.borderRadius ?? 5.r),
                    borderSide: BorderSide(
                        width: 2.h, color: ColorConstants.primaryColor)),
                enabledBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(widget.borderRadius ?? 5.r),
                    borderSide: BorderSide(
                        width: 1.h, color: ColorConstants.hintColor)),
                disabledBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(widget.borderRadius ?? 5.r),
                    borderSide: BorderSide(
                        width: 1.h,
                        color: ColorConstants.primaryColor.withOpacity(0.5))),
                counterText: "",
                focusedErrorBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(widget.borderRadius ?? 5.r),
                    borderSide: BorderSide(
                        width: 1.h, color: ColorConstants.errorColor)),
                errorStyle: CustomTextStyle.getRegularText(
                    textSize: 14, textColor: ColorConstants.errorColor),
                suffixIcon: widget.suffixIcon,
                prefixIcon: widget.prefixIcon,
                filled: true,
                fillColor: (widget.canReadOnly ?? false)
                    ? Colors.grey[200]
                    : widget.fillColor ?? ColorConstants.transparent,
              ),
              maxLength: widget.maxLength,
              textInputAction: widget.textInputAction ?? TextInputAction.next,
              keyboardType: widget.textInputType ?? TextInputType.text,
              textCapitalization:
                  widget.textCapitalization ?? TextCapitalization.none,
              maxLines: widget.maxLines ?? 1,
              minLines: widget.minLines ?? 1,
              inputFormatters: widget.inputFormats,
            ),
          ),
        )
      ],
    );
  }
}
