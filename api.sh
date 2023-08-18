#!/bin/bash

rand-str()
{
    # Return random alpha-numeric string of given LENGTH
    #
    # Usage: VALUE=$(rand-str $LENGTH)
    #    or: VALUE=$(rand-str)

    local DEFAULT_LENGTH=64
    local LENGTH=${1:-$DEFAULT_LENGTH}

    LC_CTYPE=C  tr -dc A-Za-z0-9 </dev/urandom | head -c $LENGTH
    # -dc: delete complementary set == delete all except given set
}


clear
msg=$(cat << "EOF"
  _   _            _                _____ _   _           
 | | | | __ _  ___| | _____  ___   | ____| |_(_) ___ ___  
 | |_| |/ _` |/ __| |/ / _ \/ _ \  |  _| | __| |/ __/ _ \ 
 |  _  | (_| | (__|   <  __/ (_) | | |___| |_| | (_| (_) |
 |_| |_|\__,_|\___|_|\_\___|\___/  |_____|\__|_|\___\___/ 
                                                           
EOF
)

tput setaf 128;
printf "$msg"
tput setaf 7;

printf "\n\n\n¡Bienvenido! 🍷🗿  \n\n"
printf "   🧒 By: $(tput setaf 128)@cflarios$(tput setaf 7)\n"
printf "   📅 Date: $(tput setaf 128)17/08/2023$(tput setaf 7)\n\n"

read -p "Presiona [enter] para continuar..."                                                                                                                                                                                                                

clear 


## ______________________________
#Superadmin?

printf "\n\n👥 ¿Necesitas ejecutar con permisos de administrador? (Solo para Linux) \n\n"

PS3='   Superadmin?: '
options=("Sí" "No")
select optio in "${options[@]}"
do
    case $REPLY in
        "1")
            echo "         Superadmin? ► ${character} ✅" && SUPERADMIN="sudo" && NOTIF_SUPERADMIN="Sí"
            break
            ;;
        "2")
            echo "         Superadmin? ► ${character} ❎" && SUPERADMIN="" && NOTIF_SUPERADMIN="No"
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done

sleep 2

clear

# Función para ejecutar un contenedor
run_node_basic_container() {
    sleep 2
    clear
    printf "\n\n🐋 Ejecutando el contenedor $1...\n\n"
    CONTAINER_NODE_BASIC_ID=$($SUPERADMIN docker run --name node_basic -d -p 3000:3000 $1)
    sleep 1
    $SUPERADMIN docker logs $CONTAINER_NODE_BASIC_ID
    sleep 3
    printf "\n\nPublicando datos...\n\n"
    curl -X POST -H "Content-Type: application/json" -d '{"task": "Hacer compras"}' http://localhost:3000/data
    sleep 3
    printf "\n\nObteniendo datos...\n\n"
    curl http://localhost:3000/data
    sleep 3
    printf "\n\nEliminando datos...\n\n"
    curl -X DELETE http://localhost:3000/data/0
    curl -X GET http://localhost:3000/data
    sleep 3
    clear
    printf "\n\n🛑 Deteniendo el contenedor $1...\n\n"
    $SUPERADMIN docker stop $CONTAINER_NODE_BASIC_ID
    sleep 1
    printf "\n\n☠️  Eliminando el contenedor $1...\n\n"
    $SUPERADMIN docker rm $CONTAINER_NODE_BASIC_ID
    sleep 1
    printf "\n\n🫡  Eliminando el imagen $1...\n\n"
    $SUPERADMIN docker rmi $1
    sleep 1
}

run_python_basic_container() {
    sleep 2
    clear
    printf "\n\n🐋 Ejecutando el contenedor $1...\n\n"
    CONTAINER_PYTHON_BASIC_ID=$($SUPERADMIN docker run --name python_basic -d -p 5000:5000 $1)
    sleep 1
    $SUPERADMIN docker logs $CONTAINER_PYTHON_BASIC_ID
    sleep 3
    printf "\n\nPublicando datos...\n\n"
    curl -X POST -H "Content-Type: application/json" -d '{"task": "Hacer compras"}' http://localhost:5000/data
    sleep 3
    printf "\n\nObteniendo datos...\n\n"
    curl http://localhost:5000/data
    sleep 3
    printf "\n\nEliminando datos...\n\n"
    curl -X DELETE http://localhost:5000/data/0
    curl -X GET http://localhost:5000/data
    sleep 3
    clear
    printf "\n\n🛑 Deteniendo el contenedor $1...\n\n"
    $SUPERADMIN docker stop $CONTAINER_PYTHON_BASIC_ID
    sleep 1
    printf "\n\n☠️  Eliminando el contenedor $1...\n\n"
    $SUPERADMIN docker rm $CONTAINER_PYTHON_BASIC_ID
    sleep 1
    printf "\n\n🫡  Eliminando el imagen $1...\n\n"
    $SUPERADMIN docker rmi $1
    sleep 1
}

run_node_ssl_container() {
    sleep 2
    clear
    printf "\n\n🐋 Ejecutando el contenedor $1...\n\n"
    CONTAINER_NODE_SSL_ID=$($SUPERADMIN docker run --name node_ssl -d -p 4433:4433 $1)
    sleep 1
    $SUPERADMIN docker logs $CONTAINER_NODE_SSL_ID
    sleep 3
    printf "\n\nValidando cliente N°1...\n\n"
    cd ./tls-api/nodejs/
    npm run valid-client
    printf "\n\nCliente válido ✅\n\n"
    sleep 5
    printf "\n\nValidando cliente N°2...\n\n"
    npm run invalid-client
    printf "\n\nCliente inválido ❌\n\n"
    sleep 3
    clear
    printf "\n\n🛑 Deteniendo el contenedor $1...\n\n"
    $SUPERADMIN docker stop $CONTAINER_NODE_SSL_ID
    sleep 1
    printf "\n\n☠️  Eliminando el contenedor $1...\n\n"
    $SUPERADMIN docker rm $CONTAINER_NODE_SSL_ID
    sleep 1
    printf "\n\n🫡  Eliminando el imagen $1...\n\n"
    $SUPERADMIN docker rmi $1
    sleep 1
}

run_python_ssl_container() {
    sleep 2
    clear
    printf "\n\n🐋 Ejecutando el contenedor $1...\n\n"
    CONTAINER_PYTHON_SSL_ID=$($SUPERADMIN docker run --name python_ssl -d -p 4443:4443 $1)
    sleep 1
    $SUPERADMIN docker logs $CONTAINER_PYTHON_SSL_ID
    sleep 3
    printf "\n\nHaciendo prueba cliente-servidor...\n\n"
    local __PYTHON_BUILD=$PYTHON_SSL_BUILD

    if [[ "$__PYTHON_BUILD" == 1 ]]; then
            cd .
    else
            cd ./tls-api/python/
    fi

    python3 client.py
    sleep 3
    printf "\n\nCliente válido ✅\n\n"
    sleep 2
    clear
    printf "\n\n🛑 Deteniendo el contenedor $1...\n\n"
    $SUPERADMIN docker stop $CONTAINER_PYTHON_SSL_ID
    sleep 1
    printf "\n\n☠️  Eliminando el contenedor $1...\n\n"
    $SUPERADMIN docker rm $CONTAINER_PYTHON_SSL_ID
    sleep 1
    printf "\n\n🫡  Eliminando la imagen $1...\n\n"
    $SUPERADMIN docker rmi $1
    sleep 1
}

# Función para construir una imagen
build_node_ssl_image() {
    sleep 2
    clear
    printf "\n\n🐋 Construyendo la imagen $1...\n\n"
    cd ./tls-api/nodejs/
    $SUPERADMIN docker build -t $1 .
    sleep 3
}

build_python_ssl_image() {
    sleep 2
    PYTHON_SSL_BUILD=1
    clear
    printf "\n\n🐋 Construyendo la imagen $1...\n\n"
    cd ./tls-api/python/
    $SUPERADMIN docker build -t $1 .
    sleep 3
}

build_node_basic_image() {
    sleep 2
    clear
    printf "\n\n🐋 Construyendo la imagen $1...\n\n"
    cd ./non-tls-api/nodejs/
    $SUPERADMIN docker build -t $1 .
    sleep 3
}

build_python_basic_image() {
    sleep 2
    clear
    printf "\n\n🐋 Construyendo la imagen $1...\n\n"
    cd ./non-tls-api/python/
    $SUPERADMIN docker build -t $1 .
    sleep 3
}

no_build(){
    BUILD=1
    sleep 2
    clear
    printf "\n\n🚫 Sin imagen no hay aplicación, vuelve ejecutar el script o construye las imágenes a mano 🚫\n\n"
    sleep 2
    printf "\n\n🗨️  En caso de que quieras hacerlo a mano, puedes leer los 'README.md' que se encuentran en cada carpeta. \n\n"
    sleep 2
}

## ______________________________
#SSL?
printf "\n\n🔐 ¿Quieres que la API use certificados SSL? \n\n"
printf "   Si tu respuesta es 'SÍ', selecciona '1'. \n"
printf "   Si tu respuesta es 'No', selecciona '2'. \n\n"

PS3='   SSL?: '
options=("Con SSL" "Sin SSL")
select opt in "${options[@]}"
do
    case $REPLY in
        "1")
            echo "         SSL? ► ${character} ✅" && NOTIF_SSL="Sí"
            break
            ;;
        "2")
            echo "         SSL? ► ${character} ❎" && NOTIF_SSL="No"
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done

SSL=$REPLY

sleep 2

clear

## ______________________________
#Nodejs or Python?
printf "\n\n💻 ¿Cuál framework? ¿Node.js o Python? \n\n"
printf "   Si tu respuesta es 'Node.js', selecciona '1'. \n"
printf "   Si tu respuesta es 'Python', selecciona '2'. \n\n"

PS3='   Node.js o Python?: '
fr_options=("Node.js" "Python")

if [[ $SSL -eq 1 ]]
    then
        select opti in "${fr_options[@]}"
        do
            case $REPLY in
                "1")
                    echo "         Node.js? ► ${character} 📌" && NODE_CONTAINER=1 && PYTHON_CONTAINER=0
                    break
                    ;;
                "2")
                    echo "         Python? ► ${character} 🐍" && PYTHON_CONTAINER=1 && NODE_CONTAINER=0
                    break
                    ;;
                *) echo "invalid option $REPLY";;
            esac
        done
    else
        printf "\n"
fi

if [[ $SSL -eq 2 ]]
    then
        select opti in "${fr_options[@]}"
        do
            case $REPLY in
                "1")
                    echo "         Node.js? ► ${character} 📌" && NODE_CONTAINER=2 && PYTHON_CONTAINER=0
                    break
                    ;;
                "2")
                    echo "         Python? ► ${character} 🐍" && PYTHON_CONTAINER=2 && NODE_CONTAINER=0
                    break
                    ;;
                *) echo "invalid option $REPLY";;
            esac
        done
    else
        printf "\n"
fi

sleep 2

clear

## ______________________________
#Build image

printf "\n\n🐋 ¿Quieres construir la imagen? \n\n"
printf "   Si tu respuesta es 'SÍ', selecciona '1'. \n"
printf "   Si tu respuesta es 'No', selecciona '2'. \n\n"

PS3='   Construir imagen?: '
options=("Sí" "No")
select opt in "${options[@]}"
do
    case $REPLY in
        "1")
            echo "         Construir imagen? ► ${character} ✅" && NOTIF_BUILD="Sí"

            if [[ $NODE_CONTAINER -eq 1 ]] && [[ $PYTHON_CONTAINER -eq 0 ]]; 
                then
                    build_node_ssl_image node_ssl_api:1.0
            elif [[ $NODE_CONTAINER -eq 2 ]] && [[ $PYTHON_CONTAINER -eq 0 ]]; 
                then
                    build_node_basic_image node_basic_api:1.0
            elif [[ $PYTHON_CONTAINER -eq 1 ]] && [[ $NODE_CONTAINER -eq 0 ]]; 
                then
                    build_python_ssl_image python_ssl_api:1.0
            elif [[ $PYTHON_CONTAINER -eq 2 ]] && [[ $NODE_CONTAINER -eq 0 ]];
                then
                    build_python_basic_image python_basic_api:1.0
            fi
            break
            ;;
        "2")
            echo "         Construir imagen? ► ${character} ❎" && NOTIF_BUILD="No" && PYTHON_SSL_BUILD=0 && BUILD=0 && no_build
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done

sleep 2

clear

## ______________________________
#Run container

if [[ $NODE_CONTAINER -eq 1 ]] && [[ $PYTHON_CONTAINER -eq 0 ]] && [[ $BUILD -eq 0 ]]; 
    then
        run_node_ssl_container node_ssl_api:1.0
elif [[ $NODE_CONTAINER -eq 2 ]] && [[ $PYTHON_CONTAINER -eq 0 ]] && [[ $BUILD -eq 0 ]];
    then
        run_node_basic_container node_basic_api:1.0
fi

if [ $PYTHON_CONTAINER == 1 ] && [ $NODE_CONTAINER == 0 ] && [[ $BUILD -eq 0 ]]; 
    then
        run_python_ssl_container python_ssl_api:1.0
elif [ $PYTHON_CONTAINER == 2 ] && [ $NODE_CONTAINER == 0 ] && [[ $BUILD -eq 0 ]];
    then
        run_python_basic_container python_basic_api:1.0
fi

sleep 2

clear

msg=$(cat << "EOF"
  ____                                      
 |  _ \ ___  ___ _   _ _ __ ___   ___ _ __  
 | |_) / _ \/ __| | | | '_ ` _ \ / _ \ '_ \ 
 |  _ <  __/\__ \ |_| | | | | | |  __/ | | |
 |_| \_\___||___/\__,_|_| |_| |_|\___|_| |_|
EOF
)

tput setaf 128;
printf "$msg"
tput setaf 7;

printf "\n\n\n"

if [ $optio == 1 ]; 
    then
        printf "   🟢 Superadmin?: $(tput setaf 128)${NOTIF_SUPERADMIN}$(tput setaf 7)\n" 
    else
        printf "   🟢 Superadmin?: $(tput setaf 128)${NOTIF_SUPERADMIN}$(tput setaf 7)\n"
fi

printf "   🟢 SSL?: $(tput setaf 128)${NOTIF_SSL}$(tput setaf 7)\n"
printf "   🟢 Node.js o Python?: $(tput setaf 128)${opti}$(tput setaf 7)\n"
printf "   🟢 Construir imagen?: $(tput setaf 128)${NOTIF_BUILD}$(tput setaf 7)\n"

printf "\n\n\n\n";
read -p "Presiona [enter] para finalizar..."
sleep 2

clear