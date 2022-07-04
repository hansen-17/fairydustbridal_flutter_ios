import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/size_util.dart';
import '../home_viewmodel.dart';

enum CategoryType { PRODUCT, SERVICE }

class Category {
  String id;
  String title;
  CategoryType type;
  ImageProvider image;
  int totalItems;

  Category({required this.id, required this.title, required this.type, required this.image, required this.totalItems});
}

class CategoryCard extends StatelessWidget {
  final HomeViewModel homeViewModel = Get.find<HomeViewModel>();

  final Category category;
  CategoryCard(this.category);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => homeViewModel.setItemId(category.id),
      child: Column(
        children: [
          SizedBox(height: 1.h),
          Card(
            child: Container(
              width: 100.w,
              height: 20.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(1.h),
                image: DecorationImage(
                  image: category.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            elevation: 0.5.h,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1.h)),
          ),
          SizedBox(height: 1.h),
          Text(
            category.title,
            style: TextStyle(
              fontFamily: "Niconne",
              fontSize: 22.sp,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            "${category.totalItems} Results",
            style: TextStyle(
              fontSize: 12.sp,
            ),
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }
}

class ListCategoryWidget extends StatelessWidget {
  final List<Category> categories = <Category>[
    Category(id: "1a", title: "Gaun dan Jas", type: CategoryType.PRODUCT, image: Image.asset("assets/images/category1a.jpg").image, totalItems: 203),
    Category(id: "1b", title: "Make Up", type: CategoryType.SERVICE, image: Image.asset("assets/images/category1b.jpg").image, totalItems: 10),
    Category(id: "1c", title: "Fotografi", type: CategoryType.SERVICE, image: Image.asset("assets/images/category1c.png").image, totalItems: 8),
    Category(id: "1d", title: "Lain-lain", type: CategoryType.SERVICE, image: Image.asset("assets/images/category1d.jpg").image, totalItems: 75),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) => CategoryCard(categories[index]),
      itemCount: 4,
      padding: EdgeInsets.symmetric(horizontal: 5.w),
    );
  }
}
