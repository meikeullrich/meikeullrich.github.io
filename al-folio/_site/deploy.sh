#!/bin/bash

# Sicherstellen, dass wir im richtigen Verzeichnis sind
if [ ! -d "_site" ]; then
  echo "_site-Verzeichnis existiert nicht. Stelle sicher, dass du vorher 'bundle exec jekyll build' ausgeführt hast."
  exit 1
fi

# Jekyll build ausführen, falls nicht schon geschehen
echo "Baue die Website..."
bundle exec jekyll build || exit 1

# Änderungen hinzufügen und committen
echo "Füge die Änderungen hinzu und committe..."
git add . || exit 1
git commit -m "update source " || exit 1

# Änderungen zum GitHub-Repo pushen
echo "Push zu GitHub..."
git push origin main || exit 1

# Wechsel zu gh-docroot-Branch
echo "Wechsel zu 'gh-docroot'-Branch..."
git checkout gh-docroot || exit 1

# Lösche alle Dateien im gh-docroot, um Platz für den neuen Inhalt zu schaffen
echo "Lösche alle Dateien im gh-docroot..."
rm -rf * || exit 1

# Holen des _site-Inhalts vom main-Branch
echo "Hole den Inhalt von _site aus dem main-Branch..."
git checkout main -- al-folio/_site || exit 1

# Kopiere den Inhalt von _site nach gh-docroot
echo "Kopiere den Inhalt von _site nach gh-docroot..."
cp -R al-folio/_site/* . || exit 1

# Lösche den al-folio Ordner nach dem Kopieren
echo "Lösche den al-folio Ordner..."
rm -rf al-folio || exit 1

# Änderungen hinzufügen und committen
echo "Füge die Änderungen hinzu und committe..."
git add . || exit 1
git commit -m "update homepage" || exit 1

# Änderungen zum GitHub-Repo pushen
echo "Push zu GitHub..."
git push origin gh-docroot || exit 1

echo "Erfolgreich gepusht!"

