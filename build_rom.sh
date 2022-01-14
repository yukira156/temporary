# sync rom
repo init --depth=1 --no-repo-verify -u git://github.com/LineageOS/android.git -b lineage-17.1 -g default,-mips,-darwin,-notdefault

git clone https://github.com/MinatiScape/local_manifest --depth=1 .repo/local_manifests

repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j8

# build
source build/envsetup.sh
lunch lineage_tiare-user
export TZ=Asia/Kolkata #put before last build command
export BUILD_USERNAME=techyminati
export BUILD_HOSTNAME=cirrus-ci
mka bacon

# get buildate for OTA pushing
cat out/target/product/tiare/system/build.prop | grep "ro.build.date.utc"
# Upload Build
rclone copy out/target/product/$(grep unch $CIRRUS_WORKING_DIR/build_rom.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1)/*.zip cirrus:$(grep unch $CIRRUS_WORKING_DIR/build_rom.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1) -P
