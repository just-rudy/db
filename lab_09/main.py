import redis
from query import get_top_equipment_usage, insert_some_data, delete_some_data, update_some_data
import time
import matplotlib.pyplot as plt
import matplotlib.dates as mdates
import numpy as np
import datetime as dt
import psycopg2

def gen_graph_data(time_redis, time_sql):
    num_points = len(time_redis)
    base = dt.datetime.now()
    dates = [base + dt.timedelta(seconds=x) for x in range(num_points)]
    x_axis = [mdates.date2num(d) for d in dates] # Преобразуем даты в числовой формат для matplotlib


    # Создаем фигуру и оси
    fig, ax = plt.subplots(figsize=(10, 6))


    # Строим график для Redis
    ax.plot(x_axis, time_redis, label='Redis', marker='o')

    # Строим график для SQL
    ax.plot(x_axis, time_sql, label='SQL', marker='x')



    # Настройка осей и заголовка
    formatter = mdates.DateFormatter('%H:%M:%S') # Формат времени на оси X
    ax.xaxis.set_major_formatter(formatter)
    plt.xlabel('Время')
    plt.ylabel('Время выполнения (секунды)')
    plt.title('Сравнение времени выполнения Redis и SQL')
    plt.xticks(rotation=45)
    ax.legend() #  Добавить легенду
    plt.grid(True)  # Добавить сетку

    # Отображаем графики
    plt.tight_layout() #  Чтобы подписи не перекрывались
    plt.show()

r = redis.Redis(host='localhost', port=6379, decode_responses=True)

try:
    pong = r.ping()
    if pong:
        print("Подключение к Redis успешно!")
except redis.exceptions.ConnectionError as e:
    print(f"Ошибка подключения: {e}")

conn = psycopg2.connect(
    dbname="postgres",
    user="postgres",
    password="password",
    host="localhost",
    port="5432"
)
cur = conn.cursor()

json_red = get_top_equipment_usage(cur)

cur.close()
conn.close()

const_key = 'top_ten_tool'
r.setex(const_key, 10, json_red)
print("Данные сохранены в Redis.")

time_redis = []
time_sql = []

for i in range(10):

    if i % 2 == 0:
        # insert_some_data()
        # delete_some_data()
        # update_some_data()
        print("upd")


    conn = psycopg2.connect(
        dbname="postgres",
        user="postgres",
        password="password",
        host="localhost",
        port="5432"
    )
    cur = conn.cursor()

    start_time = time.time()
    json_red = get_top_equipment_usage(cur)
    end_time = time.time() - start_time
    time_sql.append(end_time)

    start_time = time.time()
    if (res := r.get(const_key)) is not None:
        end_time = time.time() - start_time
        time_redis.append(end_time)
        # print("if")
    else:
        json_red = get_top_equipment_usage(cur)
        r.setex(const_key, 10, json_red)
        end_time = time.time() - start_time
        time_redis.append(end_time)

    time.sleep(5)

    cur.close()
    conn.close()

# print(time_sql)
# print(time_redis)

gen_graph_data(time_redis, time_sql)