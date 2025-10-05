# Copies IPAs downloaded with Apple Configurator to ~/Downloads.
# Download an app with Apple Configurator using Add -> Apps in the toolbar.

import os
import shutil
import getpass

username = getpass.getuser()
appsDir = "/Users/" + username + "/Library/Group Containers/K36BKF7T3D.group.com.apple.configurator/Library/Caches/Assets/TemporaryItems/MobileApps" # replace USER
ipaDir = "/Users/" + username + "/Downloads/"

if not os.path.exists(ipaDir):
  os.makedirs(ipaDir)

print("Looking for IPA files..")
ipaList = []
while True:
  for root, dirs, files in os.walk(appsDir):
    for file in files:
      if file.endswith(".ipa"):
        if os.path.join(root, file) in ipaList:
          continue
        ipaPath = os.path.join(root, file)
        ipaList.append(ipaPath)
        shutil.copy2(ipaPath, os.path.join(ipaDir, file))
        print(f"Moved {file}")
