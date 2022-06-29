#!/bin/sh

## Cria o named pipe
mkfifo myqueue

echo "Waiting for jobs in the queue..."

## Loop infinito
while true
do
  ## Bloqueia à espera de mensagem no pipe
  ENCODED=`cat myqueue`

  ## Nova mensagem chegou no pipe...
  echo "[`date`] Encoded: $ENCODED | Decoded: `echo $ENCODED | base64 -d`"
done
