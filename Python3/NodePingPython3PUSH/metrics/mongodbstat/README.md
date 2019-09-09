# mongodbstat module

## Description

Allows you to evaluate a command in mongodb to see if it is still accepting queries.
The metric will pass if the output contains a match of the specified output that
you expect.

## Configuration

Supply a string that you want to have evaluated in the `config.py` file. Then
set a value for the `expected_message` parameter that, if the value is found in the
resulting output, then sets the metric to pass. Be sure to pay attention to escape
characters as necessary. 
