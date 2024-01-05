#!/bin/bash

# Функція для створення резервної копії
function backup() {
  # Визначаємо частоту резервної копії
  frequency="$1"

  # Визначаємо дату та час резервної копії
  date=$(date +"%d-%m-%Y_%H-%M-%S")

  # Створюємо папку резервної копії, якщо вона не існує
  mkdir -p ~/.backups/project_name/${frequency}
  mkdir -p ~/.backups/project_name1/${frequency}
  mkdir -p ~/.backups/project_name2/${frequency}

  # Створюємо резервну копію
  tar -zcf ~/.backups/project_name/${frequency}/backup-${date}.tar.gz -C /home/a3888s/code/ project
  tar -zcf ~/.backups/project_name1/${frequency}/backup-${date}.tar.gz -C /home/a3888s/code/ project
  tar -zcf ~/.backups/project_name2/${frequency}/backup-${date}.tar.gz -C /home/a3888s/code/ project

  # Відправляємо резервну копію на інший сервер
  rsync -a --delete --exclude=*.sh --exclude=README.md --exclude=.git ./ root@192.168.81.136:~/.backups
}

# Створюємо резервну копію щодня
backup daily

# Створюємо резервну копію щотижня
backup weekly

# Створюємо резервну копію щомісяця
backup monthly

# Видаляємо резервні копії, які старші ніж 1 днів
find ~/.backups/project_name/* -mtime +1 -delete

# Приклад того, як ви налаштувати cron-графік для цього скрипта:
# 0 0 * * * sh /root/.backups/backup.sh daily
# 0 0 * * 0 sh /root/.backups/backup.sh weekly
# 0 0 1 * * sh /root/.backups/backup.sh monthly
# Цей графік запускає скрипт backup.sh щодня о 00:00, щотижня о 00:00 у неділю
# та щомісяця о 00:00 1-го числа.
