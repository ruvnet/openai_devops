#!/bin/bash

#  DAA - Decentralized Autonomous Application 
#        /\__/\   - daa.rs 
#       ( o.o  )  - v0.0.1
#         >^<     - by @rUv


# Function to display a loading animation
show_loading() {
  local delay=0.1
  while true; do
    for i in '-' '\\' '|' '/'; do
      printf "\r\033[0;34m 🤖ruvBot Fetching Data %s\033[0m" "$i"  # Change the text here
      sleep "$delay"
    done
  done
}


echo ""
echo "    ___T_     "
echo "   | o o |    "
echo "   |__-__|    "
echo "   /| []|\    "
echo " ()/|___|\()  "
echo "    |   |   "
echo " rUvbot v0.01"
echo ""
# echo "Loading OpenAi Data - Please Wait"

show_help() {
  echo "Usage: $(basename "$0") [OPTIONS] <user_input>"
  echo ""
  echo "Options:"
  echo "  -h, --help    Show this help message and exit"
  echo ""
  echo "This script takes user input and generates shell commands based on the input using OpenAI's GPT-3.5 Turbo."
  echo ""
  echo "Common Commands:"
  echo "  File Management & Storage:"
  echo "    ls              List files and directories in the current directory"
  echo "    cd              Change the current working directory"
  echo "    mkdir           Create a new directory"
  echo "    touch           Create a new file"
  echo "    rm              Remove a file or directory"
  echo "    cp              Copy a file or directory"
  echo "    mv              Move or rename a file or directory"
  echo ""
  echo "  Networking:"
  echo "    ping            Test network connectivity to a host"
  echo "    curl            Transfer data from or to a server"
  echo "    ssh             Connect to a remote server securely"
  echo ""
  echo "  Coding:"
  echo "    Rust:"
  echo "      cargo         Package manager for Rust"
  echo "      rustc         Rust compiler"
  echo ""
  echo "    Python:"
  echo "      pip           Package installer for Python"
  echo "      python        Python interpreter"
  echo ""
  echo "    NPM:"
  echo "      npm           Package manager for Node.js"
  echo "      node          Node.js runtime environment"
  echo ""
  echo "    AWS:"
  echo "      awscli        Command-line interface for AWS"
}


# Check for help argument
for arg in "$@"; do
  case $arg in
    -h|--help)
      show_help
      exit 0
      ;;
  esac
done


# get user cli arguments as a string
args=$*

# save the current working directory to a variable
cwd=$(pwd)

if [ -z "$args" ]; then
  echo "⚠️ Error: No input provided."
  exit 1
fi

# Start the loading animation in the background
show_loading &

# Save the process ID of the background loading animation
loading_pid=$!


# function to make an API call with a given temperature
get_response() {
  local temperature=$1
  curl -s https://api.openai.com/v1/chat/completions \
    -H 'Content-Type: application/json' \
    -H 'Authorization: Bearer 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' \
    -d '{
    "model": "gpt-3.5-turbo",
    "messages": [{"role": "system", "content": "You are a helpful assistant. You will generate '"$SHELL"' commands based on user input. Your response should contain ONLY the command and NO explanation. Do NOT ever use newlines to separate commands, instead use ; or &&. The current working directory is '"$cwd"'."}, {"role": "user", "content": "'"$args"'"}],
    "temperature": '"$temperature"',
    "max_tokens": 200,
    "top_p": 0.1,
    "stream": false
  }'
}

# make two API calls with different temperatures
response1=$(get_response 0)
response2=$(get_response 1.8)

# extract the generated commands
cmd1=$(echo $response1 | jq '.choices[0].message.content' | sed -e 's/^.//' -e 's/.$//')
cmd2=$(echo $response2 | jq '.choices[0].message.content' | sed -e 's/^.//' -e 's/.$//')


# After receiving the responses, stop the background loading animation
kill -15 $loading_pid
wait $loading_pid 2>/dev/null

# Clear the loading animation line
echo -e "\r\e[2K"

echo "⭐ Option 1: $cmd1"
echo "⭐ Option 2: $cmd2"

# make the user confirm the command
read -p "Choose an option (1/2) or type 'c' to cancel: " choice

case $choice in
  1) selected_cmd=$cmd1 ;;
  2) selected_cmd=$cmd2 ;;
  [Cc]) echo "Aborted."; exit 0 ;;
  *) echo "⚠️ Invalid choice. Aborted."; exit 1 ;;
esac

echo "Executing command: $selected_cmd"
echo ""

# save command to file, execute the command from file, remove the file
echo "$selected_cmd" > ".tempplscmd"
source ".tempplscmd"
cd "$cwd"
rm ".tempplscmd"


# Execute the command and store the output in a temporary file
temp_output_file=".temp_output_file"
bash -c "$selected_cmd" > "$temp_output_file"

# Read the contents of the temporary file and display the output
output=$(cat "$temp_output_file")
echo "Command output:"
echo "$output"
echo ""


if [ -z "$output" ]; then
  echo "No output to summarize."
else
  # Start the loading message in the background
  show_loading "🤖 Loading OpenAI Data - Please Wait" &

  # Save the process ID of the background loading message
  loading_pid=$!

  # Remove newlines and escape double quotes in the output to prevent JSON parsing errors
  output=$(echo "$output" | tr '\n' ' ' | sed 's/"/\\"/g')

  # Request a summary of the output from the AI model
  summary_request='{
    "model": "gpt-3.5-turbo",
    "messages": [
      {"role": "system", "content": "You are a helpful assistant. Summarize the following command output in a clear and concise manner."},
      {"role": "user", "content": "'"$output"'"}
    ],
    "temperature": 0.5,
    "max_tokens": 2000,
    "top_p": 0.9,
    "stream": false
  }'

  summary_response=$(curl -s https://api.openai.com/v1/chat/completions \
    -H 'Content-Type: application/json' \
    -H 'Authorization: Bearer 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' \
    -d "$summary_request")

  # Stop the background loading message by sending a SIGTERM signal
  kill -15 $loading_pid
  wait $loading_pid 2>/dev/null

  # Extract and display the summary, overwriting the loading message
  summary=$(echo $summary_response | jq '.choices[0].message.content' | sed -e 's/^.//' -e 's/.$//')
  echo -e "\r\e[2KSummary of the output:"
  echo ""
  echo "$summary"
  echo ""
fi

# Remove the temporary output file
rm "$temp_output_file"
