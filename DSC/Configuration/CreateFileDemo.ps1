Configuration CreateFileDemo
{

   $samplestr = Get-AutomationVariable –Name 'DownloadPackagesPath'

    Node "localhost"
    {
       
        File CreateFile {
            DestinationPath = 'C:\myTest.txt'
            Ensure = "Present"
            Contents = $samplestr
        }
       
    }
}