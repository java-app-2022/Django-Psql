#!/bin/bash
echo "{\"ImageURI\": \"796638590183.dkr.ecr.us-east-2.amazonaws.com/kanban-app:$COMMIT_HASH\"}" > imageDetail.json
