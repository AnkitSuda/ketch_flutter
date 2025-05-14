enum Status {
  QUEUED("QUEUED"),
  STARTED("STARTED"),
  PROGRESS("PROGRESS"),
  SUCCESS("SUCCESS"),
  CANCELLED("CANCELLED"),
  FAILED("FAILED"),
  PAUSED("PAUSED"),
  DEFAULT("DEFAULT");

  const Status(this.value);

  final String value;
}
