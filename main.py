import psycopg2
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
cur = conn.cursor()

def insert_data(conn):

    # Inset into Bases
    for _ in range(5):
        cur.execute("""
            INSERT INTO bases (Adress, BaseName, Manager, Contact)
            VALUES (%s, %s, %s, %s)
        """, (fake.address(), fake.company(), fake.name(), fake.phone_number()))

    # insert into Employees
    for person in persons:
        cur.execute("""
            INSERT INTO Employees (FirstName, LastName, StudyGroup, PhoneNumber, Position)
            VALUES (%s, %s, %s, %s, %s)
        """, person)

    for _ in range(5):
        cur.execute("""
            INSERT INTO employees (FirstName, LastName, StudyGroup, PhoneNumber, Position)
            VALUES (%s, %s, %s, %s, %s)
        """, (fake.first_name(), fake.last_name(), rand_study_group(), fake.phone_number(), random.choice(positions)))

    # insert into Tasks
    # remember to check that base with used BaseId exists
    for _ in range(5):
        cur.execute("SELECT baseid FROM Bases")
        base_ids = [row[0] for row in cur.fetchall()]
        cur.execute("INSERT INTO Tasks (BaseID, TaskName, DateStart, Duration) VALUES (%s, %s, %s, %s)",
                    (random.choice(base_ids), fake.job(), fake.date(), fake.random_int(min=1, max=30)))

    # insert into Equipment
    for i in range(5):
        cur.execute("SELECT baseid FROM Bases")
        base_ids = [row[0] for row in cur.fetchall()]
        cur.execute("INSERT INTO Equipment (BaseID, Type, Manufacturer, CntAll, CntInUse) VALUES (%s, %s, %s, %s, %s)",
                    (random.choice(base_ids), eq_piece[i][0], eq_piece[i][1], fake.random_int(min=10, max=20), fake.random_int(min=0, max=10)))


def generate_employee_tasks(n=5):
    cur.execute("SELECT employeeId FROM Employees")
    employee_ids = [row[0] for row in cur.fetchall()]

    cur.execute("SELECT taskId FROM Tasks")
    task_ids = [row[0] for row in cur.fetchall()]

    for _ in range(n):
        cur.execute(
            "INSERT INTO EmployeeTask (ifLeader, employeeId, taskId) VALUES (%s, %s, %s)",
            (fake.boolean(), random.choice(employee_ids), random.choice(task_ids))
        )

def generate_equipment_tasks(n=5):
    cur.execute("SELECT equipmentId FROM Equipment")
    equipment_ids = [row[0] for row in cur.fetchall()]

    cur.execute("SELECT taskId FROM Tasks")
    task_ids = [row[0] for row in cur.fetchall()]
    
    

    for _ in range(n):
        cur.execute(
            "INSERT INTO EquipmentTask (cntUsed, equipmentId, taskId) VALUES (%s, %s, %s)",
            (random.randint(1, 5), random.choice(equipment_ids), random.choice(task_ids))
        )
        

insert_data(conn)
generate_employee_tasks()
generate_equipment_tasks()
conn.commit()
cur.close()
conn.close()