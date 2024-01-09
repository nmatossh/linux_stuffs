#!/bin/sh
# SCRIPT DE BACKUP DAS CONFIG DO ZABBIX
# VERSAO 2.x e 3.x
# ESCRITO POR SANSAO
#
# Copyright (C) <2016>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# Contacts:
# Eracydes Carvalho (Sansão Simonton) - NOC Analyst - sansaoipb@gmail.com

export DBNAME=zabbix
export DBUSER=zabbix
export DBPASS=zabbix
export BK_DEST=/home/zabbix/database

sudo /etc/init.d/apache2 stop
sudo /etc/init.d/zabbix-server stop
sudo /etc/init.d/zabbix-agent stop

sudo mkdir -p "$BK_DEST"

# zabbix schema
mysqldump -u"$DBUSER" -p"$DBPASS" -B "$DBNAME" --no-data > "$BK_DEST/$DBNAME-0-schema.sql"

# zabbix config
mysqldump -u"$DBUSER" -p"$DBPASS" -B "$DBNAME" --single-transaction --quick --no-create-info --no-create-db \
--ignore-table="$DBNAME".acknowledges \
--ignore-table="$DBNAME".alerts \
--ignore-table="$DBNAME".auditlog \
--ignore-table="$DBNAME".auditlog_details \
--ignore-table="$DBNAME".events \
--ignore-table="$DBNAME".history \
--ignore-table="$DBNAME".history_log \
--ignore-table="$DBNAME".history_str \
--ignore-table="$DBNAME".history_str_sync \
--ignore-table="$DBNAME".history_sync \
--ignore-table="$DBNAME".history_text \
--ignore-table="$DBNAME".history_uint \
--ignore-table="$DBNAME".history_uint_sync \
--ignore-table="$DBNAME".trends \
--ignore-table="$DBNAME".trends_uint \
> "$BK_DEST/$DBNAME-1-config.sql"

sudo /etc/init.d/apache2 start
sudo /etc/init.d/zabbix-server start
sudo /etc/init.d/zabbix-agent start
