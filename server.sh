#!/bin/bash

# Start the Rasa server
rasa run --enable-api --cors "*"

# Start the action server
rasa run actions --actions app/actions --cors "*"
