class Exam {
  final String? attivitaDidattica, appello, iscrizione, presidente, CFU;

  Exam(
      {this.attivitaDidattica,
      this.appello,
      this.iscrizione,
      this.presidente,
      this.CFU});
}

List listaAppelli = [
  Exam(
    attivitaDidattica: "Programmazione e laboratorio",
    appello: "19/06/2023",
    iscrizione: "30/05/2023-17/06/2023",
    presidente: "Marin Andrea",
    CFU: "12",
  ),
  Exam(
    attivitaDidattica: "Introduzione alla programmazione",
    appello: "12/06/2023",
    iscrizione: "24/05/2023-10/06/2023",
    presidente: "Lucchese Claudio",
    CFU: "6",
  ),
];
