#!/usr/bin/env python3
# Copies IPAs downloaded with Apple Configurator to ~/Downloads.
# Download an app with Apple Configurator using Add -> Apps in the toolbar.

import os
import shutil
import getpass
import errno
import time
import zipfile
import plistlib

def report_walk_error(error):
  if error.errno == errno.ENOENT:
    return
  raise SystemExit(f"Cannot scan Apple Configurator downloads: {error}")

def archive_filename(path):
  fallback = os.path.basename(path)
  if not fallback.endswith(".ipa"):
    fallback += ".ipa"
  with zipfile.ZipFile(path) as archive:
    for entry in archive.namelist():
      parts = entry.split("/")
      if len(parts) != 3 or parts[0] != "Payload" or not parts[1].endswith(".app") or parts[2] != "Info.plist":
        continue
      try:
        info = plistlib.loads(archive.read(entry))
      except (plistlib.InvalidFileException, ValueError, TypeError):
        return fallback
      if not isinstance(info, dict):
        return fallback
      name = next((info.get(key) for key in ("CFBundleDisplayName", "CFBundleName", "CFBundleIdentifier")
                   if isinstance(info.get(key), str) and info[key].strip()), None)
      if name is None:
        return fallback
      version = info.get("CFBundleShortVersionString") or info.get("CFBundleVersion")
      label = f"{name} {version}" if isinstance(version, str) and version.strip() else name
      label = "".join("_" if char in "/:\\" or ord(char) < 32 or ord(char) == 127 else char for char in label)
      label = label.strip(" .")[:200].rstrip(" .")
      return label + ".ipa" if label else fallback
  return fallback

def is_app_archive(path):
  try:
    with zipfile.ZipFile(path) as archive:
      return any(name.startswith("Payload/") and name.endswith(".app/Info.plist")
                 for name in archive.namelist())
  except (FileNotFoundError, zipfile.BadZipFile):
    return False

def main():
  username = getpass.getuser()
  appsDir = "/Users/" + username + "/Library/Group Containers/K36BKF7T3D.group.com.apple.configurator/Library/Caches/Assets/TemporaryItems/MobileApps" # replace USER
  ipaDir = "/Users/" + username + "/Downloads/"

  if not os.path.exists(ipaDir):
    os.makedirs(ipaDir)

  print("Looking for IPA files..")
  ipaList = []
  while True:
    for root, dirs, files in os.walk(appsDir, onerror=report_walk_error):
      for file in files:
        ipaPath = os.path.join(root, file)
        if ipaPath in ipaList:
          continue
        if (file.endswith(".ipa") or file.isdecimal()) and is_app_archive(ipaPath):
          destination = archive_filename(ipaPath)
          shutil.copy2(ipaPath, os.path.join(ipaDir, destination))
          ipaList.append(ipaPath)
          print(f"Copied {destination}")
    time.sleep(0.1)

if __name__ == "__main__":
  try:
    main()
  except KeyboardInterrupt:
    print("\nStopped.")
