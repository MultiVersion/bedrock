#! /bin/bash
cd /home/container

if [[ -z $D_DISABLE_SMART ]]; then
  wget -q https://multiversion.dviih.software/md5sums.txt -O md5sums.txt
  sed -i "s/${D_MINECRAFT_VARIANT,,}-$D_MINECRAFT_VERSION.phar/$D_FILE/g" /home/container/md5sums.txt
  echo "d01bb0715da885bc9c58d1bd7d9f5e59 $D_FILE" >> md5sums.txt
fi

echo "MultiVersion 21.08 LTS | github.com/MultiVersion"

# | Check everything
if [[ -z $D_MINECRAFT_VERSION || -z $D_MINECRAFT_VARIANT ]]; then
  echo "You need to put what you want in startup tab!"
  echo "If you need pocketmine just set minecraft variant to pocketmine or if you want bedrock server just use bedrockserver"
  exit 1
fi

# | Smart (PocketMine Only)
if [[ ${D_MINECRAFT_VARIANT,,} == "pocketmine" && -z "$D_DISABLE_SMART" && ! $(md5sum -c md5sums.txt 2>/dev/null | grep OK$ | awk '{print $2}') == "OK" ]]; then
  wget -q https://multiversion.dviih.software/${D_MINECRAFT_VARIANT,,}-${D_MINECRAFT_VERSION}.phar -O $D_FILE
  rm md5sums.txt
fi

# | Smart (BedrockServer Only)
if [[ ${D_MINECRAFT_VARIANT,,} == "bedrockserver" && -z "$D_DISABLE_SMART" && ! $(md5sum -c md5sums.txt 2>/dev/null | grep OK$ | awk '{print $2}') == "OK" ]]; then
  wget -q https://minecraft.azureedge.net/bin-linux/bedrock-server-1.17.11.01.zip -O $D_FILE
  unzip bedrock-server-1.17.11.01.zip
  if [[ ! $D_FILE == "bedrock_server" ]]; then
    mv bedrock_server $D_FILE
  fi
  rm bedrock-server-1.17.11.01.zip
  rm md5sums.txt
fi

# | Server Startup
if [[ ${D_MINECRAFT_VARIANT,,} == "pocketmine" ]]; then
  rm md5sums.txt
  exec "/opt/bin/php7/bin/php" "${D_FILE}" --no-wizard
  exit 1
fi

if [[ ${D_MINECRAFT_VARIANT,,} == "bedrockserver" ]]; then
  rm md5sums.txt
  ./$D_FILE
  exit 1
fi