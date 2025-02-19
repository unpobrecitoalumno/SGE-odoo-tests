#!/bin/bash
PUBLIC_PATH="/home/datos/html/SGE-odoo-tests/"
TESTER_PATH="/home/madrid/Escritorio/SGE/SGE-odoo-project-tester-2DAMB"
FUNCION="accion_01_test_verbose_report"
FECHA=$(date +'%Y%m%d_%H%M%S')
PRIVATE_IP=$(ifconfig $(route -n |awk '/0[.]0[.]0[.]0/{print $NF;exit}') | awk '/inet/{print $2}' | grep -F .)

cd "${TESTER_PATH}"
source run.sh
source .venv/bin/activate
main "$FUNCION" "all"

cp -r "${TESTER_PATH}/projects/${RESULTS_DIR}/${REPORTS_DIR}/" "${PUBLIC_PATH}/reports_${FECHA}" 

cd "$PUBLIC_PATH"
chmod +rx -R reports_*
git pull
git add --all
git commit -m "Tests on ${FECHA}"
git push
echo "Visit https://unpobrecitoalumno.github.io/SGE-odoo-tests"


#@reboot /ruta/al/script/test_verbose_report.sh
#15 11 * * * /ruta/al/script/test_verbose_report.sh
#15 18 * * * /ruta/al/script/test_verbose_report.sh

