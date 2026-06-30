using System;
using System.ComponentModel.DataAnnotations.Schema;

namespace Expense_tracker.Entities
{
    public class Expense
    {
        public int Id { get; set; }

        [Column(TypeName = "decimal(18,2)")]
        public decimal Amount { get; set; }

        public string Description { get; set; } // The details of the expense (e.g., "Lunch")
        public DateTime Date { get; set; } // The actual date when the expense occurred
        public DateTime CreatedDate { get; set; } // The timestamp when it is saved in the database

        // Added TransactionType to support Flutter UI dropdown data ("Income" or "Expand")
        public string TransactionType { get; set; }

        // Foreign Keys (To link this expense with a User and a Category)
        public int UserId { get; set; } // The ID of the user who made the expense
        public int CategoryId { get; set; } // The ID of the category this expense belongs to
    }
}
