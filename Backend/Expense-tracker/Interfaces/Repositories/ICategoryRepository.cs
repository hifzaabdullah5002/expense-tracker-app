using System.Collections.Generic;
using System.Threading.Tasks;
using Expense_tracker.Entities; // To give access to the Category entity model

namespace Expense_tracker.Interfaces.Repositories // Matches your exact folder structure
{
    public interface ICategoryRepository
    {
        // 1. To retrieve all categories from the database
        Task<IEnumerable<Category>> GetAllCategoriesAsync();

        // 2. To find a specific category by its unique ID
        Task<Category> GetCategoryByIdAsync(int id);

        // 3. To save a new category into the database
        Task<Category> AddCategoryAsync(Category category);
    }
}
