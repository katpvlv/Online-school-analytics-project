# Проект «‎Аналитика маркетинга онлайн-школы»‎
В рамках проекта были проанализированы данные о рекламных кампаниях, трафике на сайт и продажах онлайн-школы. В итоге проекта были сделаны выводы об окупаемости маркетинговых инвестиций, даны рекомендации по оптимизации сайта и рекламы.


В проекте использованы SQL-запросы для PostgreSQL в редакторе DBeaver. Для визуализации использовался BI-инструмент Apache Superset. Презентация с выводами подготовлена в Google Slides.


Для подключения к БД:
1. Установить [DBeaver](https://dbeaver.io/download/)
2. Выбрать PostgreSQL
3. Создать новое подключение, используя данные:
   * Host: 65.108.223.44 
   * Database: marketingdb 
   * Username: student 
   * Password: student 
   * Port: 5432
  

## Задачи:
1. Создать витрину для модели атрибуции Last Paid Click. [Файл](https://github.com/katpvlv/Online-school-analytics-project/blob/main/last_paid_click.sql) с SQL-запросом (использовано: join, case, оконные функции, подзапросы). Итоговая таблица [last_paid_click.csv](https://github.com/katpvlv/Online-school-analytics-project/blob/main/last_paid_click.csv)
2. Рассчитать расходы на рекламу. [Файл](https://github.com/katpvlv/Online-school-analytics-project/blob/main/aggregate_last_paid_click.sql) с SQL-запросом (использовано: join, case, оконные функции, подзапросы, объединение таблиц). Итоговая таблица [aggregate_last_paid_click.csv](https://github.com/katpvlv/Online-school-analytics-project/blob/main/aggregate_last_paid_click.csv)
3. Создать дашборд в Apache SuperSet с визуализацией данных. [Файл](https://github.com/katpvlv/Online-school-analytics-project/blob/main/dashboard.sql) с дополнительными запросами. [Дашборд](https://a06e77b6.us1a.app.preset.io/superset/dashboard/10/?native_filters_key=OPX5NkIy-hkkX2GelXl-O5VszVgSJy0BpuXkUGG5Wip8Nsjivw1UZhCn6LhLoYDi)
4. Подготовить [презентацию](https://github.com/katpvlv/Online-school-analytics-project/blob/main/Presentation.pdf) в Google Slides с выводами и графиками.
