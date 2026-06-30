
using Expense_tracker.DTO;

namespace Expense_tracker.Interfaces.Repositories
{
    public interface IUserLoginRepository
    {
        Task<object> CreateUser(UserDto data);
        Task<object> Login(LoginDto login);

    }
}
