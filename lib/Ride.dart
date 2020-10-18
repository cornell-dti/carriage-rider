class Ride {
  String fromLocation;
  String toLocation;
  String date;
  String pickUpTime;
  String dropOffTime;
  String every;

  Ride(
      {this.fromLocation,
      this.toLocation,
      this.date,
      this.pickUpTime,
      this.dropOffTime,
      this.every});

  void setFromLocation(String fLoc) {
    this.fromLocation = fLoc;
  }

  void setToLocation(String tLoc) {
    this.toLocation = tLoc;
  }

  void setDate(String date) {
    this.date = date;
  }

  void setPickUpTime(String pTime) {
    this.pickUpTime = pTime;
  }

  void setDropOffTime(String dTime) {
    this.dropOffTime = dTime;
  }

  void setEvery(String every) {
    this.every = every;
  }
}
