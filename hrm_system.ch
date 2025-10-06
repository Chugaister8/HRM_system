using System;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using System.IO;
using System.Text.Json;

class Employee
{
    public int Id { get; set; }
    public string CompanyName { get; set; }
    public string FirstName { get; set; }
    public string LastName { get; set; }
    public string Position { get; set; }
    public string Department { get; set; }
    public string BirthDate { get; set; }
    public string PhoneNumber { get; set; }
    public string Email { get; set; }
    public string HireDate { get; set; } // Нове поле для HRM
    public bool IsActive { get; set; }   // Статус активності
    public string Notes { get; set; }     // Нотатки про співробітника

    public Employee(int id)
    {
        Id = id;
        IsActive = true;
    }
}

class Program
{
    static List<Employee> employees = new List<Employee>();
    static readonly string filePath = "employees.json";

    static void Main(string[] args)
    {
        // Завантажуємо дані з файлу при старті
        LoadEmployees();

        // Додаємо тестового співробітника, якщо список порожній
        if (employees.Count == 0)
        {
            employees.Add(new Employee(1)
            {
                CompanyName = "TechCorp",
                FirstName = "Олександр",
                LastName = "Петренко",
                Position = "Розробник",
                Department = "IT",
                BirthDate = "15.03.1995",
                PhoneNumber = "+380671234567",
                Email = "o.petrenko@example.com",
                HireDate = "01.01.2020",
                Notes = "Досвідчений розробник C#"
            });
        }

        // Основне меню
        while (true)
        {
            Console.Clear();
            Console.WriteLine("HRM Система");
            Console.WriteLine("---------------------------------------------------");
            Console.WriteLine("1. Показати всіх співробітників");
            Console.WriteLine("2. Додати нового співробітника");
            Console.WriteLine("3. Пошук співробітника");
            Console.WriteLine("4. Редагувати співробітника");
            Console.WriteLine("5. Видалити співробітника");
            Console.WriteLine("6. Вихід");
            Console.Write("Виберіть опцію: ");

            string choice = Console.ReadLine();
            switch (choice)
            {
                case "1": ShowAllEmployees(); break;
                case "2": AddNewEmployee(); break;
                case "3": SearchEmployee(); break;
                case "4": EditEmployee(); break;
                case "5": DeleteEmployee(); break;
                case "6": SaveEmployees(); return;
                default: Console.WriteLine("Невірна опція! Натисніть будь-яку клавішу..."); Console.ReadKey(); break;
            }
        }
    }

    // Функція для виведення всіх співробітників
    static void ShowAllEmployees()
    {
        Console.Clear();
        Console.WriteLine("Список співробітників:");
        Console.WriteLine("------------------------------------------------------");
        foreach (var emp in employees)
        {
            PrintEmployee(emp);
        }
        Console.WriteLine("\nНатисніть будь-яку клавішу...");
        Console.ReadKey();
    }

    // Функція для виведення даних одного співробітника
    static void PrintEmployee(Employee emp)
    {
        Console.WriteLine($"ID.................: {emp.Id}");
        Console.WriteLine($"Назва компанії.....: {emp.CompanyName}");
        Console.WriteLine($"Ім'я...............: {emp.FirstName}");
        Console.WriteLine($"Прізвище...........: {emp.LastName}");
        Console.WriteLine($"Посада.............: {emp.Position}");
        Console.WriteLine($"Відділ.............: {emp.Department}");
        Console.WriteLine($"Дата народження....: {emp.BirthDate} (Вік: {CalculateAge(emp.BirthDate)})");
        Console.WriteLine($"Номер телефону.....: {emp.PhoneNumber}");
        Console.WriteLine($"Електронна пошта...: {emp.Email}");
        Console.WriteLine($"Дата прийому.......: {emp.HireDate}");
        Console.WriteLine($"Статус.............: {(emp.IsActive ? "Активний" : "Неактивний")}");
        Console.WriteLine($"Нотатки............: {emp.Notes ?? "Немає"}");
        Console.WriteLine("------------------------------------------------------");
    }

    // Функція для обчислення віку
    static int CalculateAge(string birthDate)
    {
        try
        {
            DateTime dob = DateTime.ParseExact(birthDate, "dd.MM.yyyy", null);
            DateTime today = DateTime.Today;
            int age = today.Year - dob.Year;
            if (dob.Date > today.AddYears(-age)) age--;
            return age;
        }
        catch
        {
            return -1;
        }
    }

    // Функція для перевірки формату номера телефону
    static bool IsValidPhoneNumber(string phoneNumber)
    {
        return Regex.IsMatch(phoneNumber, @"^\+\d{10,12}$");
    }

    // Функція для перевірки формату електронної пошти
    static bool IsValidEmail(string email)
    {
        return Regex.IsMatch(email, @"^[^@\s]+@[^@\s]+\.[^@\s]+$");
    }

    // Функція для додавання нового співробітника
    static void AddNewEmployee()
    {
        Console.Clear();
        Console.WriteLine("Додавання нового співробітника:");
        try
        {
            var emp = new Employee(employees.Count + 1);
            Console.Write("Назва компанії.....: ");
            emp.CompanyName = Console.ReadLine();
            Console.Write("Ім'я...............: ");
            emp.FirstName = Console.ReadLine();
            Console.Write("Прізвище...........: ");
            emp.LastName = Console.ReadLine();
            Console.Write("Посада.............: ");
            emp.Position = Console.ReadLine();
            Console.Write("Відділ.............: ");
            emp.Department = Console.ReadLine();
            Console.Write("Дата народження.... (ДД.ММ.РРРР): ");
            emp.BirthDate = Console.ReadLine();
            if (!Regex.IsMatch(emp.BirthDate, @"^\d{2}\.\d{2}\.\d{4}$"))
            {
                Console.WriteLine("Невірний формат дати народження!");
                Console.ReadKey();
                return;
            }
            Console.Write("Номер телефону..... (+380...): ");
            emp.PhoneNumber = Console.ReadLine();
            if (!IsValidPhoneNumber(emp.PhoneNumber))
            {
                Console.WriteLine("Невірний формат номера телефону!");
                Console.ReadKey();
                return;
            }
            Console.Write("Електронна пошта...: ");
            emp.Email = Console.ReadLine();
            if (!IsValidEmail(emp.Email))
            {
                Console.WriteLine("Невірний формат електронної пошти!");
                Console.ReadKey();
                return;
            }
            Console.Write("Дата прийому....... (ДД.ММ.РРРР): ");
            emp.HireDate = Console.ReadLine();
            if (!Regex.IsMatch(emp.HireDate, @"^\d{2}\.\d{2}\.\d{4}$"))
            {
                Console.WriteLine("Невірний формат дати прийому!");
                Console.ReadKey();
                return;
            }
            Console.Write("Нотатки............: ");
            emp.Notes = Console.ReadLine();

            employees.Add(emp);
            SaveEmployees();
            Console.WriteLine("Співробітника додано!");
        }
        catch
        {
            Console.WriteLine("Помилка при введенні даних!");
        }
        Console.WriteLine("Натисніть будь-яку клавішу...");
        Console.ReadKey();
    }

    // Функція для пошуку співробітника
    static void SearchEmployee()
    {
        Console.Clear();
        Console.Write("Введіть пошуковий запит (ім'я, прізвище, email або відділ): ");
        string query = Console.ReadLine().ToLower();
        Console.WriteLine("\nРезультати пошуку:");
        Console.WriteLine("------------------------------------------------------");
        bool found = false;
        foreach (var emp in employees)
        {
            if (emp.FirstName.ToLower().Contains(query) ||
                emp.LastName.ToLower().Contains(query) ||
                emp.Email.ToLower().Contains(query) ||
                emp.Department.ToLower().Contains(query))
            {
                PrintEmployee(emp);
                found = true;
            }
        }
        if (!found) Console.WriteLine("Співробітників не знайдено!");
        Console.WriteLine("\nНатисніть будь-яку клавішу...");
        Console.ReadKey();
    }

    // Функція для редагування співробітника
    static void EditEmployee()
    {
        Console.Clear();
        Console.Write("Введіть ID співробітника для редагування: ");
        if (!int.TryParse(Console.ReadLine(), out int id))
        {
            Console.WriteLine("Невірний формат ID!");
            Console.ReadKey();
            return;
        }

        var emp = employees.Find(e => e.Id == id);
        if (emp == null)
        {
            Console.WriteLine("Співробітника не знайдено!");
            Console.ReadKey();
            return;
        }

        Console.WriteLine("Поточні дані:");
        PrintEmployee(emp);
        Console.WriteLine("Введіть нові дані (залиште порожнім, щоб не змінювати):");

        Console.Write($"Назва компанії..... ({emp.CompanyName}): ");
        string input = Console.ReadLine();
        if (!string.IsNullOrEmpty(input)) emp.CompanyName = input;

        Console.Write($"Ім'я............... ({emp.FirstName}): ");
        input = Console.ReadLine();
        if (!string.IsNullOrEmpty(input)) emp.FirstName = input;

        Console.Write($"Прізвище........... ({emp.LastName}): ");
        input = Console.ReadLine();
        if (!string.IsNullOrEmpty(input)) emp.LastName = input;

        Console.Write($"Посада............. ({emp.Position}): ");
        input = Console.ReadLine();
        if (!string.IsNullOrEmpty(input)) emp.Position = input;

        Console.Write($"Відділ............. ({emp.Department}): ");
        input = Console.ReadLine();
        if (!string.IsNullOrEmpty(input)) emp.Department = input;

        Console.Write($"Дата народження.... ({emp.BirthDate}): ");
        input = Console.ReadLine();
        if (!string.IsNullOrEmpty(input) && Regex.IsMatch(input, @"^\d{2}\.\d{2}\.\d{4}$"))
            emp.BirthDate = input;

        Console.Write($"Номер телефону..... ({emp.PhoneNumber}): ");
        input = Console.ReadLine();
        if (!string.IsNullOrEmpty(input) && IsValidPhoneNumber(input))
            emp.PhoneNumber = input;

        Console.Write($"Електронна пошта... ({emp.Email}): ");
        input = Console.ReadLine();
        if (!string.IsNullOrEmpty(input) && IsValidEmail(input))
            emp.Email = input;

        Console.Write($"Дата прийому....... ({emp.HireDate}): ");
        input = Console.ReadLine();
        if (!string.IsNullOrEmpty(input) && Regex.IsMatch(input, @"^\d{2}\.\d{2}\.\d{4}$"))
            emp.HireDate = input;

        Console.Write($"Нотатки............ ({emp.Notes ?? "Немає"}): ");
        input = Console.ReadLine();
        if (!string.IsNullOrEmpty(input)) emp.Notes = input;

        Console.Write($"Статус (Активний/Неактивний).... ({(emp.IsActive ? "Активний" : "Неактивний")}): ");
        input = Console.ReadLine().ToLower();
        if (input == "активний") emp.IsActive = true;
        else if (input == "неактивний") emp.IsActive = false;

        SaveEmployees();
        Console.WriteLine("Дані оновлено!");
        Console.WriteLine("Натисніть будь-яку клавішу...");
        Console.ReadKey();
    }

    // Функція для видалення співробітника
    static void DeleteEmployee()
    {
        Console.Clear();
        Console.Write("Введіть ID співробітника для видалення: ");
        if (!int.TryParse(Console.ReadLine(), out int id))
        {
            Console.WriteLine("Невірний формат ID!");
            Console.ReadKey();
            return;
        }

        var emp = employees.Find(e => e.Id == id);
        if (emp == null)
        {
            Console.WriteLine("Співробітника не знайдено!");
            Console.ReadKey();
            return;
        }

        Console.WriteLine("Поточні дані:");
        PrintEmployee(emp);
        Console.Write("Ви впевнені, що хочете видалити? (y/n): ");
        if (Console.ReadLine().ToLower() == "y")
        {
            employees.Remove(emp);
            SaveEmployees();
            Console.WriteLine("Співробітника видалено!");
        }
        Console.WriteLine("Натисніть будь-яку клавішу...");
        Console.ReadKey();
    }

    // Функція для збереження даних у JSON
    static void SaveEmployees()
    {
        try
        {
            string json = JsonSerializer.Serialize(employees, new JsonSerializerOptions { WriteIndented = true });
            File.WriteAllText(filePath, json);
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Помилка при збереженні даних: {ex.Message}");
        }
    }

    // Функція для завантаження даних із JSON
    static void LoadEmployees()
    {
        try
        {
            if (File.Exists(filePath))
            {
                string json = File.ReadAllText(filePath);
                employees = JsonSerializer.Deserialize<List<Employee>>(json) ?? new List<Employee>();
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Помилка при завантаженні даних: {ex.Message}");
        }
    }
      }
