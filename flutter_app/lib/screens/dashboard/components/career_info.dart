import 'package:flutter/material.dart';

import 'package:flutter_app/constants.dart';
import 'package:flutter_app/screens/dashboard/components/career_cards.dart';
import 'package:flutter_app/models/CareerCard.dart';

class CareerInfo extends StatefulWidget {
  const CareerInfo({super.key});

  @override
  State<CareerInfo> createState() => _CareerInfoState();
}

class _CareerInfoState extends State<CareerInfo> {
  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Career Info",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        const SizedBox(height: defaultPadding),
        FileInfoCardGridView(
          childAspectRatio: _size.width < 1400 ? 1.1 : 1.4,
        ),
      ],
    );
  }
}

class FileInfoCardGridView extends StatelessWidget {
  const FileInfoCardGridView({
    Key? key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: demoCareerCards.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: defaultPadding,
        mainAxisSpacing: defaultPadding,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) =>
          CareerCards(info: demoCareerCards[index]),
    );
  }
}
