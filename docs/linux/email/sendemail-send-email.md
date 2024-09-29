# `sendmail` - send email

```sh
#!/bin/sh

SERVER="smtp.office365.com:587"
FROM="xxx@outlook.com"
TO="yyyy@live.com"
SUBJ="subject ..."
USERNAME="xxx@outlook.com"
PASSWORD="***"

echo "msg ..." | sendemail -f $FROM -t $TO -u $SUBJ -s $SERVER -v -xu $USERNAME -xp $PASSWORD -o message-charset="utf-8"
```