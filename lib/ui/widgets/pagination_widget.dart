import 'package:flutter/material.dart';
import 'package:historical_maps/ui/commons/colors.dart';
import 'package:historical_maps/ui/commons/ui_helpers.dart';

import 'pagination_button.dart';

class PaginationWidget extends StatelessWidget {
  const PaginationWidget(
      {Key? key, required this.year, this.onBackward, this.onForward})
      : super(key: key);

  final Function? onBackward;
  final Function? onForward;
  final String year;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      // width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: UIHelper.kVerticalSpaceSmall,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: kColorDarkRed,
            boxShadow: const [
              BoxShadow(
                color: Color(0x66000000),
                offset: Offset(0, 5),
                blurRadius: 6,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PaginationButton(
                icon: Icons.arrow_back,
                onTap: onBackward,
              ),
              SizedBox(
                width: 100,
                child: Center(
                  child: Text(
                    year,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              PaginationButton(
                icon: Icons.arrow_forward,
                onTap: onForward,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
