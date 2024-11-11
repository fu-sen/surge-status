#!/bin/sh
TEMPLETE_FILE="README.templete.md"
CHECK_LIST_FILE="check.csv"
README_FILE="README.md"
TIMEOUT_SECONDS=5

STATUS=$(cat <<EOT
|Status|Domain|IP Address|Locaion|
|:-----|-----:|:---------|:------|
EOT
)

while read LINE
do
    DOMAIN=$(echo ${LINE} | cut -d , -f 1)
    IP=$(echo ${LINE} | cut -d , -f 2)
    LOCATE=$(echo ${LINE} | cut -d , -f 3)

    RESPONSE=$(curl -m ${TIMEOUT_SECONDS} -w '%{http_code}' -s -o /dev/null https://${DOMAIN})/

    if [ ${RESPONSE} -eq 200 ]; then
      STATUS=${STATUS}"\n|✅ success|${DOMAIN}|${IP}|${LOCATE}|"
    else
      STATUS=${STATUS}"\n|❌ failed |${DOMAIN}|${IP}|${LOCATE}|"
    fi
    echo "${RESPONSE} - ${DOMAIN} ${IP} ${LOCATE}"
done < ${CHECK_LIST_FILE}

eval "echo \"$(cat "${TEMPLETE_FILE}")\"" > ${README_FILE}
