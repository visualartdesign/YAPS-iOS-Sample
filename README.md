![My image](http://www.lbergelt.com/application/img/yapp_icon.png)

YAPP-iOS-Sample
===============

## Copyright

* [Lars Bergelt](http://www.lbergelt.com/)
* [Marcel Kussin](http://marcel.kussin.net)

Follow me on twitter to get updated : [@VisualArtDesign](http://www.twitter.com/VisualArtDesign)




#####Create the Push certificates:
#####with password

Export the certificate from the keychain.
Open a terminal and change to the directory where the certificate is located and enter the following:
```
	openssl pkcs12 -in apsCert.p12 -out apns-dev-withPW.pem -nodes -clcerts
```



#####without password
Export the certificate and private key from the keyring.
Open a terminal and change to the directory where the certificate and the key is located and enter the following:
```
	openssl pkcs12 -clcerts -nokeys -out apsCert.pem -in apsCert.p12
	openssl pkcs12 -nocerts -out apsKey.pem -in apsKey.p12
	openssl rsa -in apsKey.pem -out apsKeyWithoutPW.pem
	cat apsCert.pem apsKeyWithoutPW.pem > apns-dev-withoutPW.pem
```
