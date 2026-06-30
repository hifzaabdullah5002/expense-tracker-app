using System.Collections.Generic;
using System.Threading.Tasks;
using Expense_tracker.Dtos;
using Expense_tracker.Entities;

namespace Expense_tracker.Interfaces.Services
{
    public interface IBudgetService
    {
        Task<Budget> CreateBudgetAsync(BudgetDto budgetDto);
        Task<IEnumerable<Budget>> GetUserBudgetsAsync(int userId, int month, int year);
        Task<bool> RemoveBudgetAsync(int id);
        Task<object> GetBudgetSummaryAsync(int userId, int month, int year);
    }
}