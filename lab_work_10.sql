-- Практична робота 10. Варіант 1 — Бібліотека
-- База продовжує lab_work_9.db. Структура таблиць не змінюється.
-- Усі запити нижче виконані на копії lab_work_9.db.
PRAGMA foreign_keys = ON;

-- Завдання 1. HAVING на COUNT
SELECT b.id, b.title, COUNT(*) AS loans_count
FROM loans AS l
JOIN books AS b ON b.id = l.book_id
GROUP BY b.id, b.title
HAVING COUNT(*) > 1
ORDER BY b.id;
-- Результат ( id | title | loans_count ):
-- 3 | Лісова пісня | 2

-- Завдання 2. HAVING на AVG
SELECT b.id, b.title,
       AVG(julianday(l.return_date) - julianday(l.loan_date)) AS avg_loan_days
FROM loans AS l
JOIN books AS b ON b.id = l.book_id
GROUP BY b.id, b.title
HAVING AVG(julianday(l.return_date) - julianday(l.loan_date)) > 10
ORDER BY b.id;
-- Результат ( id | title | avg_loan_days ):
-- 1 | Тигролови | 31.0
-- 4 | Місто | 14.0

-- Завдання 3. WHERE + GROUP BY + HAVING
SELECT b.id, b.title,
       COUNT(*) AS returned_loans_count,
       AVG(julianday(l.return_date) - julianday(l.loan_date)) AS avg_loan_days
FROM loans AS l
JOIN books AS b ON b.id = l.book_id
WHERE l.return_date IS NOT NULL
GROUP BY b.id, b.title
HAVING AVG(julianday(l.return_date) - julianday(l.loan_date)) > 10
ORDER BY b.id;
-- Результат ( id | title | returned_loans_count | avg_loan_days ):
-- 1 | Тигролови | 1 | 31.0
-- 4 | Місто | 1 | 14.0

-- Завдання 4. Свідома помилка: агрегат у WHERE.
-- Запит навмисно закоментовано, щоб решта скрипта виконувалася повністю.
-- Для відтворення помилки приберіть коментарі з наступних рядків і виконайте запит окремо.
-- SELECT book_id, COUNT(*) AS loans_count
-- FROM loans
-- WHERE COUNT(*) > 1
-- GROUP BY book_id;
-- Точний текст помилки SQLite: misuse of aggregate: COUNT()

-- Завдання 5. LEFT JOIN збережено, щоб врахувати книги без видач.
SELECT b.id, b.title, COUNT(l.id) AS loans_count
FROM books AS b
LEFT JOIN loans AS l ON l.book_id = b.id
GROUP BY b.id, b.title
HAVING COUNT(l.id) < 2
ORDER BY b.id;
-- Результат ( id | title | loans_count ):
-- 1 | Тигролови | 1
-- 2 | Кобзар | 1
-- 4 | Місто | 1
-- 5 | Захар Беркут | 1
-- 6 | Чорна рада | 1
-- 7 | Кайдашева сім'я | 0

-- PRAGMA foreign_key_check: []
