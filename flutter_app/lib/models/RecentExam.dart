class RecentExam {
  final String? name, date, credits, vote;

  RecentExam({this.name, this.date, this.credits, this.vote});
}

List demoRecentExams = [
  RecentExam(
    name: "Programmazione e laboratorio",
    date: "19/06/2023",
    credits: "6",
    vote: "30",
  ),
  RecentExam(
    name: "Introduzione alla programmazione",
    date: "01/06/2023",
    credits: "6",
    vote: "24",
  ),
  RecentExam(
    name: "Architettura degli elaboratori",
    date: "23/01/2023",
    credits: "12",
    vote: "29",
  ),
  RecentExam(
    name: "Calcolo 1",
    date: "27/01/2023",
    credits: "6",
    vote: "30",
  ),
  RecentExam(
    name: "Calcolo 2",
    date: "10/09/2022",
    credits: "6",
    vote: "24",
  ),
  RecentExam(
    name: "Probabilità e Statistica",
    date: "23/01/2022",
    credits: "12",
    vote: "18",
  ),
];
