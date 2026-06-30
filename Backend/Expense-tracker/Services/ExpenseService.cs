using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Expense_tracker.Dtos;
using Expense_tracker.Entities;
using Expense_tracker.Interfaces.Repositories;
using Expense_tracker.Interfaces.Services;

namespace Expense_tracker.Services
{
    public class ExpenseService : IExpenseService
    {
        private readonly IExpenseRepository _expenseRepository;

        // Constructor to inject the updated Expense Repository
        public ExpenseService(IExpenseRepository expenseRepository)
        {
            _expenseRepository = expenseRepository;
        }

        // 1. Process and add expense with business validations
        public async Task<Expense> CreateExpenseAsync(ExpenseDto expenseDto)
        {
            if (expenseDto.Amount <= 0)
            {
                throw new ArgumentException("Expense amount must be greater than zero.");
            }

            if (string.IsNullOrWhiteSpace(expenseDto.Description))
            {
                throw new ArgumentException("Expense description cannot be empty.");
            }

            var newExpense = new Expense
            {
                Amount = expenseDto.Amount,
                Description = expenseDto.Description,
                Date = expenseDto.Date,
                UserId = expenseDto.UserId,
                CategoryId = expenseDto.CategoryId,
                TransactionType = expenseDto.TransactionType, // Connects directly to Flutter selection
                CreatedDate = DateTime.UtcNow
            };

            return await _expenseRepository.AddExpenseAsync(newExpense);
        }

        // 2. Fetch all expenses of a user
        public async Task<IEnumerable<Expense>> GetUserExpensesAsync(int userId)
        {
            return await _expenseRepository.GetExpensesByUserIdAsync(userId);
        }

        // 3. Delete an expense from database
        public async Task<bool> RemoveExpenseAsync(int id)
        {
            return await _expenseRepository.DeleteExpenseAsync(id);
        }

        // 4. Calculator Brain: Compiles Total Income, Spent, and Calculates Net Balance
        public async Task<object> GetDashboardSummaryAsync(int userId)
        {
            // Fetch running sums dynamically from our repository layers
            decimal totalIncome = await _expenseRepository.GetTotalIncomeAsync(userId);
            decimal totalExpense = await _expenseRepository.GetTotalExpenseAsync(userId);

            // Formula to calculate net wallet status
            decimal netBalance = totalIncome - totalExpense;

            // Return a unified anonymous data packet for our Flutter Dashboard
            return new
            {
                TotalIncome = totalIncome,
                TotalExpense = totalExpense,
                NetBalance = netBalance
            };
        }
    }
}
