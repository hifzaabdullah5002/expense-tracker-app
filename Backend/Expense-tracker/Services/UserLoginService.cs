using Expense_tracker.DTO;
using Expense_tracker.Interfaces.Repositories;
using Expense_tracker.Interfaces.Services;
using static System.Runtime.InteropServices.JavaScript.JSType;

namespace Expense_tracker.Services
{
    public class UserLoginService : IUserLoginService
    {
        private readonly IUserLoginRepository _userLoginRepository;
        public UserLoginService(IUserLoginRepository userLoginRepository) {
            _userLoginRepository = userLoginRepository;
        }

        public async Task<object> CreateUser(UserDto data)
        {
            return await _userLoginRepository.CreateUser(data);      
        }

        public async Task<object> Login(LoginDto login)
        {
            return await _userLoginRepository.Login(login);
        }
    }
}
