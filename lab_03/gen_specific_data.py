import random
from faker import Faker

fake = Faker()


def rand_study_group():
    facoulties = ['ИУ', 'Л', 'ФН', 'СМ', 'МТ', 'РКТ', 'АК',
                  'РК', 'БМТ', 'ИБМ', 'ПС', 'РЛ', 'РТ', 'Э', 'СГН', 'ЮР']
    groups = ['1', '2', '3', '4', '5', '6',
              '7', '8', '9', '10', '11', '12', '13']
    numbers = ['1', '2', '3', '4', '5', '6', '7', '8']
    study_group = random.choice(
        facoulties) + random.choice(groups) + "-" + random.choice(numbers)
    return study_group


positions = ['TechSenior', 'TechJunior', 'NotTech']

persons = [
    ("Егор", "Клевлин", "РКТ3-31", fake.phone_number(), "TechSenior"),
    ("Антон", "Павленко", "РК6-74Б", fake.phone_number(), "TechJunior"),
    ("Семен", "Носов", "СМ6-59", fake.phone_number(), "TechJunior"),
    ("Дима", "Боднар", "Э4-51", fake.phone_number(), "TechJunior"),
    ("Дашка", "Серышева", "ИУ7-54Б", fake.phone_number(), "TechSenior"),
    ("Дарья", "Горшкова", "РЛ2-71Б", fake.phone_number(), "TechJunior"),
    ("Иракли", "Чкареули", "МТ6-31М", fake.phone_number(), "TechSenior"),
    ("Анастасия", "Лащук", "БМТ4-72", fake.phone_number(), "NotTech"),
    ("Леонид", "Улыбин", "Э4-31", fake.phone_number(), "TechSenior"),
    ("Андрей", "Поляков", "ИУ7-52Б", fake.phone_number(), "TechJunior"),
    ("Дмитрий", "Шахнович", "ИУ7-52Б", fake.phone_number(), "NotTech")
]

manufacturers = [
    'Makita',
    'DeWalt',
    'Bosch',
    'Milwaukee',
    'Ryobi',
    'Hitachi',
    'Black & Decker',
    'Ridgid',
    'Craftsman',
    'Porter-Cable',
    'Hilti',
    'Festool',
    'Metabo',
    'Skil',
    'Kobalt',
    'Husky',
    'Fiskars',
    'Stanley',
    'Snap-on',
    'Irwin',
    'самодельный'
]

tools = [
    'лопата',
    'молоток',
    'лобзик',
    'УШМ',
    'дрель',
    'шуруповерт',
    'пила',
    'рубанок',
    'стамеска',
    'гвоздодер',
    'плоскогубцы',
    'отвертка',
    'рулетка',
    'уровень',
    'кувалда',
    'гайковерт',
    'болторез',
    'ножовка',
    'шлифовальная машина',
    'паяльник',
    'перфоратор',
    'сверло',
    'фрезер',
    'зубило',
    'гаечный ключ',
    'газовый ключ',
    'стриппер',
    'биты для шуруповерта',
    'набо трещеток',
    'штангенциркуль',
    'габельцы',
    'стриппер',
    'кримпер',
    'бокорезы',
    'плоскогубцы',
    'индикатор напряжения',
    'измерительные клещи',
    'обжимной инструмент',
    'изолента',
    'кабельный нож',
    'мультиметр',
    'пробник',
    'топор',
    'колун',
    'грабли',
    'трубы',
    'диэлектрические отвертки'
]


sawblades = [
    ['бензопила', 'Husqvarna'],
    ['бензопила', 'Stihl'],
    ['бензопила', 'Echo'],
    ['бензопила', 'Makita'],
    ['бензопила', 'Poulan Pro'],
    ['бензопила', 'Jonsered'],
    ['бензопила', 'McCulloch'],
    ['бензопила', 'Craftsman'],
    ['бензопила', 'Dolmar'],
    ['бензопила', 'Remington'],
    ['бензопила', 'Greenworks'],
    ['бензопила', 'Oregon'],
    ['бензопила', 'Tanaka'],
    ['бензопила', 'Ryobi'],
    ['бензопила', 'Redmax'],
    ['бензопила', 'Solo'],
    ['бензопила', 'Hitachi'],
    ['бензопила', 'Bosch'],
    ['бензопила', 'ParkerBrand'],
    ['бензопила', 'Hyundai']
]



eq_piece = [[tool, man] for tool in tools for man in manufacturers] + sawblades
random.shuffle(eq_piece)