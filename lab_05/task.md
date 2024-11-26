# Лабораторная работа № 5
## Использование XML/JSON с базами данных
Целью лабораторной работы является приобретение практических навыков
использования языка запросов для обработки данных в формате XML или JSON
на примере реляционных таблиц, содержащих столбец типа xml или json (jsonb)

### Задание
1. Из таблиц базы данных, созданной в первой лабораторной работе, извлечь
данные в XML (MSSQL) или JSON(Oracle, Postgres). Для выгрузки в XML
проверить все режимы конструкции FOR XML
2. Выполнить загрузку и сохранение XML или JSON файла в таблицу.
Созданная таблица после всех манипуляций должна соответствовать таблице
базы данных, созданной в первой лабораторной работе.
3. Создать таблицу, в которой будет атрибут(-ы) с типом XML или JSON, или
добавить атрибут с типом XML или JSON к уже существующей таблице.
Заполнить атрибут правдоподобными данными с помощью команд INSERT
или UPDATE.
4. Выполнить следующие действия:
   * Извлечь XML/JSON фрагмент из XML/JSON документа
   * Извлечь значения конкретных узлов или атрибутов XML/JSON
   документа
   * Выполнить проверку существования узла или атрибута
   * Изменить XML/JSON документ
   * Разделить XML/JSON документ на несколько строк по узлам