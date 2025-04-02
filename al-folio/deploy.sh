#!/bin/bash

bundle exec jekyll build || exit 1

# Aktuellen Branch speichern
CURRENT_BRANCH=$(git branch --show-current)

# Aktuelle Änderungen speichern (falls vorhanden)
git push 

# Temporäres Verzeichnis für den gh-docroot-Branch erstellen
mkdir -p /tmp/gh-docroot-temp

# Nur den gewünschten Ordner aus dem main-Branch auschecken
git --work-tree=/tmp/gh-docroot-temp checkout main -- al-folio/_site/

# Zum gh-docroot-Branch wechseln
git checkout gh-docroot

# ALLE vorhandenen Dateien löschen (außer .git)
find . -mindepth 1 -maxdepth 1 -not -name ".git" -exec rm -rf {} \;

# Dateien kopieren
cp -r /tmp/gh-docroot-temp/al-folio/_site/* ./

# Temporäres Verzeichnis löschen
rm -rf /tmp/gh-docroot-temp

# Änderungen zum Commit vorbereiten
git add .

# Änderungen committen
git commit -m "Replace all content with files from al-folio/_site"
git push

# Zurück zum ursprünglichen Branch wechseln
git checkout "$CURRENT_BRANCH"

# Stash wiederherstellen, falls vorhanden
#git stash pop
