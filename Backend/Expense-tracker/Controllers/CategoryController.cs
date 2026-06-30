using System;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Expense_tracker.Dtos;
using Expense_tracker.Interfaces.Services;

namespace Expense_tracker.Controllers
{
    [ApiController]
    [Route("api/[controller]")] // Is se aapka URL banyga: api/Category
    public class CategoryController : ControllerBase
    {
        private readonly ICategoryService _categoryService;

        // Constructor to inject the Category Service
        public CategoryController(ICategoryService categoryService)
        {
            _categoryService = categoryService;
        }

        // 1. GET Request: To fetch all categories (api/Category)
        [HttpGet]
        public async Task<IActionResult> GetAllCategories()
        {
            try
            {
                var categories = await _categoryService.GetCategoriesAsync();
                return Ok(categories); // Returns 200 OK with data
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }

        // 2. GET Request by ID: To fetch one category (api/Category/{id})
        [HttpGet("{id}")]
        public async Task<IActionResult> GetCategoryById(int id)
        {
            try
            {
                var category = await _categoryService.GetCategoryByIdAsync(id);
                if (category == null)
                {
                    return NotFound($"Category with ID {id} not found."); // Returns 404
                }
                return Ok(category);
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }

        // 3. POST Request: To create a new category (api/Category)
        [HttpPost]
        public async Task<IActionResult> CreateCategory([FromBody] CategoryDto categoryDto)
        {
            try
            {
                if (categoryDto == null)
                {
                    return BadRequest("Category data is null."); // Returns 400
                }

                var createdCategory = await _categoryService.CreateCategoryAsync(categoryDto);

                // Returns 201 Created status along with the route to access it
                return CreatedAtAction(nameof(GetCategoryById), new { id = createdCategory.Id }, createdCategory);
            }
            catch (ArgumentException ex)
            {
                return BadRequest(ex.Message);
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }
    }
}
