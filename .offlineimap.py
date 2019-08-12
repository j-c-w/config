import os
import subprocess


def mailpasswd(acct):
    acct = os.path.basename(acct)
    path = os.path.expanduser("~/.passwd/%s.gpg" % acct)
    if not os.path.exists(path):
        print ("Error! You probably need to create and encrypt the password files before you fetch mail.")
        print ("Lacking one for account " + acct)
        print ("Looking for one here: " + path)
        return
    args = ["gpg", "--use-agent", "--quiet", "--batch", "-d", path]

    try:
        return subprocess.check_output(args).strip()
    except subprocess.CalledProcessError:
        return ""


if __name__ == "__main__":
    print("The typical unlock password for the test is 'password'")
    print(mailpasswd("test"))
