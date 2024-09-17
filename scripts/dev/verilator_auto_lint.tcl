# Get active file from Quartus through the get_current_file command
# get_current_file gives windows C:/path to the file
# let WSL see this file through the /mnt directory
# use inotify to monitor the file for changes and run the verilator linting
# pipe the result into stdout for now