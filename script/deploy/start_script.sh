#!/bin/bash

if ! type getopt >/dev/null 2>&1 ; then
  echo "Error: command \"getopt\" is not found" >&2
  exit 1
fi

getopt_cmd=`getopt -o h -a -l help,mysql-host:,mysql-port:,mysql-user:,mysql-password:,exporter-host:,exporter-port:,exporter-uri: -n "start.sh" -- "$@"`
if [ $? -ne 0 ] ; then
    exit 1
fi
eval set -- "$getopt_cmd"

mysql_host="127.0.0.1"
mysql_port=3306
mysql_user=""
mysql_password=""
exporter_host="127.0.0.1"
exporter_port=9104
exporter_uri="/metrics"

print_help() {
    echo "Usage:"
    echo "    start_script.sh [options]"
    echo "    start_script.sh --mysql-host 127.0.0.1 --mysql-port 3306 --mysql-user root [options]"
    echo ""
    echo "Options:"
    echo "  -h, --help                 show help"
    echo "      --mysql-host           the address of MySQL server (\"127.0.0.1\" by default)"
    echo "      --mysql-port           the port of MySQL server (3306 by default)"
    echo "      --mysql-user           the user to log in to MySQL server"
    echo "      --mysql-password       the password to log in to MySQL server"
    echo "      --exporter-host        the listen address of exporter (\"127.0.0.1\" by default)"
    echo "      --exporter-port        the listen port of exporter (9104 by default)"
    echo "      --exporter-uri         the uri to expose metrics (\"/metrics\" by defualt)"
}

while true
do
    case "$1" in
        -h | --help)
            print_help
            shift 1
            exit 0
            ;;
        --mysql-host)
            case "$2" in
                "")
                    shift 2  
                    ;;
                *)
                    mysql_host="$2"
                    shift 2;
                    ;;
            esac
            ;;
        --mysql-port)
            case "$2" in
                "")
                    shift 2  
                    ;;
                *)
                    mysql_port="$2"
                    shift 2;
                    ;;
            esac
            ;;
        --mysql-user)
            case "$2" in
                "")
                    shift 2  
                    ;;
                *)
                    mysql_user="$2"
                    shift 2;
                    ;;
            esac
            ;;
        --mysql-password)
            case "$2" in
                "")
                    shift 2  
                    ;;
                *)
                    mysql_password="$2"
                    shift 2;
                    ;;
            esac
            ;;
        --exporter-host)
            case "$2" in
                "")
                    shift 2  
                    ;;
                *)
                    exporter_host="$2"
                    shift 2;
                    ;;
            esac
            ;;
        --exporter-port)
            case "$2" in
                "")
                    shift 2  
                    ;;
                *)
                    exporter_port="$2"
                    shift 2;
                    ;;
            esac
            ;;
        --exporter-uri)
            case "$2" in
                "")
                    shift 2  
                    ;;
                *)
                    exporter_uri="$2"
                    shift 2;
                    ;;
            esac
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Error: argument \"$1\" is invalid" >&2
            echo ""
            print_help
            exit 1
            ;;
    esac
done

if [ -f exporter.pid ]; then
    echo "The MySQL exporter has already started."
    exit 0
fi

chmod +x ./src/mysqld_exporter

DATA_SOURCE_NAME="$mysql_user:$mysql_password@($mysql_host:$mysql_port)/" ./src/mysqld_exporter --web.listen-address=$exporter_host:$exporter_port --web.telemetry-path=$exporter_uri &

echo $! > exporter.pid
