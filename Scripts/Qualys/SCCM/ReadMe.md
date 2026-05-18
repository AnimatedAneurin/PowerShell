# Setup

1. In SCCM, open the properties of an existing Qualys Cloud Agent application package and perform the following checks:
    - Clear the **Admin Comments** and **Software Version** fields.
    - Confirm the detection criteria is correct.
    - Confirm the **Content Location** exists.
    - Confirm the install and uninstall commands are correct.

2. Connect to the SCCM PowerShell ISE session and run the default script to import the SCCM module.

3. Run the following command in PowerShell ISE:

    ```powershell
    Get-CMApplication -Name "[Application Package Name]"
    ```
4. From the returned results, note the value of `ModelName`.

5. Copy `QualysCloudAgentUpdater.ps1` to a local directory on the SCCM server, for example:

    ```text
    C:\EUC\Scripts
    ```

6. Create a new Scheduled Task.

7. Configure the Scheduled Task with the following settings:

    ### General

    ```text
    Name: QualysCloudAgentUpdater
    Description: [Change Reference Number] - Scheduled task that downloads the latest
                QualysCloudAgent.exe from Qualys NFR then adds to the ConfigMgr application
                content, then updates application properties with the correct version, then updates
                the distribution points with this content.
    Run As User: NT AUTHORITY\SYSTEM
    Run with Highest Privileges: Enabled
    ```

    ### Trigger

    ```text
    weekly on a Sunday at 3am
    ```

    ### Action

    ```text
    Program/script:
    PowerShell.exe

    Arguments:
    -executionpolicy bypass -file C:\Scripts\QualysCloudAgentUpdater.ps1 -AppModelName ScopeId_45E2DE75-5715-4A99-800D-41D27C288969/Application_ef4d8348-18aa-4a22-a6fb-601d479adafc -ContentLocation "\\server01\sccmsource$\Applications\Qualys Cloud Agent" -company Qualys -username username -password password -qualysCloudAgentURL https:// -executableA "\\server01\sccmsource$\Applications\Qualys Cloud Agent\QualysCloudAgent.exe" -executableB "C:\Temp\QualysCloudAgent.exe"
    ```

    ### Conditions

    - Disable:
        - `Stop if the computer switches to battery power`

    ### Settings

    ```text
    Stop the task if it runs longer than: 1 hour
    ```

8. Run the Scheduled Task manually to test functionality.

9. Confirm the required files are downloaded to:

    ```text
    C:\Temp
    ```

    Also confirm the Application Package Content Location updates successfully.

10. Confirm the SCCM Application Package updates successfully.

11. Deploy the updated package.