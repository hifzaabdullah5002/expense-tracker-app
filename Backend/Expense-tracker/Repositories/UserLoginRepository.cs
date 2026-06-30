using Expense_tracker.Data;
using Expense_tracker.DTO;
using Expense_tracker.Entities;
using Expense_tracker.Interfaces.Repositories;
using Microsoft.EntityFrameworkCore;

namespace Expense_tracker.Repositories
{
    public class UserLoginRepository : IUserLoginRepository
    {

        private readonly AppDbContext _context;

        public UserLoginRepository(AppDbContext context)
        {
            _context = context;
        }
        public async Task<object> CreateUser(UserDto data)
        {
            var user = new User
            {
                Username = data.Username,
                Email = data.Email,
                Password = data.Password,
                CreatedDate = DateTime.UtcNow
            };

            await _context.Users.AddAsync(user);

            await _context.SaveChangesAsync();

            return user;
        }

        public async Task<object> Login(LoginDto userAuth)
        {
            try
            {
                var user = await _context.Users.FirstOrDefaultAsync(x => x.Email == userAuth.Email);

                if (user == null)
                {
                    return new
                    {
                        status = false,
                        message = "User not found",
                        data = ""
                    };
                }

                if (user.Password != userAuth.Password)
                {
                    return new
                    {
                        status = false,
                        message = "Incorrect password",
                        data = ""
                    };
                }

                return new
                {
                    status = true,
                    message = "Login successful",
                    data = user
                };
            }
            catch (Exception ex)
            {
                return new
                {
                    status = false,
                    message = ex.Message,
                    data = ""
                };
            }
        }
    }
}
