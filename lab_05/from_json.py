import psycopg2
import json

# connecting to the PostgreSQL database
conn = psycopg2.connect(
    dbname="postgres",
    user="postgres",
    password="password",
    host="localhost",
    port="5432"
)
cur = conn.cursor()

# read json data from file
with open('data.json', 'r') as file:
    data = json.load(file)

# load data to table
for employee in data:
    cur.execute("""
        INSERT INTO Employees (FirstName, LastName, StudyGroup, PhoneNumber, Position)
            VALUES (%s, %s, %s, %s, %s)
    """, (employee['firstname'], employee['lastname'], employee['studygroup'], employee['phonenumber'], employee['position']))


conn.commit()
