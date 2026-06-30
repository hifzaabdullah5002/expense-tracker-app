using System.Collections.Generic;
using System.Threading.Tasks;
using Expense_tracker.Dtos;
using Expense_tracker.Entities;

namespace Expense_tracker.Interfaces.Services
{
    public interface ICategoryService
    {
        Task<IEnumerable<Category>> GetCategoriesAsync();
        Task<Category> GetCategoryByIdAsync(int id);
        Task<Category> CreateCategoryAsync(CategoryDto categoryDto);
    }
}
