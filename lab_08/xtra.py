import random

def rand_study_group():
    facoulties = ['ИУ', 'Л', 'ФН', 'СМ', 'МТ', 'РКТ', 'АК',
                  'РК', 'БМТ', 'ИБМ', 'ПС', 'РЛ', 'РТ', 'Э', 'СГН', 'ЮР']
    groups = ['1', '2', '3', '4', '5', '6',
              '7', '8', '9', '10', '11', '12', '13']
    numbers = ['1', '2', '3', '4', '5', '6', '7', '8']
    study_group = random.choice(
        facoulties) + random.choice(groups) + "-" + random.choice(numbers)
    return study_group