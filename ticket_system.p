import sqlite3
from datetime import datetime

# 1. Database aur Table banana
def init_db():
    conn = sqlite3.connect("tickets.db")
    cursor = conn.cursor()
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS tickets (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_name TEXT NOT NULL,
            issue TEXT NOT NULL,
            priority TEXT NOT NULL,
            status TEXT DEFAULT 'Open',
            created_at TEXT NOT NULL
        )
    """)
    conn.commit()
    conn.close()

# 2. Naya Ticket Create karna
def create_ticket():
    user_name = input("Enter User Name: ").strip()
    issue = input("Describe the IT Issue: ").strip()
    priority = input("Priority (High / Medium / Low): ").strip().capitalize()
    if priority not in ["High", "Medium", "Low"]:
        priority = "Medium"
    created_at = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    conn = sqlite3.connect("tickets.db")
    cursor = conn.cursor()
    cursor.execute(
        "INSERT INTO tickets (user_name, issue, priority, created_at) VALUES (?, ?, ?, ?)",
        (user_name, issue, priority, created_at)
    )
    conn.commit()
    conn.close()
    print("\n✅ Ticket created successfully!\n")

# 3. Saare Tickets Dekhna
def view_tickets():
    conn = sqlite3.connect("tickets.db")
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM tickets")
    rows = cursor.fetchall()
    conn.close()

    if not rows:
        print("\nNo tickets found.\n")
        return

    print("\n--- ALL IT SUPPORT TICKETS ---")
    for row in rows:
        print(f"ID: {row[0]} | User: {row[1]} | Issue: {row[2]} | Priority: {row[3]} | Status: {row[4]} | Date: {row[5]}")
    print()

# 4. Ticket Status Update karna (Open -> In Progress -> Resolved)
def update_status():
    ticket_id = input("Enter Ticket ID to update: ").strip()
    new_status = input("Enter New Status (Open / In Progress / Resolved): ").strip()

    conn = sqlite3.connect("tickets.db")
    cursor = conn.cursor()
    cursor.execute("UPDATE tickets SET status = ? WHERE id = ?", (new_status, ticket_id))
    conn.commit()
    if cursor.rowcount == 0:
        print("\n❌ Ticket ID not found.\n")
    else:
        print("\n✅ Ticket status updated!\n")
    conn.close()

# 5. Ticket Delete karna
def delete_ticket():
    ticket_id = input("Enter Ticket ID to delete: ").strip()
    conn = sqlite3.connect("tickets.db")
    cursor = conn.cursor()
    cursor.execute("DELETE FROM tickets WHERE id = ?", (ticket_id,))
    conn.commit()
    if cursor.rowcount == 0:
        print("\n❌ Ticket ID not found.\n")
    else:
        print("\n✅ Ticket deleted!\n")
    conn.close()

# Main Menu
def main():
    init_db()
    while True:
        print("=== IT SUPPORT TICKET MANAGEMENT SYSTEM ===")
        print("1. Create New Ticket")
        print("2. View All Tickets")
        print("3. Update Ticket Status")
        print("4. Delete Ticket")
        print("5. Exit")

        choice = input("Choose an option (1-5): ").strip()
        if choice == "1":
            create_ticket()
        elif choice == "2":
            view_tickets()
        elif choice == "3":
            update_status()
        elif choice == "4":
            delete_ticket()
        elif choice == "5":
            print("Exiting... Goodbye!")
            break
        else:
            print("\nInvalid choice. Please try again.\n")

if __name__ == "__main__":
    main()