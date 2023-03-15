# ruvbot openai_devops
This script is a command-line tool that utilizes OpenAI's GPT-3.5 Turbo to generate shell commands based on user input. The script also features a loading animation and provides summaries of command outputs.

This script is a command-line tool that utilizes OpenAI's GPT-3.5 Turbo to generate shell commands based on user input. The script also features a loading animation and provides summaries of command outputs. Here's a breakdown of the script:

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
