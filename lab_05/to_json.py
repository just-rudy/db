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

# run query and save the result
cur.execute("""
    SELECT row_to_json(t)
    FROM Employees t;
""")
rows = cur.fetchall()

# fetch all rows and convert them to a list of dictionaries
with open('data.json', 'w') as file:
    json.dump([row[0] for row in rows], file, indent=4)

conn.close()
