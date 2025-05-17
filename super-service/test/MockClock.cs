using System;

namespace SuperService.UnitTests
{
  internal class MockClock: IClock
  {
    private readonly DateTime now;

    public MockClock(DateTime now)
    {
      this.now = now;
    }

    public DateTime GetNow()
    {
      return now;
    }
  }
}