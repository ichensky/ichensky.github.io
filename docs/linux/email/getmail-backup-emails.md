# `getmail` - backup emails 

* Install
```sh
$ apt install getmail
```

* Create config .getmail/getmailrc

* For gmail use https://myaccount.google.com/lesssecureapps?pli=1
```ini
[options]
delete = False

[retriever]
type = SimpleIMAPSSLRetriever
server = outlook.office365.com
username = user_name@outlook.com
password = ***

[destination]
type = Maildir
path = ~/tmp/

```
