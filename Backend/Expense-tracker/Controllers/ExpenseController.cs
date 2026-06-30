using System;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Expense_tracker.Dtos;
using Expense_tracker.Interfaces.Services;

namespace Expense_tracker.Controllers
{
    [ApiController]
    [Route("api/[controller]")] // URL path format: api/Expense
    public class ExpenseController : ControllerBase
    {
        private readonly IExpenseService _expenseService;

        public ExpenseController(IExpenseService expenseService)
        {
            _expenseService = expenseService;
        }

        // 1. POST Request: To create and log a new expense or income (api/Expense)
        [HttpPost]
        public async Task<IActionResult> LogExpense([FromBody] ExpenseDto expenseDto)
        {
            try
            {
                if (expenseDto == null) return BadRequest("Expense data is null.");

                var createdExpense = await _expenseService.CreateExpenseAsync(expenseDto);
                return Ok(createdExpense);
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

        // 2. GET Request: To fetch all history lines for a specific user (api/Expense/user/{userId})
        [HttpGet("user/{userId}")]
        public async Task<IActionResult> GetUserExpenses(int userId)
        {
            try
            {
                var expenses = await _expenseService.GetUserExpensesAsync(userId);
                return Ok(expenses);
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }

        // 3. DELETE Request: To remove an incorrect expense record (api/Expense/{id})
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteExpense(int id)
        {
            try
            {
                var isDeleted = await _expenseService.RemoveExpenseAsync(id);
                if (!isDeleted) return NotFound($"Expense record with ID {id} not found.");

                return Ok("Expense record successfully deleted.");
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }

        // 4. NEW DASHBOARD GET Request: Fetches sums and dynamic Net Balance (api/Expense/dashboard/{userId})
        [HttpGet("dashboard/{userId}")]
        public async Task<IActionResult> GetDashboardSummary(int userId)
        {
            try
            {
                var summary = await _expenseService.GetDashboardSummaryAsync(userId);
                return Ok(summary); // Returns dynamic json containing TotalIncome, TotalExpense, and NetBalance
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }
    }
}
