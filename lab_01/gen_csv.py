import csv
from faker import Faker
import random
import pandas as pd
from gen_specific_data import persons, rand_study_group, eq_piece, positions


fake = Faker()
base_ids = range(1, 1001)

def generate_bases(n=1000, filename='lab_01/csv/bases.csv'):
    data = []
    for i in range(n):
        data.append([fake.address(), fake.company(), fake.name(), fake.phone_number()])
    df = pd.DataFrame(data, columns=["adress", "baseName", "manager", "contact"])
    df.to_csv(filename, index=False)

def generate_employees(n=1000, filename='lab_01/csv/employees.csv'):
    data = []
    for i in range(n):
        data.append([fake.first_name(), fake.last_name(), rand_study_group(), fake.phone_number(), random.choice(positions)])
    df = pd.DataFrame(data, columns=["firstName", "lastName", "studyGroup", "phoneNumber", "position"])
    df.to_csv(filename, index=False)

def generate_equipment(n=1000, filename='lab_01/csv/equipment.csv'):
    data = []
    for i in range(n):
        data.append([random.choice(base_ids), eq_piece[i][0], eq_piece[i][1], fake.random_int(min=10, max=20), fake.random_int(min=0, max=10)])
    df = pd.DataFrame(data, columns=["baseid", "type", "manufacturer", "cntAll", "cntInUse"])
    df.to_csv(filename, index=False)

def generate_tasks(n=1000, filename='lab_01/csv/tasks.csv'):
    data = []
    for _ in range(n):
        data.append([random.choice(base_ids), fake.job(), fake.date(), fake.random_int(min=1, max=30)])
    df = pd.DataFrame(data, columns=["baseid", "taskName", "dateStart", "duration"])
    df.to_csv(filename, index=False)

def generate_employee_tasks(n=1000, filename='lab_01/csv/employee_tasks.csv'):
    employee_ids = list(range(1, 1001))
    task_ids = list(range(1, 1001))
    data = []
    for _ in range(n):
        data.append([fake.boolean(), random.choice(employee_ids), random.choice(task_ids)])
    df = pd.DataFrame(data, columns=["ifLeader", "employeeId", "taskId"])
    df.to_csv(filename, index=False)

def generate_equipment_tasks(n=1000, filename='lab_01/csv/equipment_tasks.csv'):
    equipment_ids = list(range(1, 1001))
    task_ids = list(range(1, 1001))
    data = []
    for _ in range(n):
        data.append([random.randint(1, 10), random.choice(equipment_ids), random.choice(task_ids)])
    df = pd.DataFrame(data, columns=["cntUsed", "equipmentId", "taskId"])
    df.to_csv(filename, index=False)

# Генерация CSV файлов
generate_bases()
generate_employees()
generate_equipment()
generate_tasks()
generate_employee_tasks()
generate_equipment_tasks()
