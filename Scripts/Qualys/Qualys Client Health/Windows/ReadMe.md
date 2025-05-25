# Setup

Please configure the Config.xml file with appropiate Client requirements.

Then make sure these files can be read and executed by the targetted machines by sharing them via a UNC path or by other means.

Finally, deploy a GPO with a Scheduled Task referencing both the PowerShell Script and the Config File.

Once done, the PowerShell script will handle the rest.