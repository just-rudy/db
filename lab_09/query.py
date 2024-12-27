import psycopg2
import json
from faker import Faker
import random

fake = Faker()
positions = ["TechSenior", "TechJunior", "NotTech"]


def rand_study_group():
    facoulties = ['ИУ', 'Л', 'ФН', 'СМ', 'МТ', 'РКТ', 'АК',
                  'РК', 'БМТ', 'ИБМ', 'ПС', 'РЛ', 'РТ', 'Э', 'СГН', 'ЮР']
    groups = ['1', '2', '3', '4', '5', '6',
              '7', '8', '9', '10', '11', '12', '13']
    numbers = ['1', '2', '3', '4', '5', '6', '7', '8']
    study_group = random.choice(
        facoulties) + random.choice(groups) + "-" + random.choice(numbers)
    return study_group


def get_top_equipment_usage(cur):
    query = """
        SELECT e.type, COUNT(*) AS usage_cnt
        FROM equipment e
        JOIN equipmenttask et ON e.equipmentid = et.equipmentid
        GROUP BY e.type
        ORDER BY usage_cnt DESC
        LIMIT 10;
    """

    cur.execute(query)
    results = cur.fetchall()

    equipment_usage = []
    for row in results:
        equipment_usage.append({"type": row[0], "usage_cnt": row[1]})

    json_data = json.dumps(equipment_usage, ensure_ascii=False, indent=4)
    return json_data


def insert_some_data():
    conn = psycopg2.connect(
        dbname="postgres",
        user="postgres",
        password="password",
        host="localhost",
        port="5432"
    )
    cur = conn.cursor()

    cur.execute("""
            INSERT INTO employees (FirstName, LastName, StudyGroup, PhoneNumber, Position)
            VALUES (%s, %s, %s, %s, %s)
        """, (fake.first_name(), fake.last_name(), rand_study_group(), fake.phone_number(), random.choice(positions)))

    cur.close()
    conn.close()


def delete_some_data():
    conn = psycopg2.connect(
        dbname="postgres",
        user="postgres",
        password="password",
        host="localhost",
        port="5432"
    )
    cur = conn.cursor()

    cur.execute("""
        DELETE FROM employees
        WHERE employeeid = (SELECT MAX(employeeid) FROM employees);
    """)
    conn.commit()

    cur.close()
    conn.close()


def update_some_data():
    conn = psycopg2.connect(
        dbname="postgres",
        user="postgres",
        password="password",
        host="localhost",
        port="5432"
    )
    cur = conn.cursor()

    cur.execute("""
        UPDATE employees
        SET FirstName = %s, LastName = %s, StudyGroup = %s, PhoneNumber = %s, Position = %s
        WHERE employeeid = (SELECT employeeid FROM employees ORDER BY random() LIMIT 1);
    """, (fake.first_name(), fake.last_name(), rand_study_group(), fake.phone_number(),
          random.choice(positions)))  # Передаем значения через placeholder'ы

    conn.commit()

    cur.close()
    conn.close()
