#!/usr/bin/env bash

#
# Copyright (C) 2019 Saalim Quadri (danascape)
#
# SPDX-License-Identifier: Apache-2.0 license
#

# Set necessary var
CURRENT_DIR=$(pwd)

# Update uart file
if [[ -f data.txt ]]; then
   echo "script: JSON found!"
else
   exit 1
fi

cat data.txt | sed 's/: /\n/g' | awk '/Temperature|Humidity|soilMoisture/ {print $0}'

THING=$(cat sort.txt | tail -n 5 | head -n 1 | awk '{print $2}')
VALUE=$(cat sort.txt | tail -n 5 | head -n 1 | awk '{print $1}')
if [ "$THING" = "Humidity" ]; then
	echo "humidity found"
    HUMIDITY_DATA=$VALUE
elif [ "$THING" = "Temperature" ]; then
	echo "temp found"
    TEMPERATURE_DATA=$VALUE
elif [ "$THING" = "soilMoisture" ]; then
	echo "soil found"
    SOILMOISTURE_DATA=$VALUE
fi

THING2=$(cat sort.txt | tail -n 4 | head -n 1 | awk '{print $2}')
VALUE2=$(cat sort.txt | tail -n 4 | head -n 1 | awk '{print $1}')
if [ "$THING2" = "Humidity" ]; then
	echo "humidity2 found"
    HUMIDITY_DATA=$VALUE2
elif [ "$THING2" = "Temperature" ]; then
	echo "temp2 found"
    TEMPERATURE_DATA=$VALUE2
elif [ "$THING2" = "soilMoisture" ]; then
	echo "soil2 found"
    SOILMOISTURE_DATA=$VALUE2
fi

THING3=$(cat sort.txt | tail -n 3 | head -n 1 | awk '{print $2}')
VALUE3=$(cat sort.txt | tail -n 3 | head -n 1 | awk '{print $1}')
if [ "$THING3" = "Humidity" ]; then
	echo "humid3 found"
    HUMIDITY_DATA=$VALUE3
elif [ "$THING3" = "Temperature" ]; then
	echo "temp3 found"
    TEMPERATURE_DATA=$VALUE3
elif [ "$THING3" = "soilMoisture" ]; then
echo "soil3 found"
    SOILMOISTURE_DATA=$VALUE3
fi

echo $HUMIDITY_DATA
echo $TEMPERATURE_DATA
echo $SOILMOISTURE_DATA

AIRQUALITY_DATA=0
PLANT_DATA=0
DISEASE_DATA=0
# Generate json
genJSON() {
    GEN_JSON_BODY=$(jq --null-input \
                    --arg humidity "$HUMIDITY_DATA" \
                    --arg temperature "$TEMPERATURE_DATA" \
                    --arg soilmoisture "$SOILMOISTURE_DATA" \
                    --arg airquality "$AIRQUALITY_DATA" \
                    --arg plant "$PLANT_DATA" \
                    --arg disease "$DISEASE_DATA" \
                    "{"humidity": \"$HUMIDITY_DATA\", "temperature": \"$TEMPERATURE_DATA\", "soilmoisture": \"$SOILMOISTURE_DATA\", "airquality": \"$AIRQUALITY_DATA\", "plant": \"$PLANT_DATA\", "disease": \"$DISEASE_DATA\"}")
    echo $GEN_JSON_BODY
    if [[ -f json/data.json ]]; then
        rm json/data.json
    fi
    echo "$GEN_JSON_BODY" >> json/plant.json
}

genJSON
