import json
import os
import time
import datetime
import random
import psycopg2  # For PostgreSQL
from faker import Faker
from xtra import rand_study_group

db_params = {
    "host": "localhost",
    "port": 5432,
    "database": "postgres",
    "user": "postgres",
    "password": "password"
}

fake = Faker()
base_ids = []


def generate_data(table_name):
    global base_ids
    num_records = random.randint(1, 5)
    data = []
    for _ in range(num_records):
        if table_name == "Bases":
            if len(base_ids) == 0:
                base_ids = [1]
            else:
                base_ids += [base_ids[-1]+1]
            data.append({
                "adress": fake.street_address(),
                "baseName": fake.company(),
                "manager": f"{fake.first_name()} {fake.last_name()}",
                "contact": fake.phone_number()
            })
        elif table_name == "Employees":
            data.append({
                "firstName": fake.first_name(),
                "lastName": fake.last_name(),
                "studyGroup": rand_study_group(),
                "phoneNumber": fake.phone_number(),
                "position": random.choice(["TechSenior", "TechJunior", "NotTech"])
            })
        elif table_name == "Equipment":
            data.append({
                "type": fake.word(),  # Random equipment type
                "manufacturer": fake.company(),
                "cntAll": random.randint(1, 20),
                "cntInUse": random.randint(0, 10),  # Ensure cntInUse <= cntAll
                "baseId": random.choice(base_ids)
            })
        elif table_name == "Tasks":
            start_date = fake.date_between(start_date='-30d', end_date='+30d')  # Dates within +/- 30 days
            data.append({
               "taskName": fake.sentence(),
               "dateStart": start_date.strftime('%Y-%m-%d'), # Format date for database
               "duration": random.randint(1, 30),
                "baseId": random.choice(base_ids)
            })
        elif table_name == "EmployeeTask":  # Generate EmployeeTask data
            data.append({
                "ifLeader": random.choice([True, False]),
                "employeeId": random.randint(1, 10),  # Get actual employee and task IDs!
                "taskId": random.randint(1, 10)
            })
        elif table_name == "EquipmentTask":  # Generate EquipmentTask data
            data.append({
                "cntUsed": random.randint(1, 5),
                "equipmentId": random.randint(1, 10),  # Get actual equipment and task IDs!
                "taskId": random.randint(1, 10)
            })

    return data


def save_data(data, table_name, file_id):
    """Saves the data to a file in JSON, XML, or CSV format."""
    timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    filename = f"{file_id}_{table_name}_{timestamp}.json" # Or .xml or .csv
    filepath = os.path.join("output_files", filename) # Store in a dedicated directory

    if not os.path.exists("output_files"):
        os.makedirs("output_files")

    with open(filepath, 'w') as f:
        if filename.endswith(".json"):
           json.dump(data, f, indent=4)

def main():
    file_id = 0
    for i in range(3):
        for table_name in ["Bases", "Employees", "Equipment", "Tasks", "EmployeeTask", "EquipmentTask"]:
            data = generate_data(table_name)
            save_data(data, table_name, file_id)
            file_id += 1

            time.sleep(300)



if __name__ == "__main__":
    main()



