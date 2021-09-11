import os
import stat
import sys
import requests
import zipfile


BASE_URL = "https://releases.hashicorp.com/terraform/"
TF11_CURRENT = "0.11.14"
TF12_CURRENT = "0.12.18"


def download_tf(arg1):
  tfver = None
  if arg1 == "lnx11":
    tfver = TF11_CURRENT
    platform = "linux"
  if arg1 == "lnx12":
    tfver = TF12_CURRENT
    platform = "linux"
  if arg1 == "mac11":
    tfver = TF11_CURRENT
    platform = "darwin"
  if arg1 == "mac12":
    tfver = TF12_CURRENT
    platform = "darwin"
  if tfver is None:
    print("which tf? choose between lnx11, lnx12, mac11, or mac12!")
    sys.exit()
  fetchfile(tfver, platform)


def fetchfile(tfver, platform):
  dl_url = BASE_URL + tfver + '/terraform_' + \
      tfver + '_' + platform + '_amd64.zip'
  print("this will take a minute or two... downloading")
  reply = requests.get(dl_url, allow_redirects=True)
  if reply.status_code == 200:
    open('temp.zip', 'wb').write(reply.content)
    with zipfile.ZipFile('temp.zip', 'r') as zip_ref:
      zip_ref.extractall('./')
    attrib = os.stat('terraform')
    os.chmod('terraform', attrib.st_mode | stat.S_IEXEC)
    os.remove('temp.zip')
    sys.exit()
  else:
    print(
        f"check hashicorp links for terraform {tfver} version for {platform}")


arg1 = sys.argv[1]
download_tf(arg1)
