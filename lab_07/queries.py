import json  
from sqlalchemy import select, update, delete
from models import Bases, Employees, Equipment, Tasks, EmployeeTask, EquipmentTask  
from database import session  

# TODO: Задача 1: LINQ to Objects (запросы к объектам)
def query_objects():  
    # Пример запроса всех баз
    bases = session.query(Bases).all()

    # Пример запроса с фильтрацией
    emp_seniors = session.query(Employees).filter(Employees.position == "TechSenior").all()

    # Пример объединения  
    results = session.query(Bases, Equipment).join(Equipment, Bases.baseId == Equipment.baseId).all()  
    for base, equip in results:  
        print(f"{base.baseName} has equipment {equip.type}")  

    # Получить первых 5 сотрудников
    first_five_employees = session.query(Employees).limit(5).all()  
    print(first_five_employees)  

    # Количество баз  
    total_bases = session.query(Bases).count()  
    print(f"Total bases: {total_bases}")  

# TODO: Задача 2: Работа с XML/JSON
def write_to_json():  
    tasks = session.query(Tasks).all()  
    tasks_list = [{"taskId": task.taskId, "taskName": task.taskName} for task in tasks]  
    
    # Запись в JSON  
    with open('tasks.json', 'w') as json_file:  
        json.dump(tasks_list, json_file)  

def read_from_json():  
    try:  
        with open('tasks.json', 'r') as json_file:  
            tasks = json.load(json_file)  
            for task in tasks:  
                print(task)  
    except FileNotFoundError:  
        print("Файл tasks.json не найден.")  

def update_json():  
    try:  
        with open('tasks.json', 'r') as json_file:  
            tasks = json.load(json_file)  

        if not tasks:  
            print("Список задач пуст, ничего не нужно обновлять.")  
            return  

        # Обновляем 1-й элемент  
        tasks[0]['taskName'] = 'Updated Task Name'  

        with open('tasks.json', 'w') as json_file:  
            json.dump(tasks, json_file)  
    except FileNotFoundError:  
        print("Файл tasks.json не найден.")  
    except IndexError:  
        print("Список задач пуст.")  

# TODO: Задача 3: LINQ to SQL
def query_entities():  
    # Однотабличный запрос  
    employees = session.query(Employees).all()  

    # Многотабличный запрос  
    query = session.query(Employees).join(EmployeeTask).filter(EmployeeTask.ifLeader == True)  
    leaders = query.all()  

    # Добавление, обновление, удаление  
    new_employee = Employees(firstName="John", lastName="Doe", studyGroup="A1", phoneNumber="123456789", position="TechJunior")  
    session.add(new_employee)      # Добавление  
    session.commit()  

    updated_employee = session.query(Employees).filter(Employees.employeeId == new_employee.employeeId).first()  
    updated_employee.position = "TechSenior"  # Обновление  
    session.commit()  

    session.delete(updated_employee)  # Удаление  
    session.commit()

def add_wrong_employee():
    try:
        new_employee = Employees(
            firstName="John",
            lastName="Doe",
            studyGroup="SG1",
            phoneNumber="123-456-7890",
            position="TechJunior"
        )
        session.add(new_employee)
        session.commit()
        print("Employee added successfully.")
    except Exception as e:
        print(f"Error adding employee: {e}")
        session.rollback()