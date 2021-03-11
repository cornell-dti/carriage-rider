class RideObject {
  String fromLocation;
  String toLocation;
  String startDate;
  String pickUpTime;
  String dropOffTime;
  String every;
  bool recurring;
  List<int> recurringDays;
  String endDate;

  RideObject(
      {this.fromLocation,
      this.toLocation,
      this.startDate,
      this.pickUpTime,
      this.dropOffTime,
      this.every,
      this.recurring,
      this.recurringDays,
      this.endDate});
}
