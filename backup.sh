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
  if [ "$frequency" == "daily" ]; then
    rsync -a --delete --exclude=*.sh --exclude=README.md --exclude=.git ./ root@192.168.81.136:~/.backups
  fi
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

# m h  dom mon dow   command
# Запускатиметься о 00:15 годин 1 числа кожного місяця.
# 15 0 1 * * sh /root/.backups/backup.sh monthly

# Запускатиметься о 00:25 годин щонеділі (день тижня 0 в cron означає неділю).
# 25 0 * * 0 sh /root/.backups/backup.sh weekly

# Запускатиметься о 00:35 кожного дня.
# 35 0 * * * sh /root/.backups/backup.sh daily
