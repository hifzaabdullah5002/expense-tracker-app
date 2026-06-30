using Expense_tracker.Entities;
using Microsoft.EntityFrameworkCore;

namespace Expense_tracker.Data;

public class AppDbContext : DbContext
{
    public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

    public DbSet<User> Users => Set<User>();
    public DbSet<Category> Categories => Set<Category>();
    public DbSet<Expense> Expenses => Set<Expense>();

    // ✅ Budget table added
    public DbSet<Budget> Budgets => Set<Budget>();
}