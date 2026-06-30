using System;

namespace Expense_tracker.Entities
{
    public class Category
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Icon { get; set; } 
        public DateTime CreatedDate { get; set; }
    }
}
