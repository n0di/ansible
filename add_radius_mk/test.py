import hashlib

hash_passwd = hashlib.md5('h200mk'.encode()).hexdigest().upper()


print(hash_passwd)