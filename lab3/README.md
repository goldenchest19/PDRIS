# Ansible 

## Описание

Данный проект реализует инфраструктуру из нескольких контейнеров с помощью **Docker** и автоматизирует их настройку с помощью **Ansible**.

**Цель лабораторной работы** — разработать Ansible playbook с несколькими ролями:
1. Установка и настройка **Nginx** на «чистой машине».
2. Деплой приложения с shell-скриптом его запуска.

Вместо реальных серверов используются **Docker-контейнеры**, объединённые в одну сеть.

Ссылка на репозиторий докер: https://hub.docker.com/repository/docker/kirillignatev21/spring-app/general

## Шаги для воспроизведения проекта 

1. Сборка образа хоста docker <br>
`build -t ubuntu-ssh -f ./dockerfileUbuntu .`
2. Сборка образа для HostMachine <br>
`docker build -t ubuntu-ansible-ssh -f ./dockerfileUbuntuHost .`
3. Проверка работы ansible <br>
`docker run --rm ubuntu-ansible-ssh ansible --version` <br>
Ожидаемый результат
![alt text](pic1.png) <br>
4. Запускаем docker compose, чтобы запустить инфраструктуру <br>
`docker-compose up -d`
5. Убедиться, что контейнеры запущены: <br>
`docker ps`
![alt text](pic2.png)
6. Зайти в консоль для работы с ansible-master <br>
`docker exec -it ansible-control bash`
7. Команда для запуска playbook <br>
`ansible-playbook -i ansible/example.hosts ansible/site.yml` <br>
Результат работы:
![alt text](pic3.png)
8. Для проверки приложения можно открыть в браузере `http://localhost:8080/swagger-ui/index.html#/`
Там откроется web-страница, где можно выполнить CRUD операции, чтобы убедиться в работоспособности приложения 
![alt text](pic4.png)
9. Чтобы убедиться в работоспобности nginx, требуется: 
    1. Подключиться по ssh к серверу `ssh admin@localhost -p 2222` и ввести пароль securepassword
    2. Выполнить CURL запрос 'curl http://localhost'
    3. Результат: <br>
    ![alt text](pic5.png)

