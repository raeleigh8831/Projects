import secrets
import string

length = 64
chars = string.ascii_letters + string.digits + string.punctuation
key = ''.join(secrets.choice(chars) for _ in range(length))
