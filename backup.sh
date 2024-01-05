#!/bin/bash

# Функція для створення резервної копії
function backup() {
  # Визначаємо частоту резервної копії
  frequency="$1"

  # Визначаємо дату та час резервної копії
  date=$(date +"%d-%m-%Y_%H-%M-%S")

  # Створюємо папку резервної копії для 1 проекту, якщо вона не існує
  backup_folder=~/.backups/project_name/${frequency}
  mkdir -p "$backup_folder"
  # Створюємо резервну копію
  tar -zcf "$backup_folder"/backup-"${date}".tar.gz -C /home/a3888s/code/ project
  # Видаляємо файли, які старші за 1 день
  find "$backup_folder" -type f -mtime +1 -delete

  # Створюємо папку резервної копії для 2 проекту, якщо вона не існує
  backup_folder1=~/.backups/project_name1/${frequency}
  mkdir -p "$backup_folder1"
  # Створюємо резервну копію
  tar -zcf "$backup_folder1"/backup-"${date}".tar.gz -C /home/a3888s/code/ project
  # Видаляємо файли, які старші за 1 день
  find "$backup_folder1" -type f -mtime +1 -delete

  # Відправляємо резервну копію на інший сервер
  rsync -a --delete --exclude=*.sh --exclude=README.md --exclude=.git ./ root@192.168.81.136:~/.backups
}

# Визначаємо частоту резервної копії
frequency="$1"

# Перевіряємо частоту та викликаємо функцію
case "$frequency" in
  daily)
    backup daily
    ;;
  weekly)
    backup weekly
    ;;
  monthly)
    backup monthly
    ;;
  *)
    echo "Невірна частота. Використовуйте: daily, weekly або monthly."
    exit 1
    ;;
esac

# Приклад того, як ви налаштувати cron-графік для цього скрипта:
# 0 0 * * * sh /root/.backups/backup.sh daily
# 0 0 * * 0 sh /root/.backups/backup.sh weekly
# 0 0 1 * * sh /root/.backups/backup.sh monthly
# Цей графік запускає скрипт backup.sh щодня о 00:00, щотижня о 00:00 у неділю
# та щомісяця о 00:00 1-го числа.
