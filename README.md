# Description
Docker image for fhem.

# Usage
```Docker
docker create \
  --name=fhem \
  -e TIMEZONE=<<TIMEZONE|default(UTC)>> \
  -e FHEM_VERSION=<<TIMEZONE|default(6.0)>> \
  -p 8083:8083 \
  -v path to fhem.cfg:/etc/fhem.cfg \
  --restart unless-stopped \
  dschinghiskahn/fhem
```
