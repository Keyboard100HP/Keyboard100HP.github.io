#!/bin/bash

# Путь к вашему установщику PKG в DMG
PKG_PATH="./YourAppInstaller.pkg"

# Проверяем статус Gatekeeper
GATEKEEPER_STATUS=$(spctl --status)

if [[ "$GATEKEEPER_STATUS" == "assessments enabled" ]]; then
    # Если Gatekeeper включен:
    echo "Gatekeeper включен. Отключаем..."
    sudo spctl --master-disable

    # Установка вашего приложения
    sudo installer -pkg "$PKG_PATH" -target /

    # Включаем Gatekeeper обратно
    echo "Включаем Gatekeeper обратно..."
    sudo spctl --master-enable
else
    # Если Gatekeeper отключен:
    echo "Gatekeeper отключен. Продолжаем установку..."
    sudo installer -pkg "$PKG_PATH" -target /
fi

# Завершаем скрипт
echo "Установка завершена."
exit 0
