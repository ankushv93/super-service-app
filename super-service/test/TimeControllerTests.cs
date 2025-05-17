using NUnit.Framework;
using SuperService.Controllers;

namespace SuperService.UnitTests
{
  public class TimeControllerTests
  {
    private TimeController controller;
    private static readonly System.DateTime now = new System.DateTime(2020, 01, 01);

    [SetUp]
    public void Setup()
    {
      controller = new TimeController(new MockClock(now));
    }

    [Test]
    public void TheTimeIsNow()
    {
      var time = controller.Get();
      Assert.That(time, Is.EqualTo(now), "Controller did not return the expected time.");
    }
  }
}
