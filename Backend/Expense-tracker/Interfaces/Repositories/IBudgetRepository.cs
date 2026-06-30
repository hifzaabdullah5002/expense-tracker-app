using System.Collections.Generic;
using System.Threading.Tasks;
using Expense_tracker.Entities;

namespace Expense_tracker.Interfaces.Repositories
{
    public interface IBudgetRepository
    {
        Task<Budget> AddBudgetAsync(Budget budget);
        Task<IEnumerable<Budget>> GetBudgetsByUserIdAsync(int userId, int month, int year);
        Task<bool> DeleteBudgetAsync(int id);
    }
}