# Программа для проверки сроков сдачи отчетности
## Что это?

check.rb - это Ruby скрипт, который помогает вам определить ближайшие дедлайны на основе трех типов:
- Месячный - 10 рабочих дней
- Квартальный - 10 рабочих дней или 30 календарных дней
- Годовой - 10 рабочих дней или 30 календарных дней
Скрипт использует сторонний API для проверки выпадающих праздников в России (https://www.isdayoff.ru/extapi/), чтобы определить количество рабочих дней.
## Установка и использование

Клонируем репозиторий
```bash
  git clone https://gitlab.edu.rnds.pro/573ned/deadline_checker.git
```

Переходим в директорию проекта
```bash
  cd deadline_checker
```

Запускаем
```bash
  ruby check.rb
```

