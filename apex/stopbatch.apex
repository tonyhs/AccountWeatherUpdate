for ( AsyncApexJob aJob : [ Select id ,Status from AsyncApexJob LIMIT 100] )
{
System.AbortJob(aJob.Id);
}