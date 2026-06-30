using System.Collections.Generic;
using System.Threading.Tasks;
using Expense_tracker.Dtos;
using Expense_tracker.Entities;

namespace Expense_tracker.Interfaces.Services
{
    public interface IExpenseService
    {
        // To process and create a new expense using DTO data
        Task<Expense> CreateExpenseAsync(ExpenseDto expenseDto);

        // To get all expenses belonging to a specific user
        Task<IEnumerable<Expense>> GetUserExpensesAsync(int userId);

        // To delete an expense tracking entry
        Task<bool> RemoveExpenseAsync(int id);

        // To get the dynamic dashboard summary data (Income, Spent, and Balance) for a user
        Task<object> GetDashboardSummaryAsync(int userId);
    }
}
