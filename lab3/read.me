# Сборка образа
docker build -t centos-ssh -f ./dockerfileCentOS .
docker build -t ubuntu-ssh -f ./dockerfileUbuntu .

# Запуск контейнера
docker run -d -p 2222:22 --name ubuntu-ssh-container ubuntu-ssh
docker run -d -p 3333:22 --name centos-ssh-container centos-ssh


# Вход в контейнер 
ssh admin@localhost -p 2222
ssh admin@localhost -p 3333
# Пароль: securepassword

#Сборка образа для HostMachine 
docker build -t ubuntu-ansible-ssh -f ./dockerfileUbuntuHost .

#Проверка работы ansible 
docker run --rm ubuntu-ansible-ssh ansible --version

#docker-compose 
docker-compose up -d 
#тест работы 
docker exec ansible-control ansible --version
docker exec ansible-control ansible -i example.hosts all -m ping
docker exec ansible-control ansible-playbook example.yml -i example.hosts
