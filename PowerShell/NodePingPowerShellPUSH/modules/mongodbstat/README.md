# mongodbstat module

## Description

Allows you to evaluate a string in mongodb to see if it is still accepting queries.
The metric will fail if there is an error message in the body that you consider to
be a fail.

## Configuration

Supply a string that you want to have evaluated in the `mongodbstat.json` file. Then
set a value for the `expected_message` parameter that, if the value is found in the
resulting output, then sets the metric to pass.


