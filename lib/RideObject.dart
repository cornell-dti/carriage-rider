class RideObject {
  String fromLocation;
  String toLocation;
  String startDate;
  String endDate;
  String pickUpTime;
  String dropOffTime;
  String every;
  bool recurring;
  List<int> recurringDays;
  bool deleted;

  RideObject(
      {this.fromLocation,
      this.toLocation,
      this.startDate,
      this.endDate,
      this.pickUpTime,
      this.dropOffTime,
      this.every,
      this.recurring,
      this.recurringDays,
      this.deleted});
}
