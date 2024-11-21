#!/bin/bash

# Gebruik:
# `# ./SwiftCookieCutter.sh <projectnaam>`

# Controleer of er een projectnaam is opgegeven
if [ -z "$1" ]; then
  echo "Geef een projectnaam op als argument aan het script."
  exit 1
fi

# Maak een nieuwe directory voor het project
mkdir "$1"
cd "$1" || exit

# Maak een nieuw Swift Package project
swift package init

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

# Voer schoon opzetten van het project uit voor eventuele fouten
swift build

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

# Initialize an empty git and perform first commit
git init
git add .
git commit -m "Initial commit"

echo "Swift PM project '$1' succesvol aangemaakt met een executable en tests."
