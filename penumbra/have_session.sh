while true
do
  HAVE_SESION=`tmux ls | grep penumbra_ceremony`
  echo $HAVE_SESION
  if [[ "$HAVE_SESION" != *"1 windows"* ]]; then
    echo run_session
    tmux new-session -d -s penumbra_ceremony 'pcli ceremony contribute --phase 1 --bid 0penumbra --coordinator-address penumbra1qvqr8cvqyf4pwrl6svw9kj8eypf3fuunrcs83m30zxh57y2ytk94gygmtq5k82cjdq9y3mlaa3fwctwpdjr6fxnwuzrsy4ezm0u2tqpzw0sed82shzcr42sju55en26mavjnw4'
  fi
  sleep 10
  echo $HAVE_SESION
done

tmux new-session -d -s penumbra 'while true; do   HAVE_SESION=`tmux ls | grep penumbra_ceremony`;   echo $HAVE_SESION;   if [[ "$HAVE_SESION" != *"1 windows"* ]]; then     echo run_session;     tmux new-session -d -s penumbra_ceremony 'pcli ceremony contribute --phase 1 --bid 0penumbra --coordinator-address penumbra1qvqr8cvqyf4pwrl6svw9kj8eypf3fuunrcs83m30zxh57y2ytk94gygmtq5k82cjdq9y3mlaa3fwctwpdjr6fxnwuzrsy4ezm0u2tqpzw0sed82shzcr42sju55en26mavjnw4';   fi;   sleep 10;   echo $HAVE_SESION; done'
