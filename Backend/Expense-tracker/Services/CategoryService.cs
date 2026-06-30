using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Expense_tracker.Dtos;
using Expense_tracker.Entities;
using Expense_tracker.Interfaces.Repositories; // Connected to new namespace
using Expense_tracker.Interfaces.Services;     // Connected to service interface

namespace Expense_tracker.Services
{
    public class CategoryService : ICategoryService
    {
        private readonly ICategoryRepository _categoryRepository;

        public CategoryService(ICategoryRepository categoryRepository)
        {
            _categoryRepository = categoryRepository;
        }

        public async Task<IEnumerable<Category>> GetCategoriesAsync()
        {
            return await _categoryRepository.GetAllCategoriesAsync();
        }

        public async Task<Category> GetCategoryByIdAsync(int id)
        {
            return await _categoryRepository.GetCategoryByIdAsync(id);
        }

        public async Task<Category> CreateCategoryAsync(CategoryDto categoryDto)
        {
            if (string.IsNullOrWhiteSpace(categoryDto.Name))
            {
                throw new ArgumentException("Category name cannot be empty.");
            }

            var newCategory = new Category
            {
                Name = categoryDto.Name,
                Icon = categoryDto.Icon ?? "📁",
                CreatedDate = DateTime.UtcNow
            };

            return await _categoryRepository.AddCategoryAsync(newCategory);
        }
    }
}
