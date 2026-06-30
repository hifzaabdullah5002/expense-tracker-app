using Expense_tracker.DTO;

namespace Expense_tracker.Interfaces.Services
{
    public interface IUserLoginService
    {
        Task<object> CreateUser(UserDto data);
        Task<object> Login(LoginDto login);
    }
}
