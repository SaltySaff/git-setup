#!/bin/bash

# Get project name from user input
read -p "Enter project name: " project_name

# Create a new directory for the project
mkdir "$project_name"

# Move into the directory
cd "$project_name"

# Create a README file with project name as title
echo "# $project_name" > README.md

# Copy index.html boilerplate from templates/index.html
cp ~/Scripts/git-setup/templates/index.html .

# Create blank style.css, and script.js files
touch style.css script.js
echo "Creating directory and files..."

# Initiate git repo and commit all files
git init -b main
git add . && git commit -m "Initial commit"

# Create a public GitHub repo
gh repo create --source=. --public --push
echo "Project created and successfully pushed to GitHub!"



