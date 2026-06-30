using System.Threading.Tasks;
using Expense_tracker.Dtos;
using Expense_tracker.Interfaces.Services;
using Microsoft.AspNetCore.Mvc;

namespace Expense_tracker.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class BudgetController : ControllerBase
    {
        private readonly IBudgetService _budgetService;

        public BudgetController(IBudgetService budgetService)
        {
            _budgetService = budgetService;
        }

        // POST: api/Budget
        [HttpPost]
        public async Task<IActionResult> CreateBudget([FromBody] BudgetDto budgetDto)
        {
            var result = await _budgetService.CreateBudgetAsync(budgetDto);
            return Ok(result);
        }

        // GET: api/Budget/user/{userId}?month=6&year=2026
        [HttpGet("user/{userId}")]
        public async Task<IActionResult> GetBudgets(int userId, [FromQuery] int month, [FromQuery] int year)
        {
            var result = await _budgetService.GetUserBudgetsAsync(userId, month, year);
            return Ok(result);
        }

        // GET: api/Budget/summary/{userId}?month=6&year=2026
        [HttpGet("summary/{userId}")]
        public async Task<IActionResult> GetBudgetSummary(int userId, [FromQuery] int month, [FromQuery] int year)
        {
            var result = await _budgetService.GetBudgetSummaryAsync(userId, month, year);
            return Ok(result);
        }

        // DELETE: api/Budget/{id}
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteBudget(int id)
        {
            var result = await _budgetService.RemoveBudgetAsync(id);
            if (!result) return NotFound();
            return Ok(new { message = "Budget deleted successfully!" });
        }
    }
}