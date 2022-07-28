class SlotInfoDTO {
  final String id;
  final DateTime start;
  final DateTime end;
  final int freeSpots;

  const SlotInfoDTO(
      {required this.id,
      required this.start,
      required this.end,
      required this.freeSpots});

  factory SlotInfoDTO.fromJson(Map<String, dynamic> json) {
    return SlotInfoDTO(
      id: json["id"],
      start: DateTime.parse(json["start"]),
      end: DateTime.parse(json["end"]),
      freeSpots: json["freeSpots"],
    );
  }
}
