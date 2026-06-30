using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using Expense_tracker.Data;
using Expense_tracker.Entities;
using Expense_tracker.Interfaces.Repositories;

namespace Expense_tracker.Repositories
{
    public class BudgetRepository : IBudgetRepository
    {
        private readonly AppDbContext _context;

        public BudgetRepository(AppDbContext context)
        {
            _context = context;
        }

        // 1. Save budget to database
        public async Task<Budget> AddBudgetAsync(Budget budget)
        {
            await _context.Budgets.AddAsync(budget);
            await _context.SaveChangesAsync();
            return budget;
        }

        // 2. Fetch budgets by UserId, Month, Year
        public async Task<IEnumerable<Budget>> GetBudgetsByUserIdAsync(int userId, int month, int year)
        {
            return await _context.Budgets
                .Where(b => b.UserId == userId && b.Month == month && b.Year == year)
                .ToListAsync();
        }

        // 3. Delete budget
        public async Task<bool> DeleteBudgetAsync(int id)
        {
            var budget = await _context.Budgets.FindAsync(id);
            if (budget == null) return false;

            _context.Budgets.Remove(budget);
            await _context.SaveChangesAsync();
            return true;
        }
    }
}