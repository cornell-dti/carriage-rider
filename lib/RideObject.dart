class RideObject {
  String fromLocation;
  String toLocation;
  String date;
  String pickUpTime;
  String dropOffTime;
  String every;
  bool recurring;
  List<int> recurringDays;
  bool deleted;


  RideObject(
      {this.fromLocation,
      this.toLocation,
      this.date,
      this.pickUpTime,
      this.dropOffTime,
      this.every,
      this.recurring,
      this.recurringDays,
      this.deleted});
}
