#!/usr/bin/env sh
#----------------------------------------------------------------------------#
# Notificação do pushover https://pushover.net/
# No computador e celular (android/iphone)
#----------------------------------------------------------------------------#
set -e
#----------------------------------------------------------------------------#
# Configuração da API
#----------------------------------------------------------------------------#
# Seu User Token
api_user=''
# Api token aqui caso execute apenas um servidor/serviço!
api_token=''
# Url pushover API (NÃO EDITE)
api_url='https://api.pushover.net/1/messages.json'
# Dispositivos (Android/Iphone/computador/tablet)
devices=""

#----------------------------------------------------------------------------#
# Funções
#----------------------------------------------------------------------------#
usage() {
    message="$1"
	echo $(basename "$0"): ERRO: "$@" 1>&2
 	echo "Modo de uso: "
	echo " -t \"Api token aqui\""
	echo " -m \"mensagem aqui\""
	echo " -t \"titulo da mensagem aqui\""
	echo " -d \"device1,device2,device3\""
	exit 1
}

noarg()
{
    # Vefifica se começa com -
    verify="$1"
    if echo "$verify" | grep -q "^-.*"; then
        usage
    fi
}

#----------------------------------------------------------------------------#
# Testes
#----------------------------------------------------------------------------#
if [ $# -eq 0 ]; then
    usage "Você precisa fornecer algum parametro."
fi

while [ $# -gt 0 ]; do
    case "$1" in
        -t) # Api token
            shift
            if [ -n $1 ]; then
                api_token="$1"
            fi
        ;;
        -d) # Dispositivo
            shift
            if [ -z "$1" ]; then
                device="$devices"
            else
                device="$1"
            fi
        ;;
        -m) # Mensagem
            shift
            noarg "$1"
            if [ -z "$1" ]; then
                usage
            fi
            message="$1"
        ;;
        -t) # Titulo
            shift
            noarg "$1"
            if [ -z "$1" ]; then
                usage "Need title!"
            fi
            title="$1"
        ;;
        *) usage ;;
    esac
    shift
done

# Fazendo requisição para API do pushover
curl -s                               \
    --form-string "token=$api_token"  \
    --form-string "user=$api_user"    \
    --form-string "device=$device"    \
    --form-string "title=$title"      \
    --form-string "message=$message"  \
    "$api_url"
