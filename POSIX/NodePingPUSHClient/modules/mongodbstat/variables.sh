# This string will be evaluated by mongo with the --eval flag
eval_string="db.runCommand( {connectionStatus: 1});"
# All of or a portion of what you expect in the result to be successful
expected_message="\"ok\" : 1"
# Optional user authentication
username=""
# Optional password authentication
password=""

