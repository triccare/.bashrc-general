# ##########
# Generic tools
# ##########

# ##########
# Fetch file directly from MAST archive
function fetch_mast() {
    local fname=${1:?"Usage fetch_mast <filename> **Remember to set MAST token**"}

    curl -H "Authorization: token $MAST_API_TOKEN" \
         --globoff \
         --location-trusted \
         -f --progress-bar \
         -J -O \
         "https://mast.stsci.edu/api/v0.1/Download/file?uri=mast:JWST/product/${fname}"
}

# ##########
# Show association pools in browser
function viewpool() {
    local pool=${1:?"Usage: viewpool <poolfile>"}
    python -c "from jwst.associations import AssociationPool; AssociationPool.read('${pool}').show_in_browser(jsviewer=True)"
}
