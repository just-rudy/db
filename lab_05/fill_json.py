import psycopg2
import json
import random
from faker import Faker

fake = Faker()

conn = psycopg2.connect(
    dbname="postgres",
    user="postgres",
    password="password",
    host="localhost",
    port="5432"
)
cur = conn.cursor()

# addr info gen
def generate_random_address():
    address = {
        "street": f"{fake.street_address()}",
        "city": f"{fake.city()}",
    }
    return address

# dog info gen
def generate_dog_info():
    breeds = ["border collie", "golden retriever", "bulldog", "beagle"]
    names = ["loki", "bella", "max", "charlie"]
    if random.choice([True, False]):  # 50% вероятность наличия собаки
        dog_info = {
            "breed": random.choice(breeds),
            "name": random.choice(names)
        }
        return dog_info
    return None


# get all emp id
cur.execute("SELECT employeeId FROM Employees")
employee_ids = cur.fetchall()

# update employee data
for emp_id in employee_ids:
    address = generate_random_address()
    dog_info = generate_dog_info()

    data = {
        "address": address
    }
    if dog_info:
        data["dog"] = dog_info

    cur.execute(
        "UPDATE Employees SET data = %s WHERE employeeId = %s",
        [json.dumps(data), emp_id[0]]
    )

conn.commit()
cur.close()
conn.close()
