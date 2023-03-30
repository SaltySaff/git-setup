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

# Initialize npm project
npm init -y

# Ask user if they want to install ESLint and Prettier
read -p "Do you want to install ESLint and Prettier? (y/n): " install_eslint_prettier

if [ "$install_eslint_prettier" == "y" ]; then
  # Install ESLint and eslint-config-prettier locally
  npm i eslint eslint-config-prettier -D

  # Initialize ESLint configuration
  npx eslint --init

  # Add eslint-config-prettier to the ESLint configuration
  ESLINTRC_FILES=(".eslintrc.json" ".eslintrc.js" ".eslintrc.yaml" ".eslintrc.yml" ".eslintrc")
  for FILE in "${ESLINTRC_FILES[@]}"; do
    if [ -f "$FILE" ]; then
      if [[ "$FILE" == *".json" ]]; then
        jq '.extends += ["prettier"]' "$FILE" > ".tmp" && mv ".tmp" "$FILE"
      elif [[ "$FILE" == *".js" ]]; then
        sed -i "s/extends: \[/extends: \[\"prettier\", /g" "$FILE"
      elif [[ "$FILE" == *".yaml" || "$FILE" == *".yml" ]]; then
        sed -i "s/extends:/extends: [\"prettier\", /g" "$FILE"
        sed -i "/extends: \[\"prettier\", /a ]" "$FILE"
      fi
      break
    fi
  done
fi

# Initiate git repo and commit all files
git init -b main
git add . && git commit -m "Initial commit"

# Create a public GitHub repo
gh repo create --source=. --public --push
echo "Project created and successfully pushed to GitHub!"