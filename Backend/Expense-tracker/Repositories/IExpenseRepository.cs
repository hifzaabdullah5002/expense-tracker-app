using System.Collections.Generic;
using System.Threading.Tasks;
using Expense_tracker.Entities;

namespace Expense_tracker.Interfaces.Repositories
{
    public interface IExpenseRepository
    {
        // 1. To save a new expense into the database
        Task<Expense> AddExpenseAsync(Expense expense);

        // 2. To get all expenses of a specific user by their UserId
        Task<IEnumerable<Expense>> GetExpensesByUserIdAsync(int userId);

        // 3. To delete an expense by its unique ID
        Task<bool> DeleteExpenseAsync(int id);

        // 4. Contract for calculating total income sum
        Task<decimal> GetTotalIncomeAsync(int userId);

        // 5. Contract for calculating total expense sum
        Task<decimal> GetTotalExpenseAsync(int userId);
    }
}
