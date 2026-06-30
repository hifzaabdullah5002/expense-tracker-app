using System.ComponentModel.DataAnnotations.Schema;

namespace Expense_tracker.Entities
{
    public class Budget
    {
        public int Id { get; set; }
        public int UserId { get; set; }
        public int CategoryId { get; set; }

        [Column(TypeName = "decimal(18,2)")]
        public decimal BudgetAmount { get; set; }

        public int Month { get; set; }
        public int Year { get; set; }
    }
}