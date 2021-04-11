# flumen_passwd

Implements PBKDF2 algorithm for securely hashing passwords.

Usage:

```
var generator = PBKDF2();
var salt = Salt.generateAsBase64String();
var hash = generator.generateKey("mytopsecretpassword", salt, 1000, 32);
```


