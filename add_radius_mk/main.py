import hashlib
import paramiko
from time import sleep
import sys

list_markets = {
    'market_name': 'market_ip'
}

puser = 'user'
ppasswd = 'passwd'


def get_market_from_ip(ip):
    market = ''
    ip_split = ip.split('.')

    if ip_split[1] == '30':
        if int(ip_split[2]) <= 9:
            market = f'h00{ip_split[2]}mk'
        if 9 < int(ip_split[2]) <= 99:
            market = f'h0{ip_split[2]}mk'
        if 99 < int(ip_split[2]):
            market = f'h{ip_split[2]}mk'

    if ip_split[1] == '31':
        if int(ip_split[2]) <= 9:
            market = f'h20{ip_split[2]}mk'
        if 9 < int(ip_split[2]) <= 99:
            market = f'h2{ip_split[2]}mk'
        if 99 < int(ip_split[2]):
            market = f'h3{str(ip_split[2][1:])}mk'
    if ip_split[1] != '30' and ip_split[1] != '31':
        market = None

    return market

def get_start():
    ip = sys.argv[1]

# print(market)
    if get_market_from_ip(ip) is None:
        print('IP not correct!')
        
    if get_market_from_ip(ip) is not None:
        hash_passwd = hashlib.md5(get_market_from_ip(ip).encode()).hexdigest().upper()
        print(hash_passwd)
        client = paramiko.client.SSHClient()
        client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        client.connect(ip, username=puser, password=ppasswd)

        sleep(2)
        _stdin, _stdout, _stderr = client.exec_command(f'/radius remove [/radius find]')
        sleep(2)
        _stdin, _stdout, _stderr = client.exec_command(f'/radius add address=192.168.98.109 secret={hash_passwd} service=login src-address={ip}')
        sleep(2)
        _stdin, _stdout, _stderr = client.exec_command(f'/user aaa set use-radius=yes default-group=read')


if __name__ == '__main__':
    get_start()