# Action Plan

1. Modify the present script to write the output to a text file. There is one issue that needs to be addressed here. Let us say Vijith is using the script starting from his
   first game, and he **continuously** plays 10 games. He stops after 10 games. Then, there should be a single file corresponding to these 10 games. In other words, as long
   as one player continuously uses the script, it should produce only a single file. Though there is no issue in producing a separate file for each run, I think it will be
   difficult later to process a large number of files. Probably, we can put an outer loop in the present script, which will keep the script alive without terminating, and can
   be run again by pressing a key. This will keep on **appending** the results to the end of a text file, which will be uploaded to the cloud.

2. A proper responsive set up for cloud syncing. Ideally, it should be able to resync whenever the contents of the text file is changed. If not possible, a periodic syncing.
   May be dropbox? It seems this can be done in the script itself, if we use dropbox. There is a command for resynchronizing a folder. Each time after the text file is updated,
   this command can be executed from the script itself.

3. An information compiling set up, which will, a) take the information available from all the text files produced and saved by different users of the script, b) merge the information
   available from these text files by avoiding redundant information, and, c) process the final content to produce an output in the required format.

## TBD later

1. Avoid the requirement of a user running the script each time after a game. The script should be able to periodically go and fetch the data from liveplayok, and update the text file.
