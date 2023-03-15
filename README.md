# ruvbot - Devops using OpenAi ChatGPT Model
This script is a command-line tool that utilizes OpenAI's GPT-3.5 Turbo to generate shell commands based on user input. The script also features a loading animation and provides summaries of command outputs.

Here's a breakdown of the script:

* Define a show_loading function to display a loading animation.
* Print a welcome message with an ASCII art logo representing "rUvbot".
* Define a show_help function that displays usage instructions and script options.
* Check for the -h or --help arguments to show the help message if needed.
* Collect user input and save the current working directory.
* Start the loading animation in the background.
* Define a get_response function to make an API call to OpenAI, passing the user input and a temperature setting for the GPT-3.5 Turbo model.
* Make two API calls with different temperature settings and extract the generated commands from the API responses.
* Stop the background loading animation and clear the loading animation line.
* Display the generated commands as options for the user to choose from.
* Prompt the user to choose a command option or cancel.
* Execute the selected command and store the output in a temporary file.
* Display the command output and, if there is any output, start the loading message again in the background.
* Request a summary of the command output from the GPT-3.5 Turbo model by sending another API call.
* Stop the background loading message and display the summary provided by the model.
* Remove the temporary output file.

## Install & Usage Instructions:

This script was made for linux or the linux subsystem on windows.

Update the OpenAI API Key: Replace <OpenAi_API_Key> in the get_response() function with your actual OpenAI API key. There are two instances where you need to replace this placeholder. The lines are:

### -H 'Authorization: <OpenAi_API_Key>' \  
Replace <OpenAi_API_Key> with your API key, like this:

### -H 'Authorization: Bearer sk-yourapikeyhere' \  
Save the updated script and make it executable. In the terminal, navigate to the directory containing the script and run:

### chmod +x script_name.sh  
Replace script_name.sh with the actual name of the script.

### Run the script with user input:

### ./script_name.sh [OPTIONS] <user_input>  
Replace script_name.sh with the actual name of the script and <user_input> with your desired input.

## Available options:

### -h or --help: Show the help message and exit.  
For example, to run the script with the user input "create a new directory called test", you would execute the following command:

## Sample Script Usage
###  ./script_name.sh create a new directory called test

The script will then provide you with two shell command options generated by the GPT-3.5 Turbo model, based on your input. Choose one of the options or cancel the 
operation. If you proceed, the script will execute the chosen command and provide you with a summary of the command output.

### Networking:
### ./script_name.sh check the IP address of my local machine

The script will provide shell command options to retrieve the IP address of your local machine.

### NPM:
### ./script_name.sh install the express package globally

The script will provide shell command options to install the Express package globally using npm.

### Application deployments:
### ./script_name.sh create a tarball of a directory called my_project

The script will provide shell command options to create a tarball (compressed archive) of a directory named my_project.
