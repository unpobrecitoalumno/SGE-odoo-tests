#!/bin/bash
PUBLIC_PATH="/home/datos/html/SGE-odoo-tests/"
TESTER_PATH="/home/madrid/Escritorio/SGE/SGE-odoo-project-tester"
FUNCION="accion_01_test_verbose_report"
FECHA=$(date +'%Y%m%d_%H%M%S')
PRIVATE_IP=$(ifconfig $(route -n |awk '/0[.]0[.]0[.]0/{print $NF;exit}') | awk '/inet/{print $2}' | grep -F .)

cd "${TESTER_PATH}"
source run.sh
source .venv/bin/activate
main "$FUNCION" "updated"

cp -r "${TESTER_PATH}/projects/${RESULTS_DIR}/${REPORTS_DIR}/" "${PUBLIC_PATH}/docs/" 

cd "$PUBLIC_PATH"

#!/bin/bash

# Función para generar el index.html en un directorio dado
generate_index() {
  local dir=$1
  local output="$dir/index.html"

  # Iniciar el archivo HTML
  echo "<!DOCTYPE html>" > $output
  echo "<html lang='es'>" >> $output
  echo "<head>" >> $output
  echo "<meta charset='UTF-8'>" >> $output
  echo "<meta name='viewport' content='width=device-width, initial-scale=1.0'>" >> $output
  echo "<title>Índice de Archivos - $dir</title>" >> $output
  echo "</head>" >> $output
  echo "<body>" >> $output
  echo "<h1>Índice de Archivos en el Directorio: $dir</h1>" >> $output
  echo "<ul>" >> $output

  # Listar todos los archivos y carpetas en el directorio
  for item in "$dir"/*; do
    if [ -d "$item" ]; then
      echo "<li><a href='$(basename "$item")'>$(basename "$item")/</a></li>" >> $output
    elif [ -f "$item" ]; then
      echo "<li><a href='$(basename "$item")'>$(basename "$item")</a></li>" >> $output
    fi
  done

  # Cerrar la lista y el HTML
  echo "</ul>" >> $output
  echo "</body>" >> $output
  echo "</html>" >> $output

  echo "El archivo index.html ha sido creado en: $dir"
}

generate_index "docs/"
# Recorrer todos los directorios dentro de docs y generar el índice
for dir in docs/*; do
  if [ -d "$dir" ]; then
    generate_index "$dir"

    # Recursivamente llamar a la función en subdirectorios
    for subdir in "$dir"/*; do
      if [ -d "$subdir" ]; then
        generate_index "$subdir"
      fi
    done
  fi
done


chmod +rx -R docs

git pull
git add docs/\*
git add --all
git commit -m "Tests from ${PRIVATE_IP} on ${FECHA}"
git push
echo "Visit https://unpobrecitoalumno.github.io/SGE-odoo-tests"
