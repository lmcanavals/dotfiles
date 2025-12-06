# uncommenting locales
f="$(GetPackageOriginalFile glibc /etc/locale.gen)"
sed -i 's/^#\(en_US.UTF-8\)/\1/g' "$f"
sed -i 's/^#\(en_DK.UTF-8\)/\1/g' "$f"
sed -i 's/^#\(es_PE.UTF-8\)/\1/g' "$f"
