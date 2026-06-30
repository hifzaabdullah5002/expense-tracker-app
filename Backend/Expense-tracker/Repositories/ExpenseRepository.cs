using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using Expense_tracker.Data;
using Expense_tracker.Entities;
using Expense_tracker.Interfaces.Repositories;

namespace Expense_tracker.Repositories
{
    public class ExpenseRepository : IExpenseRepository
    {
        private readonly AppDbContext _context;

        public ExpenseRepository(AppDbContext context)
        {
            _context = context;
        }

        // 1. Save expense to database
        public async Task<Expense> AddExpenseAsync(Expense expense)
        {
            await _context.Expenses.AddAsync(expense);
            await _context.SaveChangesAsync();
            return expense;
        }

        // 2. Fetch expenses filter by UserId
        public async Task<IEnumerable<Expense>> GetExpensesByUserIdAsync(int userId)
        {
            return await _context.Expenses
                                 .Where(e => e.UserId == userId)
                                 .ToListAsync();
        }

        // 3. Delete expense from database
        public async Task<bool> DeleteExpenseAsync(int id)
        {
            var expense = await _context.Expenses.FindAsync(id);
            if (expense == null) return false;

            _context.Expenses.Remove(expense);
            await _context.SaveChangesAsync();
            return true;
        }

        // 4. Calculate total sum of all "Income" entries for a specific user
        public async Task<decimal> GetTotalIncomeAsync(int userId)
        {
            return await _context.Expenses
                                 .Where(e => e.UserId == userId && e.TransactionType == "Income")
                                 .SumAsync(e => e.Amount);
        }

        // 5. Calculate total sum of all "Expand" entries for a specific user
        public async Task<decimal> GetTotalExpenseAsync(int userId)
        {
            return await _context.Expenses
                                 .Where(e => e.UserId == userId && e.TransactionType == "Expand")
                                 .SumAsync(e => e.Amount);
        }
    }
}
