# Lighting Reality

## The Uninstall Script

### Summary

This script is to uninstall Lighting Reality(LR) and Lighting Reality Reader by modifying a RegKey Property Value to allow uninstallation to take place,
to which the uninstaller(s) removes both applications and then the RegKey Property Value is reverted back to its default value.
On top of this, the script will remove any cached data containing the License information so that users have to enter the License Key upon reinstallation.
This script also makes use of Generating logs and its own error code system.

### More Information

The above summary is what is used in the metadata of the script. To explain further; Lighting Reality(LR) was not a just a simple uninstall as the application unpacks itself in many areas of the EUD upon installation. The basic uninstaller **(C:\Program Files (x86)\Lighting Reality\unins000.exe)** that comes with the application does not remove all areas of Lighting Reality, hence the script was made.

It was discovered that in the installation of Lighting Reality with all default option used, typically due to the Silent install, that Lighting Reality Reader gets installed along with it. Now with the uninstaller mentioned above, this will not remove this LR Reader. We managed to find that there is a separate uninstaller just for LR Reader, which is located here: **"C:\Program Files\Softland\novaPDF 7\unins000.exe"**

Another thing that was discovered was the uninstalls would NOT take place if a particular RegKey Property was enabled. After doing some research on an error that would appear on-screen when attempting to uninstall LR and LR Reader, we found that a RegKey Property named **"ValidateAdminCodeSignatures"** was preventing the uninstallation. Once setting the value to 0 no issues/errors occurred. This would obviously be reverted back to its default of 1 at the end of the script as changing the value is only used as a temporary solution.

It was later found during testing that the License Key would not be required to be entered upon reinstallation on the same device. This is because the uninstaller that is part of LR doesn't remove everything, as stated previously. There are a few areas where it caches the Licence information within the appdata of the user, and it also caches it in the ProgramData of the system. The file name is the exact same in all cached locations to which it is called **rdata.ini**. To resolve this we have put within the script to remove/delete the folders of which these files are located in, so that when the application does get reinstalled onto the device it will prompt the user for the License Key.