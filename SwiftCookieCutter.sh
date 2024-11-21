#!/bin/bash

# Gebruik:
# `# ./SwiftCookieCutter.sh <projectnaam>`

# Controleer of er een projectnaam is opgegeven
if [ -z "$1" ]; then
  echo "❌ Geef een projectnaam op als argument aan het script."
  exit 1
fi

# Controleer of de juiste commando's beschikbaar zijn
# swift
if ! type "swift" > /dev/null; then
  echo "❌ Please install the Swift Language"
fi

# git
if ! type "git" > /dev/null; then
  echo "❌ Please install the git cli"
fi

# github
if ! type "git" > /dev/null; then
  echo "❌ Please install Github cli (gh)"
fi

# Maak een nieuwe directory voor het project
mkdir "$1"
cd "$1" || exit
echo "✅ Successfully created new project directory"


# Maak een nieuw Swift Package project
echo "🚧 Creating a new Swift Package project"
swift package init
echo "✅ Successfully created a new Swift Package project"

# Om dit in Xcode te laten werk, moet er een `main` struct zijn in de source folder
cat <<EOT > Sources/$1/$1.swift 
@main struct $1 {
    static func main() {
        
    }
}
EOT

# Voeg een test target toe aan de Package.swift
cat <<EOT > Package.swift
// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "$1",
    products: [
        .executable(name: "$1", targets: ["$1"]),
    ],
    dependencies: [
        // Voeg hier afhankelijkheden toe indien nodig
    ],
    targets: [
        .executableTarget(
            name: "$1",
            dependencies: []),
        .testTarget(
            name: "${1}Tests",
            dependencies: ["$1"]),
    ]
)
EOT
echo "✅ Successfully added sample test"

echo ""

echo "🚧 Perform clean build and initial test run"
# Voer schoon opzetten van het project uit voor eventuele fouten
swift build

# Voer de tests uit
swift test
echo "✅ Successfully built project and performed test run"

echo ""

# Creeer een README.md
cat <<EOT > README.md
# $1
EOT

# Creeer een NOTES.md
cat <<EOT > NOTES.md
# Pomodoro Technique - 📝 Notes from the journey 🍅 by 🍅

## 🏷️ Labels

- ✅ done
- 🚧 WIP
- ❌ ERROR
- ⚠️ TODO

## 🍅 Pomodoro 1
EOT

# Creeer een TECHDEBT.md
cat <<EOT > TECHDEBT.md
# Tech debt
EOT

# Creeer een LICENSE
cat <<EOT > LICENSE
MIT License

Copyright (c) 2024 Maarten Engels

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
EOT

echo "✅ Successfully created template README.md, NOTES.md, TECHDEBT.md and LICENSE"

echo ""

# Initialize an empty git and perform first commit
echo "🚧 Initialize git and GitHub repository"
git init
git add .
git commit -m "Initial commit"
gh repo create $1 --public --source=. --remote=upstream
echo "✅ Successfully created git repo and GitHub repository"

echo ""

echo "✅ Swift PM project '$1' succesvol aangemaakt met een executable en tests."
