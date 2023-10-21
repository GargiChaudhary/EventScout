import 'package:events/providers/app_state.dart';
import 'package:events/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/category.dart';

class CategoryWidget extends StatelessWidget {
  final Categoryy category;
  const CategoryWidget({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final isSelected = appState.selectedCategoryId == category.categoryId;

    return GestureDetector(
      onTap: () {
        if (!isSelected) {
          appState.updateCategoryId(category.categoryId);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          // boxShadow: const [
          //   BoxShadow(
          //     color: Color.fromARGB(255, 246, 139, 120),
          //     spreadRadius: 1,
          //     blurRadius: 5,
          //     offset: Offset(0, 5),
          //   )
          // ],
          border: Border.all(color: isSelected ? color1 : color3, width: 1),
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          color: isSelected ? color1 : Colors.transparent,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              category.icon,
              color: isSelected ? primaryColor : color1,
              size: 40,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(category.name,
                style: isSelected
                    ? const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 15,
                        color: primaryColor)
                    : const TextStyle(
                        fontFamily: 'Montserrat', fontSize: 15, color: color1))
          ],
        ),
      ),
    );
  }
}
