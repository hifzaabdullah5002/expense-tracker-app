using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Expense_tracker.Dtos;
using Expense_tracker.Entities;
using Expense_tracker.Interfaces.Repositories;
using Expense_tracker.Interfaces.Services;

namespace Expense_tracker.Services
{
    public class BudgetService : IBudgetService
    {
        private readonly IBudgetRepository _budgetRepository;
        private readonly IExpenseRepository _expenseRepository;

        public BudgetService(IBudgetRepository budgetRepository, IExpenseRepository expenseRepository)
        {
            _budgetRepository = budgetRepository;
            _expenseRepository = expenseRepository;
        }

        // 1. Create new budget
        public async Task<Budget> CreateBudgetAsync(BudgetDto budgetDto)
        {
            if (budgetDto.BudgetAmount <= 0)
                throw new ArgumentException("Budget amount must be greater than zero.");

            var newBudget = new Budget
            {
                UserId = budgetDto.UserId,
                CategoryId = budgetDto.CategoryId,
                BudgetAmount = budgetDto.BudgetAmount,
                Month = budgetDto.Month,
                Year = budgetDto.Year
            };

            return await _budgetRepository.AddBudgetAsync(newBudget);
        }

        // 2. Get all budgets of a user
        public async Task<IEnumerable<Budget>> GetUserBudgetsAsync(int userId, int month, int year)
        {
            return await _budgetRepository.GetBudgetsByUserIdAsync(userId, month, year);
        }

        // 3. Delete a budget
        public async Task<bool> RemoveBudgetAsync(int id)
        {
            return await _budgetRepository.DeleteBudgetAsync(id);
        }

        // 4. Budget Summary — Total Budget, Total Spent, Remaining
        public async Task<object> GetBudgetSummaryAsync(int userId, int month, int year)
        {
            var budgets = await _budgetRepository.GetBudgetsByUserIdAsync(userId, month, year);
            var expenses = await _expenseRepository.GetExpensesByUserIdAsync(userId);

            decimal totalBudget = budgets.Sum(b => b.BudgetAmount);

            decimal totalSpent = expenses
                .Where(e => e.Date.Month == month && e.Date.Year == year && e.TransactionType == "Expand")
                .Sum(e => e.Amount);

            decimal remaining = totalBudget - totalSpent;

            return new
            {
                TotalBudget = totalBudget,
                TotalSpent = totalSpent,
                Remaining = remaining
            };
        }
    }
}