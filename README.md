# Demo devops

В репозитории находится код для развертывания инфраструктуры с использованием Terraform (Yandex Cloud), Ansible и CI/CD для Django-приложения.

## Содержание

- [Описание проекта](#описание-проекта)
- [Требования](#требования)
- [Быстрый старт](#быстрый-старт)
- [Yandex Infrastructure](#yandex-infrastructure)
- [Ansible Playbook](#ansible-playbook)
- [Vagrant and Proxmox Infrastructure](#vagrant-infrastructure)

## Описание проекта

Проект демонстрирует полный цикл DevOps практик с автоматизацией инфраструктуры и развертывания приложений:

- **Инфраструктура как код**: Terraform для создания ресурсов в Yandex Cloud
- **Управление конфигурацией**: Ansible для настройки серверов
- **CI/CD**: GitLab pipeline для автоматического развертывания Django-приложения
- **Альтернативная инфраструктура**: Vagrant с Proxmox для локальной разработки

## Требования

### Общие требования
- Git
- SSH ключ для доступа к серверам
- Доступ к интернету

### Для Yandex Infrastructure
- **Terraform** >= 1.0
- **Yandex Cloud CLI** (yc)
- Активный аккаунт **Yandex Cloud**
- Сервисный аккаунт с ролями:
  - `compute.admin`
  - `vpc.admin`
  - `dns.admin`
  - `certificate-manager.admin`

### Для Ansible
- **Ansible** >= 2.9
- **Python** >= 3.8
- SSH доступ к целевым серверам

### Для CI/CD приложения
- **Python** >= 3.8
- **Docker** (для контейнеризации)
- **GitLab** аккаунт

### Для Vagrant (опционально)
- **Vagrant** >= 2.2
- **VirtualBox** или **Proxmox**

## Быстрый старт

### 1. Клонирование репозитория

```bash
git clone https://github.com/filatof/deusops_task01.git
cd deusops_task01
```

### 2. Настройка переменных окружения

Создайте файлы с секретными данными (они должны быть в `.gitignore`):

```bash
# Yandex Cloud
cd yandex_infra
cp key.json.example key.json  # Добавьте ваш сервисный аккаунт
cp storage.key.example storage.key  # Добавьте ключ для Object Storage
```

### 3. Создание инфраструктуры в Yandex Cloud

```bash
cd yandex_infra

# Инициализация Terraform
terraform init

# Проверка плана
terraform plan

# Применение конфигурации
terraform apply
```

После успешного применения Terraform выведет:
- IP адреса созданных серверов
- DNS записи
- Другие важные параметры

### 4. Настройка серверов с помощью Ansible

```bash
cd ../ansible

# Установка зависимостей из Ansible Galaxy
ansible-galaxy install -r requirements.yml

# Проверка доступности хостов
ansible all -m ping

# Запуск playbook
ansible-playbook play.yaml
```

### 5. Развертывание приложения

Приложение автоматически развертывается через GitLab CI/CD при push в репозиторий.

---

## Yandex Infrastructure

### Использование

#### Создание инфраструктуры

```bash
cd yandex_infra
terraform init
terraform plan
terraform apply
```

#### Обновление инфраструктуры

```bash
terraform plan
terraform apply
```

#### Удаление инфраструктуры

```bash
terraform destroy
```

#### Просмотр выходных данных

```bash
terraform output
```

### Основные переменные (variables.tf)

Отредактируйте переменные под свои нужды:

```hcl
variable "cloud_id" {
  description = "Yandex Cloud ID"
  type        = string
}

variable "folder_id" {
  description = "Yandex Cloud Folder ID"
  type        = string
}

variable "zone" {
  description = "Yandex Cloud Zone"
  type        = string
  default     = "ru-central1-a"
}

variable "domain" {
  description = "Domain name"
  type        = string
  default     = "example.com"
}
```

---

## 🔧 Ansible Playbook

### Описание

Ansible playbook настраивает все серверы после их создания в Yandex Cloud.

### Структура

#### ansible.cfg
Основные настройки Ansible:
- Путь к inventory
- SSH параметры
- Плагины и callbacks

#### hosts
Inventory файл с группами хостов:
```ini
[app]
app01 ansible_host=<IP>

[db]
db01 ansible_host=<IP>

[nexus]
nexus01 ansible_host=<IP>

[runner]
runner01 ansible_host=<IP>
```

#### play.yaml
Основной playbook, который:
1. Обновляет систему
2. Устанавливает базовые пакеты
3. Настраивает firewall
4. Применяет роли для каждой группы хостов

#### requirements.yml
Ansible Galaxy зависимости:
```yaml
---
- src: https://github.com/filatof/ansible-role-postgresql.git
  scm: git
  version: main
  name: postgresql

- src: https://github.com/filatof/ansible-role-nexus.git
  scm: git
  version: main
  name: nexus

- src: https://github.com/filatof/ansible-role-runner.git
  scm: git
  version: main
  name: runner

- src: https://github.com/filatof/ansible-role-docker.git
  scm: git
  version: main
  name: docker
```

#### Установка зависимостей

```bash
ansible-galaxy install -r requirements.yml
```

#### Проверка подключения

```bash
ansible all -m ping
```

#### Запуск playbook

```bash
# Полный запуск
ansible-playbook play.yaml

# Dry-run (проверка без изменений)
ansible-playbook play.yaml --check

# Только для определенных хостов
ansible-playbook play.yaml --limit nexus

# С verbose выводом
ansible-playbook play.yaml -v
```

---

## 🐍 CI/CD Demo App

### Описание приложения

Django Girls tutorial - простое blog-приложение для демонстрации:
- Django фреймворк
- CRUD операции
- Шаблоны
- Админ панель
- Docker контейнеризация

### Структура приложения

#### Основные файлы

**manage.py**
- Точка входа Django
- Управление командами

**requirements.txt**
```txt
Django>=3.2,<4.0
gunicorn>=20.1.0
psycopg2-binary>=2.9
```

**dockerfile**
```dockerfile
FROM python:3.10-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

RUN python manage.py collectstatic --noinput

EXPOSE 8000

CMD ["gunicorn", "--bind", "0.0.0.0:8000", "mysite.wsgi:application"]
```

**docker-compose.yaml**
```yaml
version: '3.8'

services:
  web:
    build: .
    ports:
      - "8000:8000"
    environment:
      - DATABASE_URL=postgresql://user:pass@db:5432/blogdb
    depends_on:
      - db
    volumes:
      - ./db:/app/db

  db:
    image: postgres:14
    environment:
      POSTGRES_DB: blogdb
      POSTGRES_USER: user
      POSTGRES_PASSWORD: pass
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  postgres_data:
```

**init.sh**
Скрипт инициализации:
```bash
#!/bin/bash
python manage.py migrate
python manage.py collectstatic --noinput
python manage.py createsuperuser --noinput
```

---

## Vagrant and Proxmox Infrastructure

### Описание

Альтернативная инфраструктура для локальной разработки и тестирования с использованием Vagrant и Proxmox.

### Структура

```
vagrant_infra/
├── vagrantfile              # Vagrant конфигурация
└── ansible_proxmox_infra/
    ├── README.md
    ├── inventory.yml
    ├── group_vars/
    │   └── task1.yml
    └── playbooks/
        ├── create_cluster.yml
        └── tasks/
            └── create_one_lxc.yml
```

### Использование Vagrant

#### Запуск VM

```bash
cd vagrant_infra
vagrant up
```

#### SSH подключение

```bash
vagrant ssh
```

#### Остановка VM

```bash
vagrant halt
```

#### Удаление VM

```bash
vagrant destroy
```

### Ansible для Proxmox

Создание LXC контейнеров в Proxmox:

```bash
cd vagrant_infra/ansible_proxmox_infra

# Создание кластера
ansible-playbook playbooks/create_cluster.yml
```

#### inventory.yml

```yaml
all:
  children:
    task1:
      hosts:
        proxmox01:
          ansible_host: 192.168.1.100
```

#### group_vars/task1.yml

Переменные для создания LXC контейнеров:
- Количество контейнеров
- Ресурсы (CPU, RAM, Disk)
- Network конфигурация
- Template образ

---

## 📄 License

Этот проект лицензирован под MIT License - см. файл [LICENSE](LICENSE) для деталей.

---

## 👤 Автор

**filatof**
- GitHub: [@filatof](https://github.com/filatof)
- Repository: [deusops_task01](https://github.com/filatof/deusops_task01)

---
