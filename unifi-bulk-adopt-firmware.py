import time
import paramiko

ssh = paramiko.SSHClient()

ssh.set_missing_host_key_policy(paramiko.WarningPolicy)

controller = '' #controller URL
firmware = '' #firmware .bin URL from unifi site

#IP Addresses
device_list = [ 
                "172.16.1.85",
                "172.16.1.95",
                "172.16.1.65",
                "172.16.1.87",
                "172.16.1.60",
                "172.16.1.63",
               ]

for device in device_list:

    try:
        ssh.connect(device, username="ubnt", password="ubnt", timeout=10.0)

        #uncomment for set-inform adoption
        ssh_stdin, ssh_stdout, ssh_stderr = ssh.exec_command(f'/usr/bin/mca-cli-op set-inform {controller}')

        #uncomment for firmware upgrade
        #ssh_stdin, ssh_stdout, ssh_stderr = ssh.exec_command(f'/usr/bin/mca-cli-op upgrade {firmware}')

        print(device)
        print(ssh_stdout.readlines())
        #print(ssh_stderr.readlines())  

        ssh.close()

        print("\n")

        time.sleep(1)      

    except:

        print(f"{device}: Error connecting.")
        
        ssh.close()

        print("\n")
