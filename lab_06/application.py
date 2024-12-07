import psycopg2
from psycopg2 import sql
from faker import Faker
import random
from gen_specific_data import persons, rand_study_group, eq_piece, positions

fake = Faker()

conn = psycopg2.connect(
    dbname="postgres",
    user="postgres",
    password="password",
    host="localhost",
    port="5432"
)


# Проверить существование таблицы
def check_table_exists(table_name, connection):
    cursor = conn.cursor()
    cursor.execute("""
        SELECT EXISTS (
            SELECT 1 
            FROM information_schema.tables 
            WHERE table_schema = 'public' 
            AND table_name = %s
        );
    """, (table_name,))
    exists = cursor.fetchone()[0]
    cursor.close()
    return exists


# 1. Выполнить скалярный запрос;

def scalar_query(conn):

    db_name = 'employees'
    if not check_table_exists(db_name, conn):
        print(f"База данных {db_name} не существует.")
        return

    cur = conn.cursor()
    cur.execute("""
        SELECT COUNT(*) FROM Employees
    """)
    result = cur.fetchone()[0]
    print(f'Number of employees: {result}')
    cur.close()


# 2. Выполнить запрос с несколькими соединениями (JOIN);

def join_query(conn):

    db_name = 'employees'
    if not (check_table_exists('employees', conn) and check_table_exists('employeetask', conn) and check_table_exists('tasks', conn)):
        print(f"База данных {db_name} не существует.")
        return
    cur = conn.cursor()
    cur.execute("""SELECT E.employeeid, E.FirstName, E.LastName, E.Position, T.taskName, ET.ifLeader
        FROM Employees E
        JOIN EmployeeTask ET ON ET.employeeId = E.employeeId
        JOIN Tasks T ON ET.taskId = T.taskId;""")
    result = cur.fetchall()
    for row in result:
        print(row)
    cur.close()


# TODO: 3. Выполнить запрос с ОТВ(CTE) и оконными функциями;

def cte_and_window_function_query(connection):

    db_name = 'employees'
    if not check_table_exists(db_name, connection):
        print(f"База данных {db_name} не существует.")
        return
    cursor = connection.cursor()
    cursor.execute("""
        WITH CTE AS (
            SELECT e.employeeId, e.firstName, e.lastName, ROW_NUMBER() OVER (ORDER BY e.lastName) as row_num
            FROM Employees e
        )
        SELECT * FROM CTE WHERE row_num <= 10
    """)
    results = cursor.fetchall()
    for row in results:
        print(row)
    cursor.close()


# 4. Выполнить запрос к метаданным;

def metadata_query(connection):
    cursor = connection.cursor()
    cursor.execute("SELECT table_name FROM information_schema.tables")
    tables = cursor.fetchall()
    for table in tables:
        print(table[0])
    cursor.close()


# 5. Вызвать скалярную функцию (написанную в третьей лабораторной работе);

def call_scalar_function(connection):
    cursor = connection.cursor()
    cursor.execute("SELECT get_full_name(%s)", (1,))
    result = cursor.fetchone()
    print(f"Полное имя сотрудника: {result[0]}")
    cursor.close()


# 6. Вызвать многооператорную или табличную функцию (написанную в третьей лабораторной работе);

def call_table_function(connection):
    cursor = connection.cursor()
    cursor.execute("SELECT * FROM get_equipment_by_base(%s)", (1,))
    results = cursor.fetchall()
    for row in results:
        print(row)
    cursor.close()


# 7. Вызвать хранимую процедуру (написанную в третьей лабораторной работе);

def call_stored_procedure(connection):
    cursor = connection.cursor()
    cursor.callproc('add_employee', ('Егор', 'Егор', 'РК4', '+79162225533', 'TechJunior'))
    connection.commit()
    cursor.close()
    print("Новый сотрудник добавлен")


# 8. Вызвать системную функцию или процедуру;

def call_system_function(connection):
    cursor = connection.cursor()
    cursor.execute("SELECT current_database()")
    result = cursor.fetchone()
    print(f"Текущая база данных: {result[0]}")
    cursor.close()


# 9. Создать таблицу в базе данных, соответствующую тематике БД;

def create_table(connection):
    cursor = connection.cursor()
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS skill_listing (
            id SERIAL PRIMARY KEY,
            employeeID INTEGER REFERENCES Employees(employeeId),
            toolID INTEGER REFERENCES equipment(equipmentid)
        )
    """)
    connection.commit()
    cursor.close()
    print("Таблица создана")


# 10. Выполнить вставку данных в созданную таблицу с использованием инструкции INSERT или COPY.

def insert_into_table(connection):
    db_name = 'skill_listing'
    if not check_table_exists(db_name, connection):
        print(f"База данных {db_name} не существует.")
        return

    cursor = connection.cursor()
    cursor.execute("INSERT INTO skill_listing (employeeID, toolID) VALUES (%s, %s)", (1, 1))
    cursor.execute("INSERT INTO skill_listing (employeeID, toolID) VALUES (%s, %s)", (1, 2))
    cursor.execute("INSERT INTO skill_listing (employeeID, toolID) VALUES (%s, %s)", (1, 3))
    cursor.execute("INSERT INTO skill_listing (employeeID, toolID) VALUES (%s, %s)", (1, 4))
    cursor.execute("INSERT INTO skill_listing (employeeID, toolID) VALUES (%s, %s)", (1, 5))
    print("Данные вставлены в таблицу.")
    connection.commit()
    cursor.close()


def select_all_emp(connection):
    db_name = 'employees'
    if not check_table_exists(db_name, connection):
        print(f"База данных {db_name} не существует.")
        return
    cursor = connection.cursor()
    cursor.execute("SELECT * FROM Employees")
    result = cursor.fetchall()
    for row in result:
        print(row)
    cursor.close()


def select_all_skill(connection):
    db_name = 'skill_listing'
    if not check_table_exists(db_name, connection):
        print(f"База данных {db_name} не существует.")
        return

    cursor = connection.cursor()
    cursor.execute("SELECT * FROM SKILL_LISTING")
    result = cursor.fetchall()
    for row in result:
        print(row)
    cursor.close()


def print_menu():
    print("""
    0.  Выход
    1.  Выполнить скалярный запрос
    2.  Выполнить запрос с несколькими соединениями (JOIN)
    3.  Выполнить запрос с ОТВ(CTE) и оконными функциями
    4.  Выполнить запрос к метаданным
    5.  Вызвать скалярную функцию (написанную в третьей лабораторной работе)
    6.  Вызвать многооператорную или табличную функцию (написанную в третьей лабораторной работе)
    7.  Вызвать хранимую процедуру (написанную в третьей лабораторной работе)
    8.  Вызвать системную функцию или процедуру
    9.  Создать таблицу в базе данных, соответствующую тематике БД
    10. Выполнить вставку данных в созданную таблицу с использованием инструкции INSERT или COPY
    11. SELECT * FROM EMPLOYEES
    12. SELECT * FROM SKILL_LISTING
    """)


# body

print_menu()
com = int(input(": "))
while com != 0:
    if com == 1:
        scalar_query(conn)
    elif com == 2:
        join_query(conn)
    elif com == 3:
        cte_and_window_function_query(conn)
    elif com == 4:
        metadata_query(conn)
    elif com == 5:
        call_scalar_function(conn)
    elif com == 6:
        call_table_function(conn)
    elif com == 7:
        call_stored_procedure(conn)
    elif com == 8:
        call_system_function(conn)
    elif com == 9:
        create_table(conn)
    elif com == 10:
        insert_into_table(conn)
    elif com == 11:
        select_all_emp(conn)
    elif com == 12:
        select_all_skill(conn)
    else:
        print("Неверный ввод, повторите")
    com = int(input(": "))
conn.close()
