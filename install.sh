# Trocar o nome da máquina
echo "Digite o novo nome da máquina:"
read novo_nome
sudo hostnamectl set-hostname $novo_nome
echo "Nome da máquina alterado para: $novo_nome"
sudo systemctl restart systemd-hostnamed

# Solicitar a porta ao usuário
echo "Digite a porta para o ambiente Pyxys ser acessado (exemplo: 30002):"
read porta

# Solicitar o IP do servidor de Banco de Dados ao usuário
echo "Digite o IP do Servidor de Banco de Dados (ex. 192.168.4.174(IMP), 192.168.4.173(SUP), 192.168.4.172(DEV):"
read ip

# Solicitar o nome da base de dados ao usuário
echo "Digite o nome do banco:"
read banco

# Solicitar o nome do usuário do Servidor de Banco de Dados ao usuário
echo "Digite o nome do usuário do Servidor de Banco de Dados:"
read usuario

# Solicitar a senha do usuário do Servidor de Banco de Dados ao usuário
echo "Digite a senha do usuário do Servidor de Banco de Dados:"
read senha

# Editar informações do arquivo config_gix-comum-servicos.shx
arquivo="/SHX-PYXIS-SPRGB/SHX-EMBARCADO/config/config_gix-comum-servicos.shx"
echo "# Configurações do servidor" > $arquivo
echo "server.port=$porta" >> $arquivo
echo "server.tomcat.accesslog.enabled=true" >> $arquivo
echo "server.tomcat.accesslog.pattern=\"%h %l %u %t '%r' %s %b %D\"" >> $arquivo
echo "server.tomcat.basedir=/SHX-PYXIS-SPRGB/SHX-EMBARCADO" >> $arquivo
echo "server.servlet.contextPath=/gix-comum-servicos" >> $arquivo
echo "# Configurações para conexão com o banco de dados" >> $arquivo
echo "#sfdb.driver=POSTGRES" >> $arquivo
echo "#sfdb.host=$ip" >> $arquivo
echo "#sfdb.porta=5432" >> $arquivo
echo "#sfdb.database=$banco" >> $arquivo
echo "#sfdb.usuario=$usuario" >> $arquivo
echo "#sfdb.senha=$senha" >> $arquivo
echo "sfdb.showSQL=true" >> $arquivo
echo "sfdb.useSQLComments=true" >> $arquivo
echo "sfdb.formatSQL=true" >> $arquivo
echo "" >> $arquivo
echo "server.ssl.key-store=/SHX-PYXIS-SPRGB/certificados/shx.com.br_fullchain_and_key.p12" >> $arquivo
echo "server.ssl.key-store-password=shxshx01" >> $arquivo
echo "server.ssl.keyStoreType=PKCS12" >> $arquivo
echo "server.ssl.keyAlias=coringa" >> $arquivo
echo "server.ssl.clientAuth=want" >> $arquivo
echo "Informações do arquivo config_gix-comum-servicos.shx editadas."

# Mover o arquivo config_gix-comum-servicos.shx da pasta config para a pasta anterior
origem="/SHX-PYXIS-SPRGB/SHX-EMBARCADO/config/config_gix-comum-servicos.shx"
destino="/SHX-PYXIS-SPRGB/SHX-EMBARCADO/"
mv $origem $destino
echo "Arquivo movido de $origem para $destino"

# Excluir todos os arquivos de dentro da pasta config
pasta="/SHX-PYXIS-SPRGB/SHX-EMBARCADO/config/"
rm -rf $pasta*
echo "Todos os arquivos dentro de $pasta foram excluídos."

# Mover o arquivo config_gix-comum-servicos.shx de volta para a pasta config
origem="/SHX-PYXIS-SPRGB/SHX-EMBARCADO/config_gix-comum-servicos.shx"
destino="/SHX-PYXIS-SPRGB/SHX-EMBARCADO/config/"
mv $origem $destino
echo "Arquivo movido de $origem para $destino"

# Atualizar o EMBARCADÃO
cd /SHX-PYXIS-SPRGB/SHX-EMBARCADO/
wget http://atualizacao.shx.com.br/pyxis/gix-embarcadao/2299/gix-embarcadao.zip --http-user=1564 --http-passwd=3661
sleep 120s  # Esperar 3 minutos para concluir o download
unzip -o gix-embarcadao.zip
sleep 10s  # Esperar 10 segundos

# Alterar permissões e proprietário da pasta /SHX-PYXIS-SPRGB/ recursivamente
chmod 760 -R /SHX-PYXIS-SPRGB/
chown gix:gix -R /SHX-PYXIS-SPRGB/

# Executar o PIXYS como usuário gix
su -l gix -c "DISPLAY=:0 /SHX-PYXIS-SPRGB/SHX-EMBARCADO/shx-embarcado-servicos.sh &"
sleep 10s  # Esperar 10 segundos - SHX@2024!01
tail -f /SHX-PYXIS-SPRGB/SHX-EMBARCADO/log/spring/gix-comum-servicos-log-console.log


echo "Todas as operações foram concluídas."
