from sqlalchemy import create_engine, Column, Integer, String, Date, Boolean, ForeignKey, CheckConstraint, UniqueConstraint
from sqlalchemy.orm import declarative_base, relationship

Base = declarative_base()

class Bases(Base):
    __tablename__ = 'Bases'

    baseId = Column(Integer, primary_key=True)
    address = Column(String)
    baseName = Column(String)
    manager = Column(String)
    contact = Column(String)

    __table_args__ = (
        UniqueConstraint('address', 'baseName', name='uq_add_name'),
    )

class Employees(Base):
    __tablename__ = 'Employees'

    employeeId = Column(Integer, primary_key=True)
    firstName = Column(String)
    lastName = Column(String)
    studyGroup = Column(String)
    phoneNumber = Column(String)
    position = Column(String)

    __table_args__ = (
        CheckConstraint("position IN ('TechJunior', 'TechSenior', 'NotTech')", name='check_position'),
    )


class Equipment(Base):
    __tablename__ = 'Equipment'

    equipmentId = Column(Integer, primary_key=True)
    type = Column(String)
    manufacturer = Column(String)
    cnt_all = Column(Integer)
    cnt_in_use = Column(Integer)
    baseId = Column(Integer, ForeignKey('Bases.baseId'))

    __table_args__ = (
        CheckConstraint('cnt_in_use <= cnt_all', name='check_equ'),
        UniqueConstraint('type', 'manufacturer', name='uq_type_man'),
    )


class Tasks(Base):
    __tablename__ = 'Tasks'

    taskId = Column(Integer, primary_key=True)
    taskName = Column(String)
    dateStart = Column(Date)
    duration = Column(Integer)
    baseId = Column(Integer, ForeignKey('Bases.baseId'))

    __table_args__ = (
        CheckConstraint('duration >= 1', name='check_dur'),
    )

class EmployeeTask(Base):
    __tablename__ = 'EmployeeTask'

    empTaskId = Column(Integer, primary_key=True)
    ifLeader = Column(Boolean)
    employeeId = Column(Integer, ForeignKey('Employees.employeeId'))
    taskId = Column(Integer, ForeignKey('Tasks.taskId'))

class EquipmentTask(Base):
    __tablename__ = 'EquipmentTask'

    eqTaskId = Column(Integer, primary_key=True)
    cntUsed = Column(Integer)
    equipmentId = Column(Integer, ForeignKey('Equipment.equipmentId'))
    taskId = Column(Integer, ForeignKey('Tasks.taskId'))