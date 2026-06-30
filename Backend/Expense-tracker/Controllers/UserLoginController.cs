using Expense_tracker.DTO;
using Expense_tracker.Interfaces.Services;
using Microsoft.AspNetCore.Mvc;

namespace Expense_tracker.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class UserLoginController : ControllerBase
    {

        private readonly IUserLoginService _userLoginService;

        public UserLoginController(IUserLoginService userLoginService)
        {
            _userLoginService = userLoginService;
        }

        [HttpPost("CreateUser")]
        public async Task<IActionResult> CreateUser([FromBody] UserDto request)
        {
            var data = await _userLoginService.CreateUser(request);
            return Ok(new { message = "Registration successful!" });
        }

        [HttpPost("Login")]
        public async Task<IActionResult> Login([FromBody] LoginDto login)
        {
            try
            {
                var user = await _userLoginService.Login(login);

                if (user == null)
                {
                    return Ok(new
                    {
                        status = false,
                        message = "Invalid username or password",
                        data = ""
                    });
                }

                return Ok(new
                {
                    status = true,
                    message = "Login successful",
                    data = user
                });
            }
            catch (Exception ex)
            {
                return Ok(new
                {
                    status = false,
                    message = ex.Message,
                    data = ""
                });
            }
        }


    }
}
