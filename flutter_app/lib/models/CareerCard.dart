class CareerCard {
  final String? title, total;
  final int? partialNum;

  CareerCard({
    this.title,
    this.total,
    this.partialNum,
  });
}

List demoCareerCards = [
  CareerCard(
    title: "Your GPA",
    total: "30",
    partialNum: 24,
  ),
  CareerCard(
    title: "Your Credits",
    total: "180",
    partialNum: 66,
  ),
  CareerCard(
    title: "Done Exams",
    total: "12",
    partialNum: 30,
  ),
  CareerCard(
    title: "Remaining Exams",
    total: "18",
    partialNum: 30,
  ),
];
