using System;

public class WallClock : IClock
{
  public DateTime GetNow()
  {
    return DateTime.UtcNow;
  }
}