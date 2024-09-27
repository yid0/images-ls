set -e 

echo "clean unused jars : $JARS_TO_DELETE "

for jar in $JARS_TO_DELETE; do 
    find ${KEYCLOAK_DIR}/lib/ -type f -name "$jar" -exec rm -f {} \; 
done

echo "cleaned unused jars"

exit 0;