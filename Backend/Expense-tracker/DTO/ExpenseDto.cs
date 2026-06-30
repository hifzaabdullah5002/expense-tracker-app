using System;

namespace Expense_tracker.Dtos
{
    public class ExpenseDto
    {
        public decimal Amount { get; set; }
        public string Description { get; set; }
        public DateTime Date { get; set; }
        public int CategoryId { get; set; }
        public int UserId { get; set; }

        // Added to handle Flutter app's transaction type selection ("Income" or "Expand")
        public string TransactionType { get; set; }
    }
}
