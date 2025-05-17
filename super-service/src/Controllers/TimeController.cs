using System;
using Microsoft.AspNetCore.Mvc;

namespace SuperService.Controllers
{
  [ApiController]
  [Route("[controller]")]
  public class TimeController : ControllerBase
  {
    private IClock clock;

    public TimeController(IClock clock)
    {
      this.clock = clock;
    }

    [HttpGet]
    public DateTime Get()
    {
      return clock.GetNow();
    }
  }
}
