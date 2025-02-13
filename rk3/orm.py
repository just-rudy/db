from sqlalchemy import create_engine, Column, Integer, String, Date, Time, ForeignKey, CheckConstraint, extract
from sqlalchemy.orm import declarative_base, sessionmaker
from datetime import date

Base = declarative_base()

class Satellite(Base):
    __tablename__ = 'satellite'

    id = Column(Integer, primary_key=True, autoincrement=True)
    satname = Column(String, nullable=False)
    bday = Column(Date, nullable=False)
    origin = Column(String, nullable=False)


class Flight(Base):
    __tablename__ = 'flight'

    flightid = Column(Integer, primary_key=True, autoincrement=True)
    satID = Column(Integer, ForeignKey('satellite.id'), nullable=False)
    launchdate = Column(Date, nullable=False)
    launchtime = Column(Time, nullable=False)
    weekday = Column(String, nullable=False)
    type = Column(Integer, nullable=False)

    __table_args__ = (
        CheckConstraint(type.in_([0, 1])),
        CheckConstraint(
            weekday.in_(['Понедельник', 'Вторник', 'Среда', 'Четверг', 'Пятница', 'Суббота', 'Воскресенье'])),
    )


# Создание соединения с базой данных
engine = create_engine('postgresql://postgres:password@localhost:5432/postgres')
Base.metadata.create_all(engine)

Session = sessionmaker(bind=engine)
session = Session()

# Запрос 1: Найти самый новый спутник в Китае
newest_satellite = session.query(Satellite).filter(Satellite.origin == 'Китай').order_by(Satellite.bday.desc()).first()
print(f"Самый новый спутник в Китае: {newest_satellite.satname} (дата: {newest_satellite.bday})")

# Запрос 2: Найти спутник, который в этом году был отправлен раньше всех
earliest_launch = session.query(Flight).filter(extract('year', Flight.launchdate) == date.today().year).order_by(
    Flight.launchdate).first()
if earliest_launch:
    satellite = session.query(Satellite).filter(Satellite.id == earliest_launch.satID).first()
    print(
        f"Спутник, который в этом году был отправлен раньше всех: {satellite.satname} (дата запуска: {earliest_launch.launchdate})")
else:
    print("Нет запусков спутников в этом году.")

# Запрос 3: Найти все страны, в которых есть хоть один космический аппарат, первый запуск которого был после 2024-10-01
countries_with_recent_launches = session.query(Satellite.origin).join(Flight).filter(
    Flight.launchdate > '2024-10-01').distinct().all()
countries = [country[0] for country in countries_with_recent_launches]
print(f"Страны с запуском после 2024-10-01: {countries}")
