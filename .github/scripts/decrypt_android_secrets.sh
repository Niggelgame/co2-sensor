#!/bin/sh


echo $(pwd)
# --batch to prevent interactive command
# --yes to assume "yes" for questions
gpg --quiet --batch --yes --decrypt --passphrase="$ANDROID_KEYS_SECRET_PASSPHRASE" \
--output app/android/android_keys.zip app/android/android_keys.zip.gpg && cd app/android && jar xvf android_keys.zip && cd -